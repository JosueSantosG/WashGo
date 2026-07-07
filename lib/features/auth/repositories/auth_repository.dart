import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/auth/models/washgo_user.dart';
import 'package:washgo/features/auth/models/business_summary.dart';

abstract class AuthRepository {
  Future<List<UserRole>> getCurrentUserRoles();
  
  Future<WashGoUser?> getCurrentUser();
  
  Future<void> upsertUser({
    required String nombreCompleto,
    required String email,
    required List<UserRole> roles,
    String? telefono,
    String? direccion,
    String? fotoPerfil,
  });
  
  Future<BusinessSummary?> getBusinessByCode(String code);
  
  Future<void> requestEmployeeAccess(String businessId);

  Future<void> updateUserPhone(String telefono);

  Future<void> deleteAccount();
}

