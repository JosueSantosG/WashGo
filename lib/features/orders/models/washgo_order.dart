import 'package:washgo/dataconnect-generated/example.dart';

class OrderParty {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;

  const OrderParty({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

class WashGoOrder {
  final String id;
  final OrderStatus status;
  final String? observations;
  final String businessId;
  final String businessName;
  final String? serviceName;
  final double price;
  final OrderType type;
  final PaymentMethod paymentMethod;
  final OrderParty client;
  final OrderParty? employee;

  const WashGoOrder({
    required this.id,
    required this.status,
    this.observations,
    required this.businessId,
    required this.businessName,
    this.serviceName,
    required this.price,
    required this.type,
    required this.paymentMethod,
    required this.client,
    this.employee,
  });
}
