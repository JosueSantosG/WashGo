/// Model representing a payment proof for bank transfer.
///
/// Fields use string-based enum values instead of generated types from
/// example.dart because the SDK hasn't been regenerated with the new enums
/// (TRANSFERENCIA_BANCARIA, PaymentProofStatus, PaymentAccountType).
/// TODO: Switch to generated enum types after `firebase dataconnect:sdk:generate`.
class PaymentProofModel {
  final String id;
  final String orderId;
  final String imageUrl;
  final double declaredAmount;
  final String paymentAccountType; // 'GUAYAQUIL' | 'PICHINCHA'
  final String? referenceNumber;
  final String? observations;
  final String status; // 'PENDING' | 'APPROVED' | 'REJECTED'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  const PaymentProofModel({
    required this.id,
    required this.orderId,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    this.referenceNumber,
    this.observations,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.reviewedBy,
    this.reviewedAt,
  });

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';

  String get statusDisplay {
    switch (status) {
      case 'PENDING':
        return 'Pendiente';
      case 'APPROVED':
        return 'Aprobado';
      case 'REJECTED':
        return 'Rechazado';
      default:
        return status;
    }
  }

  String get accountDisplay {
    switch (paymentAccountType) {
      case 'GUAYAQUIL':
        return 'Banco Guayaquil';
      case 'PICHINCHA':
        return 'Banco Pichincha';
      default:
        return paymentAccountType;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'imageUrl': imageUrl,
        'declaredAmount': declaredAmount,
        'paymentAccountType': paymentAccountType,
        'referenceNumber': referenceNumber,
        'observations': observations,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'reviewedBy': reviewedBy,
        'reviewedAt': reviewedAt?.toIso8601String(),
      };

  factory PaymentProofModel.fromJson(Map<String, dynamic> json) =>
      PaymentProofModel(
        id: json['id'] as String,
        orderId: json['orderId'] as String,
        imageUrl: json['imageUrl'] as String,
        declaredAmount: (json['declaredAmount'] as num).toDouble(),
        paymentAccountType: json['paymentAccountType'] as String,
        referenceNumber: json['referenceNumber'] as String?,
        observations: json['observations'] as String?,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        reviewedBy: json['reviewedBy'] as String?,
        reviewedAt: json['reviewedAt'] != null
            ? DateTime.parse(json['reviewedAt'] as String)
            : null,
      );
}
