enum PaymentProofStatus {
  PENDING,
  APPROVED,
  REJECTED,
}

enum PaymentAccountType {
  GUAYAQUIL,
  PICHINCHA,
}

class PaymentProofModel {
  final String orderId;
  final String? imageUrl;
  final String? imagePath;
  final PaymentProofStatus status;
  final PaymentAccountType? accountType;
  final String? referenceNumber;
  final double amount;
  final DateTime createdAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  
  // Extended fields for SuperAdmin review
  final String? businessName;
  final String? clientName;
  final String? clientPhone;
  final String? serviceName;
  final DateTime? scheduledAt;
  final int? serviceDurationMinutos;

  PaymentProofModel({
    required this.orderId,
    this.imageUrl,
    this.imagePath,
    required this.status,
    this.accountType,
    this.referenceNumber,
    required this.amount,
    required this.createdAt,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.businessName,
    this.clientName,
    this.clientPhone,
    this.serviceName,
    this.scheduledAt,
    this.serviceDurationMinutos,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'imageUrl': imageUrl,
    'imagePath': imagePath,
    'status': status.name,
    'accountType': accountType?.name,
    'referenceNumber': referenceNumber,
    'amount': amount,
    'createdAt': createdAt.toIso8601String(),
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt?.toIso8601String(),
    'rejectionReason': rejectionReason,
    'businessName': businessName,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'serviceName': serviceName,
    'scheduledAt': scheduledAt?.toIso8601String(),
    'serviceDurationMinutos': serviceDurationMinutos,
  };

  factory PaymentProofModel.fromJson(Map<String, dynamic> json) {
    final data = json['proof'] != null ? json['proof'] as Map<String, dynamic> : json;
    return PaymentProofModel(
      orderId: (data['orderId'] ?? json['orderId'] ?? data['id'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? json['imageUrl']) as String?,
      imagePath: (data['imagePath'] ?? json['imagePath']) as String?,
      status: PaymentProofStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => PaymentProofStatus.PENDING,
      ),
      accountType: data['paymentAccountType'] != null
          ? PaymentAccountType.values.firstWhere(
              (a) => a.name == data['paymentAccountType'],
              orElse: () => PaymentAccountType.GUAYAQUIL,
            )
          : (data['accountType'] != null
              ? PaymentAccountType.values.firstWhere(
                  (a) => a.name == data['accountType'],
                  orElse: () => PaymentAccountType.GUAYAQUIL,
                )
              : null),
      referenceNumber: data['referenceNumber'] as String?,
      amount: data['declaredAmount'] != null
          ? (data['declaredAmount'] as num).toDouble()
          : (data['amount'] != null ? (data['amount'] as num).toDouble() : 0.0),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      reviewedBy: data['reviewedBy'] as String?,
      reviewedAt: data['reviewedAt'] != null
          ? DateTime.parse(data['reviewedAt'] as String)
          : null,
      rejectionReason: (data['rejectionReason'] ?? data['observations']) as String?,
      businessName: json['businessName'] as String?,
      clientName: json['clientName'] as String?,
      clientPhone: json['clientPhone'] as String?,
      serviceName: json['serviceName'] as String?,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'] as String)
          : null,
      serviceDurationMinutos: json['serviceDurationMinutos'] as int?,
    );
  }

  String get statusLabel {
    switch (status) {
      case PaymentProofStatus.PENDING:
        return 'Pendiente';
      case PaymentProofStatus.APPROVED:
        return 'Aprobado';
      case PaymentProofStatus.REJECTED:
        return 'Rechazado';
    }
  }
}

