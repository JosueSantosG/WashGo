class OrderReservation {
  final String orderId;
  final String businessId;
  final DateTime scheduledAt;
  final int serviceDurationMinutos;
  final String serviceId;
  final DateTime createdAt;

  const OrderReservation({
    required this.orderId,
    required this.businessId,
    required this.scheduledAt,
    required this.serviceDurationMinutos,
    required this.serviceId,
    required this.createdAt,
  });

  factory OrderReservation.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is DateTime) {
        return value;
      } else {
        return DateTime.now();
      }
    }

    return OrderReservation(
      orderId: json['orderId'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      scheduledAt: parseDateTime(json['scheduledAt']),
      serviceDurationMinutos: json['serviceDurationMinutos'] as int? ?? 30,
      serviceId: json['serviceId'] as String? ?? '',
      createdAt: parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'businessId': businessId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'serviceDurationMinutos': serviceDurationMinutos,
      'serviceId': serviceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  OrderReservation copyWith({
    String? orderId,
    String? businessId,
    DateTime? scheduledAt,
    int? serviceDurationMinutos,
    String? serviceId,
    DateTime? createdAt,
  }) {
    return OrderReservation(
      orderId: orderId ?? this.orderId,
      businessId: businessId ?? this.businessId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      serviceDurationMinutos: serviceDurationMinutos ?? this.serviceDurationMinutos,
      serviceId: serviceId ?? this.serviceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
