import '../models/order_reservation.dart';

abstract class ReservationMetadataRepository {
  Future<void> createReservation(OrderReservation reservation);
  Future<List<OrderReservation>> getActiveReservations(String businessId);
  Future<void> deleteReservation(String orderId);
  Future<OrderReservation?> getReservation(String orderId);
}
