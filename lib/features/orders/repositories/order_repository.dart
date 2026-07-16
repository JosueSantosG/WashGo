import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/features/orders/models/washgo_order.dart';
import 'package:washgo/features/orders/models/order_audit_log.dart';

abstract class OrderRepository {
  Future<List<ClientOrder>> getClientOrders();
  Future<String> createOrder({
    required String businessId,
    required double price,
    required double costo,
    required String serviceName,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required String observations,
  });

  Future<List<WashGoOrder>> getBusinessOrders(String businessId);
  Stream<List<WashGoOrder>> watchBusinessOrders(String businessId);
  Stream<List<ClientOrder>> watchClientOrders();
  Future<void> acceptOrder({required String orderId, required String employeeId});
  Future<void> updateOrderStatus({required String orderId, required OrderStatus status, String? cancellationReason});
  Future<void> updateOrderPaymentMethodAndStatus({
    required String orderId,
    required PaymentMethod paymentMethod,
    required OrderStatus status,
    String? cancellationReason,
  });
  Future<void> rescheduleOrder({required String orderId, required String observations});
  Future<QueuePosition> getQueuePosition({required String businessId, required String orderId});
  Future<List<WashGoOrder>> getEmployeeHistoryOrdersPaged({
    required String businessId,
    required String employeeId,
    required int limit,
    required int offset,
  });
  Future<List<ClientOrder>> getClientHistoryOrdersPaged({
    required List<OrderStatus> statuses,
    required int limit,
    required int offset,
  });
  Future<WalkInClientInfo?> findUserByPhone(String phone);
  Future<String> createWalkInUser({
    required String nombreCompleto,
    required String telefono,
    required String email,
  });
  Future<String> createWalkInOrder({
    required String businessId,
    required String clientId,
    required double price,
    required double costo,
    required String serviceName,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required String observations,
  });
  Future<List<OrderAuditLog>> getOrderLogs(String orderId);
}

class QueuePosition {
  final int position;
  final int estimatedWaitTime;

  QueuePosition({
    required this.position,
    required this.estimatedWaitTime,
  });
}

class WalkInClientInfo {
  final String id;
  final String nombreCompleto;
  final String telefono;
  final String email;

  WalkInClientInfo({
    required this.id,
    required this.nombreCompleto,
    required this.telefono,
    required this.email,
  });
}
