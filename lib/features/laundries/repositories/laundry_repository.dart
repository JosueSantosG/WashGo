import 'package:latlong2/latlong.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';

abstract class LaundryRepository {
  Future<List<LaundryItem>> getLaundries(LatLng userLocation);
  Future<List<Map<String, dynamic>>> getBusinessServices(String businessId, double basePrice);
  Future<String> getBusinessWaitTime(String businessId);
  Future<void> createFallbackBusiness(String id, String name);
  
  Future<void> createBusiness({
    required String id,
    required String nombre,
    required String ruc,
    required String businessCode,
    String? descripcion,
    required String telefono,
    required double latitud,
    required double longitud,
  });

  Future<void> createService({
    required String businessId,
    required String nombre,
    required double precioPequeno,
    required double precioMediano,
    required double precioGrande,
    required double precioMoto,
    required int duracionMinutos,
    required ServiceType tipo,
    String? descripcion,
  });

  Future<void> createBusinessHour({
    required String businessId,
    required int diaDeLaSemana,
    required bool esDiaDescanso,
    String? horaApertura,
    String? horaCierre,
  });
}
