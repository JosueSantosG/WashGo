import 'package:washgo/dataconnect-generated/example.dart';
import '../models/business_reservation_config.dart';
import 'reservation_config_repository.dart';

class FirebaseReservationConfigRepository implements ReservationConfigRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<BusinessReservationConfig?> getConfig(String businessId) async {
    try {
      final response = await _connector.getBusinessReservationConfig(businessId: businessId).execute();
      final configs = response.data.businessReservationConfigs;
      if (configs.isEmpty) {
        return null;
      }
      final config = configs.first;
      return BusinessReservationConfig(
        capacidadSimultanea: config.capacidadSimultanea,
        tiempoAnticipacionMinutos: config.tiempoAnticipacionMinutos,
        isConfigured: config.isConfigured,
      );
    } catch (e) {
      // Retornar null si hay error para no bloquear la app
      return null;
    }
  }

  @override
  Future<void> saveConfig({
    required String businessId,
    required int capacidadSimultanea,
    required int tiempoAnticipacionMinutos,
  }) async {
    try {
      final response = await _connector.getBusinessReservationConfig(businessId: businessId).execute();
      final configs = response.data.businessReservationConfigs;

      if (configs.isEmpty) {
        await _connector.createBusinessReservationConfig(
          businessId: businessId,
          capacidadSimultanea: capacidadSimultanea,
          tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
          isConfigured: true,
        ).execute();
      } else {
        final configId = configs.first.id;
        await _connector.updateBusinessReservationConfig(
          id: configId,
          capacidadSimultanea: capacidadSimultanea,
          tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,
          isConfigured: true,
        ).execute();
      }
    } catch (e) {
      // Log or handle error if necessary, or let it propagate depending on needs.
      rethrow;
    }
  }
}

