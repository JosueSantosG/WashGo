class EmployeeRequestUser {
  final String id;
  final String nombreCompleto;
  final String email;
  final String? telefono;
  final String? fotoPerfil;

  const EmployeeRequestUser({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    this.telefono,
    this.fotoPerfil,
  });
}

class EmployeeRequest {
  final String id;
  final EmployeeRequestUser user;

  const EmployeeRequest({
    required this.id,
    required this.user,
  });
}
