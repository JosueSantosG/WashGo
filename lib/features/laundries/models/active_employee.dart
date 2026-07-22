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
  final bool isDisabledByOwner;
  final String? currentBusinessId;
  final String? currentBusinessName;

  const ActiveEmployee({
    required this.id,
    required this.employee,
    required this.estadoDisponibilidad,
    this.isDisabledByOwner = false,
    this.currentBusinessId,
    this.currentBusinessName,
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

class EmployeeBranchStatus {
  final String recordId;
  final String businessId;
  final String businessName;
  final String businessCode;
  final String? description;
  final bool isDisabledByOwner;
  final bool estadoDisponibilidad;

  const EmployeeBranchStatus({
    required this.recordId,
    required this.businessId,
    required this.businessName,
    required this.businessCode,
    this.description,
    required this.isDisabledByOwner,
    required this.estadoDisponibilidad,
  });
}
