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
  };

  factory PaymentProofModel.fromJson(Map<String, dynamic> json) {
    return PaymentProofModel(
      orderId: json['orderId'] as String,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
      status: PaymentProofStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PaymentProofStatus.PENDING,
      ),
      accountType: json['accountType'] != null
          ? PaymentAccountType.values.firstWhere(
              (a) => a.name == json['accountType'],
            )
          : null,
      referenceNumber: json['referenceNumber'] as String?,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      rejectionReason: json['rejectionReason'] as String?,
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
