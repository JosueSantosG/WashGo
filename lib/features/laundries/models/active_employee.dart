class ActiveEmployeeUser {
  final String id;
  final String nombreCompleto;
  final String email;
  final String? telefono;
  final String? fotoPerfil;

  const ActiveEmployeeUser({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    this.telefono,
    this.fotoPerfil,
  });
}

class ActiveEmployee {
  final String id;
  final ActiveEmployeeUser employee;
  final bool estadoDisponibilidad;

  const ActiveEmployee({
    required this.id,
    required this.employee,
    required this.estadoDisponibilidad,
  });
}

class EmployeeAvailability {
  final String id;
  final bool estadoDisponibilidad;

  const EmployeeAvailability({
    required this.id,
    required this.estadoDisponibilidad,
  });
}
