import 'package:flutter/foundation.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/auth/models/washgo_user.dart';
import 'package:washgo/features/auth/models/business_summary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<List<UserRole>> getCurrentUserRoles() async {
    final response = await _connector.getCurrentUser().ref().execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    if (response.data.user != null) {
      final rolesEnum = response.data.user!.roles;
      return rolesEnum
          .map((e) => e is Known<UserRole> ? e.value : null)
          .whereType<UserRole>()
          .toList();
    }
    return [];
  }

  @override
  Future<WashGoUser?> getCurrentUser() async {
    final response = await _connector.getCurrentUser().ref().execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    final user = response.data.user;
    if (user == null) return null;

    final rolesEnum = user.roles;
    final roles = rolesEnum
        .map((e) => e is Known<UserRole> ? e.value : null)
        .whereType<UserRole>()
        .toList();

    final status = user.employeeStatus is Known<EmployeeStatus>
        ? (user.employeeStatus as Known<EmployeeStatus>).value
        : EmployeeStatus.UNASSIGNED;

    return WashGoUser(
      uid: user.id,
      nombreCompleto: user.nombreCompleto,
      email: user.email,
      telefono: user.telefono,
      direccion: null,
      roles: roles,
      employeeStatus: status,
      currentBusinessId: user.currentBusiness?.id,
      currentBusinessName: user.currentBusiness?.nombre,
      fotoPerfil: user.fotoPerfil,
    );
  }

  @override
  Future<void> upsertUser({
    required String nombreCompleto,
    required String email,
    required List<UserRole> roles,
    String? telefono,
    String? direccion,
    String? fotoPerfil,
  }) async {
    var builder = _connector.upsertUser(
      email: email,
      nombreCompleto: nombreCompleto,
      roles: roles,
    );
    if (telefono != null) {
      builder = builder.telefono(telefono);
    }
    if (fotoPerfil != null) {
      builder = builder.fotoPerfil(fotoPerfil);
    }
    await builder.execute();
  }

  @override
  Future<BusinessSummary?> getBusinessByCode(String code) async {
    final response = await _connector.getBusinessByCode(code: code).execute();
    if (response.data.businesses.isEmpty) return null;
    final b = response.data.businesses.first;
    return BusinessSummary(
      id: b.id,
      nombre: b.nombre,
      descripcion: b.descripcion,
    );
  }

  @override
  Future<void> requestEmployeeAccess(String businessId) async {
    await _connector.requestEmployeeAccess(businessId: businessId).execute();
  }

  @override
  Future<void> updateUserPhone(String telefono) async {
    await _connector.updateUserPhone(telefono: telefono).execute();
  }

  @override
  Future<void> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      try {
        await _connector
            .deleteCurrentUser(
              email: 'deleted-$uid@washgo.app',
              nombreCompleto: 'Usuario Eliminado',
            )
            .execute();
      } catch (e) {
        // Log the error but proceed with Firebase Auth deletion to guarantee account termination
        debugPrint('Error deleting user record from Data Connect: $e');
      }
      await currentUser.delete();
    }
  }
}
