import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/core/utils/type_utils.dart';
import 'laundry_repository.dart';

class FirebaseLaundryRepository implements LaundryRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  List<Map<String, dynamic>> _getDefaultBusinessHours() {
    List<Map<String, dynamic>> list = [];
    for (int i = 1; i <= 7; i++) {
      list.add({
        'diaDeLaSemana': i,
        'horaApertura': '08:00',
        'horaCierre': '18:00',
        'esDiaDescanso': i == 7,
      });
    }
    return list;
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  bool _isTimeOpen(String apertura, String cierre) {
    try {
      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;

      final openParts = apertura.split(':');
      final closeParts = cierre.split(':');

      if (openParts.length < 2 || closeParts.length < 2) return false;

      final openMinutes =
          int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
      final closeMinutes =
          int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);

      if (openMinutes == closeMinutes) {
        return true; // 24/7
      }

      if (openMinutes < closeMinutes) {
        // Normal daytime hours (e.g., 08:00 to 18:00)
        return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
      } else {
        // Overnight hours (e.g., 20:00 to 02:00)
        return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> getBusinessWaitTime(String businessId) async {
    try {
      final results = await Future.wait([
        _connector.getActiveBusinessOrders(businessId: businessId).ref().execute(fetchPolicy: QueryFetchPolicy.serverOnly),
        _connector.getActiveEmployees(businessId: businessId).ref().execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      ]);

      final ordersData = (results[0] as dynamic).data;
      final employeesData = (results[1] as dynamic).data;

      final activeOrders = ordersData.orders;
      final activeEmployees = employeesData.businessEmployees;

      final availableEmployeesCount = activeEmployees.where((emp) => emp.estadoDisponibilidad == true).length;

      int totalMinutes = 0;
      for (final order in activeOrders) {
        final status = order.status.stringValue.toUpperCase();
        if (status == 'ACEPTADO' || status == 'EN_COLA' || status == 'EN_SERVICIO') {
          final int dur = order.service?.duracionMinutos ?? 20;
          totalMinutes += dur;
        }
      }

      if (totalMinutes == 0) {
        return '5 min';
      }

      final divisor = availableEmployeesCount > 0 ? availableEmployeesCount : 1;
      final waitTimeMinutes = (totalMinutes / divisor).round();

      final finalWaitTime = waitTimeMinutes < 5 ? 5 : waitTimeMinutes;
      return '$finalWaitTime min';
    } catch (e) {
      return '5 min';
    }
  }

  @override
  Future<List<LaundryItem>> getLaundries(LatLng userLocation) async {
    try {
      final response = await _connector.getAllBusinesses().execute();
      final dbBusinesses = response.data.businesses;

      List<LaundryItem> dynamicList = [];

      final approvedBusinesses = dbBusinesses.where((b) => b.status.stringValue == 'APPROVED').toList();

      if (approvedBusinesses.isEmpty) {
        return [];
      }

      for (int i = 0; i < approvedBusinesses.length; i++) {
        final b = approvedBusinesses[i];
        const waitTime = '5 min';

        double lat = b.latitud ?? userLocation.latitude;
        double lng = b.longitud ?? userLocation.longitude;

        if (b.latitud == null || b.longitud == null) {
          final offsetIndex = dynamicList.length;
          lat =
              userLocation.latitude +
              (0.003 * (offsetIndex + 1) * (offsetIndex % 2 == 0 ? 1 : -1));
          lng =
              userLocation.longitude +
              (0.003 * (offsetIndex + 1) * (offsetIndex % 3 == 0 ? 1 : -1));
        }

        final distMeters = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          lat,
          lng,
        );

        final isEco = b.descripcion?.toLowerCase().contains('eco') ?? false;

        List<Map<String, dynamic>> businessHoursMapped = b
            .businessHours_on_business
            .map(
              (bh) => {
                'diaDeLaSemana': bh.diaDeLaSemana,
                'horaApertura': bh.horaApertura,
                'horaCierre': bh.horaCierre,
                'esDiaDescanso': bh.esDiaDescanso,
              },
            )
            .toList();

        if (businessHoursMapped.isEmpty) {
          businessHoursMapped = _getDefaultBusinessHours();
        }

        final todayWeekday = DateTime.now().weekday;
        final todayHours = businessHoursMapped.firstWhere(
          (bh) => bh['diaDeLaSemana'] == todayWeekday,
          orElse: () => {
            'diaDeLaSemana': todayWeekday,
            'horaApertura': '08:00',
            'horaCierre': '18:00',
            'esDiaDescanso': todayWeekday == 7,
          },
        );

        final bool esDescanso = todayHours['esDiaDescanso'] ?? false;
        final String? apertura = todayHours['horaApertura'];
        final String? cierre = todayHours['horaCierre'];

        bool isCurrentlyOpen =
            b.status.stringValue == 'APPROVED' && !esDescanso;

        if (isCurrentlyOpen && apertura != null && cierre != null) {
          isCurrentlyOpen = _isTimeOpen(apertura, cierre);
        }

        double resolvedPrice = 10.00 + (dynamicList.length % 3) * 2.50;
        final activeServices = b.services_on_business.where((s) => s.activo == true && s.precioPendiente == false).toList();
        if (activeServices.isNotEmpty) {
          final minPrice = activeServices.map((s) {
            final prices = [safeDouble(s.precioPequeno), safeDouble(s.precioMediano), safeDouble(s.precioGrande), safeDouble(s.precioMoto)];
            return prices.reduce((a, b) => a < b ? a : b);
          }).reduce((a, b) => a < b ? a : b);
          resolvedPrice = minPrice;
        } else if (b.services_on_business.isNotEmpty) {
          final minPrice = b.services_on_business.map((s) {
            final prices = [safeDouble(s.precioPequeno), safeDouble(s.precioMediano), safeDouble(s.precioGrande), safeDouble(s.precioMoto)];
            return prices.reduce((a, b) => a < b ? a : b);
          }).reduce((a, b) => a < b ? a : b);
          resolvedPrice = minPrice;
        }

        final reviews = b.reviews_on_business;
        final reviewsCount = reviews.length;
        double rating = 0.0;
        if (reviewsCount > 0) {
          final totalRatingSum = reviews.map((r) => r.calificacion).reduce((a, b) => a + b);
          rating = totalRatingSum / reviewsCount;
        }

        dynamicList.add(
          LaundryItem(
            id: b.id,
            name: b.nombre,
            type:
                b.descripcion ??
                (isEco
                    ? 'Lavado Ecológico Premium'
                    : 'Lavado y Detallado de Confianza'),
            rating: rating,
            reviewsCount: reviewsCount,
            distance: _formatDistance(distMeters),
            distanceInMeters: distMeters,
            price: resolvedPrice,
            location: LatLng(lat, lng),
            isEco: isEco,
            isOpen: isCurrentlyOpen,
            waitTime: waitTime,
            phone: b.telefono ?? '+593 99 999 9999',
            businessHours: businessHoursMapped,
          ),
        );
      }
      return dynamicList;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getBusinessServices(
    String businessId,
    double basePrice,
  ) async {
    try {
      final response = await _connector
          .getBusinessServices(businessId: businessId)
          .execute();
      final services = response.data.services.where((s) => s.activo == true && s.precioPendiente == false).toList();
      if (services.isEmpty) {
        return [];
      }
      return services.map((s) {
        final tVal = s.tipo is Known<ServiceType>
            ? (s.tipo as Known<ServiceType>).value
            : ServiceType.LOCAL;
        return {
          'id': s.id,
          'nombre': s.nombre,
          'descripcion': s.descripcion,
          'precio': basePrice > 0 ? basePrice : safeDouble(s.precioPequeno),
          'precioBase': basePrice,
          'precioPequeno': safeDouble(s.precioPequeno),
          'precioMediano': safeDouble(s.precioMediano),
          'precioGrande': safeDouble(s.precioGrande),
          'precioMoto': safeDouble(s.precioMoto),
          'costo': safeDouble(s.costo),
          'duracionMinutos': s.duracionMinutos,
          'tipo': tVal == ServiceType.LOCAL ? 'LOCAL' : 'DOMICILIO',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> createFallbackBusiness(String id, String name) async {
    try {
      await _connector
          .createBusiness(
            id: id,
            nombre: name,
            ruc: '12345678901',
            businessCode: 'WASHGO-FALLBACK',
          )
          .execute();
    } catch (_) {}
  }

  @override
  Future<void> createBusiness({
    required String id,
    required String nombre,
    required String ruc,
    required String businessCode,
    String? descripcion,
    required String telefono,
    required double latitud,
    required double longitud,
  }) async {
    var builder = _connector.createBusiness(
      id: id,
      nombre: nombre,
      ruc: ruc,
      businessCode: businessCode,
    ).telefono(telefono);
    if (descripcion != null) {
      builder = builder.descripcion(descripcion);
    }
    await builder.latitud(latitud).longitud(longitud).execute();
  }

  @override
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
  }) async {
    var builder = _connector.createService(
      businessId: businessId,
      nombre: nombre,
      precioPequeno: precioPequeno,
      precioMediano: precioMediano,
      precioGrande: precioGrande,
      precioMoto: precioMoto,
      duracionMinutos: duracionMinutos,
      tipo: tipo,
    );
    if (descripcion != null) {
      builder = builder.descripcion(descripcion);
    }
    await builder.execute();
  }

  @override
  Future<void> createBusinessHour({
    required String businessId,
    required int diaDeLaSemana,
    required bool esDiaDescanso,
    String? horaApertura,
    String? horaCierre,
  }) async {
    var builder = _connector.createBusinessHour(
      businessId: businessId,
      diaDeLaSemana: diaDeLaSemana,
      esDiaDescanso: esDiaDescanso,
    );
    if (horaApertura != null) {
      builder = builder.horaApertura(horaApertura);
    }
    if (horaCierre != null) {
      builder = builder.horaCierre(horaCierre);
    }
    await builder.execute();
  }
}
