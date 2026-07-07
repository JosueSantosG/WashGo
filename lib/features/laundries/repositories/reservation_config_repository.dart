import '../models/business_reservation_config.dart';

abstract class ReservationConfigRepository {
  Future<BusinessReservationConfig?> getConfig(String businessId);
  Future<void> saveConfig({
    required String businessId,
    required int capacidadSimultanea,
    required int tiempoAnticipacionMinutos,
  });
}
