import 'package:washgo/dataconnect-generated/example.dart';

class WashGoUser {
  final String uid;
  final String nombreCompleto;
  final String email;
  final String? telefono;
  final String? direccion;
  final List<UserRole> roles;
  final EmployeeStatus employeeStatus;
  final String? currentBusinessId;
  final String? currentBusinessName;
  final String? fotoPerfil;

  const WashGoUser({
    required this.uid,
    required this.nombreCompleto,
    required this.email,
    this.telefono,
    this.direccion,
    required this.roles,
    required this.employeeStatus,
    this.currentBusinessId,
    this.currentBusinessName,
    this.fotoPerfil,
  });
}
