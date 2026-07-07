import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import '../models/order_reservation.dart';
import 'reservation_metadata_repository.dart';

class FirebaseReservationMetadataRepository implements ReservationMetadataRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<void> createReservation(OrderReservation reservation) async {
    await _connector.createOrderReservation(
      orderId: reservation.orderId,
      businessId: reservation.businessId,
      scheduledAt: Timestamp.fromJson(reservation.scheduledAt.toUtc().toIso8601String()),
      serviceDurationMinutos: reservation.serviceDurationMinutos,
      serviceId: reservation.serviceId,
      createdAt: Timestamp.fromJson(reservation.createdAt.toUtc().toIso8601String()),
    ).execute();
  }

  @override
  Future<List<OrderReservation>> getActiveReservations(String businessId) async {
    try {
      final response = await _connector.getActiveReservations(businessId: businessId).execute();
      return response.data.orderReservations.map((r) {
        return OrderReservation(
          orderId: r.orderId,
          businessId: r.businessId,
          scheduledAt: r.scheduledAt.toDateTime(),
          serviceDurationMinutos: r.serviceDurationMinutos,
          serviceId: r.serviceId,
          createdAt: r.createdAt.toDateTime(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> deleteReservation(String orderId) async {
    await _connector.deleteOrderReservation(orderId: orderId).execute();
  }

  @override
  Future<OrderReservation?> getReservation(String orderId) async {
    try {
      final response = await _connector.getReservationByOrderId(orderId: orderId).execute();
      final reservations = response.data.orderReservations;
      if (reservations.isEmpty) return null;
      final r = reservations.first;
      return OrderReservation(
        orderId: r.orderId,
        businessId: r.businessId,
        scheduledAt: r.scheduledAt.toDateTime(),
        serviceDurationMinutos: r.serviceDurationMinutos,
        serviceId: r.serviceId,
        createdAt: r.createdAt.toDateTime(),
      );
    } catch (e) {
      return null;
    }
  }
}

