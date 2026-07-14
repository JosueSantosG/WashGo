class ClientEmployee {
  final String? id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;

  const ClientEmployee({
    this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

class ClientOrder {
  final String id;
  final String businessId;
  final String status;
  final String observations;
  final String businessName;
  final String? businessPhone;
  final String? serviceName;
  final double price;
  final ClientEmployee? employee;
  final String paymentMethod;
  final String? invoiceUrl;
  final bool hasReview;
  final DateTime? createdAt;
  final String? type;

  const ClientOrder({
    required this.id,
    required this.businessId,
    required this.status,
    required this.observations,
    required this.businessName,
    this.businessPhone,
    this.serviceName,
    required this.price,
    this.employee,
    required this.paymentMethod,
    this.invoiceUrl,
    this.hasReview = false,
    this.createdAt,
    this.type,
  });
}
