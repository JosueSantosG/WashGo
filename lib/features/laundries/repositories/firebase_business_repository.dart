import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/laundries/models/washgo_business.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/laundries/models/employee_request.dart';
import 'package:washgo/features/laundries/models/active_employee.dart';
import 'package:washgo/features/laundries/models/prepaid_models.dart';
import 'business_repository.dart';

class FirebaseBusinessRepository implements BusinessRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<WashGoBusiness?> getBusiness(String businessId) async {
    final response = await _connector.getCurrentUser().ref().execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    final business = response.data.user?.currentBusiness;
    if (business == null || business.id != businessId) return null;
    return WashGoBusiness(
      id: business.id,
      nombre: business.nombre,
      ruc: business.ruc,
      businessCode: business.businessCode,
      descripcion: business.descripcion,
      telefono: business.telefono,
      latitud: business.latitud,
      longitud: business.longitud,
      status: business.status.stringValue,
      saldoPrepagoInicial: business.saldoPrepagoInicial,
      saldoPrepagoConsumido: business.saldoPrepagoConsumido,
    );
  }

  @override
  Future<List<EmployeeRequest>> getPendingEmployeeRequests(String businessId) async {
    final response = await _connector
        .getPendingEmployeeRequests(businessId: businessId)
        .execute();
    return response.data.employeeRequests.map((req) {
      return EmployeeRequest(
        id: req.id,
        user: EmployeeRequestUser(
          id: req.user.id,
          nombreCompleto: req.user.nombreCompleto,
          email: req.user.email,
        ),
      );
    }).toList();
  }

  @override
  Future<List<ActiveEmployee>> getActiveEmployees(String businessId) async {
    final response = await _connector
        .getActiveEmployees(businessId: businessId)
        .execute();
    return response.data.businessEmployees.map((be) {
      return ActiveEmployee(
        id: be.id,
        employee: ActiveEmployeeUser(
          id: be.employee.id,
          nombreCompleto: be.employee.nombreCompleto,
          email: be.employee.email,
          telefono: be.employee.telefono,
          fotoPerfil: be.employee.fotoPerfil,
        ),
        estadoDisponibilidad: be.estadoDisponibilidad,
      );
    }).toList();
  }

  @override
  Future<List<WashGoService>> getBusinessServices(String businessId) async {
    final response = await _connector
        .getBusinessServices(businessId: businessId)
        .execute();
    return response.data.services.map((svc) {
      return WashGoService(
        id: svc.id,
        nombre: svc.nombre,
        descripcion: svc.descripcion,
        precioPequeno: svc.precioPequeno,
        precioMediano: svc.precioMediano,
        precioGrande: svc.precioGrande,
        precioMoto: svc.precioMoto,
        precioOwnerPequeno: svc.precioOwnerPequeno,
        precioOwnerMediano: svc.precioOwnerMediano,
        precioOwnerGrande: svc.precioOwnerGrande,
        precioOwnerMoto: svc.precioOwnerMoto,
        precioPendiente: svc.precioPendiente,
        costo: svc.costo,
        duracionMinutos: svc.duracionMinutos,
        tipo: svc.tipo is Known<ServiceType>
            ? (svc.tipo as Known<ServiceType>).value
            : ServiceType.LOCAL,
        activo: svc.activo ?? true,
      );
    }).toList();
  }

  @override
  Future<void> updateBusiness({
    required String id,
    required String nombre,
    required String ruc,
    String? descripcion,
    String? telefono,
    double? latitud,
    double? longitud,
  }) async {
    var builder = _connector
        .updateBusiness(
          id: id,
          nombre: nombre,
          ruc: ruc,
        );
    if (descripcion != null) {
      builder = builder.descripcion(descripcion);
    }
    if (telefono != null) {
      builder = builder.telefono(telefono);
    }
    if (latitud != null) {
      builder = builder.latitud(latitud);
    }
    if (longitud != null) {
      builder = builder.longitud(longitud);
    }
    await builder.execute();
  }

  @override
  Future<void> approveEmployeeRequest({
    required String requestId,
    required String employeeId,
    required String businessId,
  }) async {
    await _connector
        .approveEmployeeRequest(
          requestId: requestId,
          employeeId: employeeId,
          businessId: businessId,
        )
        .execute();
  }

  @override
  Future<void> rejectEmployeeRequest({
    required String requestId,
    required String employeeId,
  }) async {
    await _connector
        .rejectEmployeeRequest(
          requestId: requestId,
          employeeId: employeeId,
        )
        .execute();
  }

  @override
  Future<void> createService({
    required String businessId,
    required String nombre,
    String? descripcion,
    required double precioPequeno,
    required double precioMediano,
    required double precioGrande,
    required double precioMoto,
    required int duracionMinutos,
    required ServiceType tipo,
  }) async {
    await _connector
        .createService(
          businessId: businessId,
          nombre: nombre,
          precioPequeno: precioPequeno,
          precioMediano: precioMediano,
          precioGrande: precioGrande,
          precioMoto: precioMoto,
          duracionMinutos: duracionMinutos,
          tipo: tipo,
        )
        .descripcion(descripcion)
        .execute();
  }

  @override
  Future<void> updateService({
    required String id,
    required String nombre,
    String? descripcion,
    required double precioPequeno,
    required double precioMediano,
    required double precioGrande,
    required double precioMoto,
    required int duracionMinutos,
    required ServiceType tipo,
  }) async {
    await _connector
        .updateService(
          id: id,
          nombre: nombre,
          precioPequeno: precioPequeno,
          precioMediano: precioMediano,
          precioGrande: precioGrande,
          precioMoto: precioMoto,
          duracionMinutos: duracionMinutos,
          tipo: tipo,
        )
        .descripcion(descripcion)
        .execute();
  }

  @override
  Future<void> updateServiceDetails({
    required String id,
    required String nombre,
    String? descripcion,
    required int duracionMinutos,
    required ServiceType tipo,
  }) async {
    await _connector
        .updateServiceDetails(
          id: id,
          nombre: nombre,
          duracionMinutos: duracionMinutos,
          tipo: tipo,
        )
        .descripcion(descripcion)
        .execute();
  }

  @override
  Future<void> deleteService(String id) async {
    await _connector.deleteService(id: id).execute();
  }

  @override
  Future<void> toggleServiceActive(String id, bool active) async {
    await _connector.toggleServiceActive(id: id, activo: active).execute();
  }

  @override
  Future<void> superAdminApproveServicePrice({
    required String id,
    required double precioAprobadoPequeno,
    required double precioAprobadoMediano,
    required double precioAprobadoGrande,
    required double precioAprobadoMoto,
  }) async {
    await _connector
        .superAdminApproveServicePrice(
          id: id,
          precioAprobadoPequeno: precioAprobadoPequeno,
          precioAprobadoMediano: precioAprobadoMediano,
          precioAprobadoGrande: precioAprobadoGrande,
          precioAprobadoMoto: precioAprobadoMoto,
        )
        .execute();
  }

  @override
  Future<EmployeeAvailability?> getEmployeeAvailability({
    required String businessId,
    required String employeeId,
  }) async {
    final response = await _connector
        .getEmployeeAvailability(businessId: businessId, employeeId: employeeId)
        .execute();
    final list = response.data.businessEmployees;
    if (list.isEmpty) return null;
    final record = list.first;
    return EmployeeAvailability(
      id: record.id,
      estadoDisponibilidad: record.estadoDisponibilidad,
    );
  }

  @override
  Future<void> updateEmployeeAvailability({
    required String recordId,
    required bool available,
  }) async {
    await _connector
        .updateEmployeeAvailability(id: recordId, estadoDisponibilidad: available)
        .execute();
  }

  @override
  Future<List<Map<String, dynamic>>> getBusinessHours(String businessId) async {
    final response = await _connector.getBusinessHours(businessId: businessId).execute();
    return response.data.businessHours.map((bh) {
      return {
        'id': bh.id,
        'diaDeLaSemana': bh.diaDeLaSemana,
        'horaApertura': bh.horaApertura,
        'horaCierre': bh.horaCierre,
        'esDiaDescanso': bh.esDiaDescanso,
      };
    }).toList();
  }

  @override
  Future<void> updateBusinessHours(String businessId, List<Map<String, dynamic>> hours) async {
    await _connector.deleteBusinessHours(businessId: businessId).execute();
    for (var hour in hours) {
      final builder = _connector.createBusinessHour(
        businessId: businessId,
        diaDeLaSemana: hour['diaDeLaSemana'] as int,
        esDiaDescanso: hour['esDiaDescanso'] as bool,
      );
      if (hour['horaApertura'] != null) {
        builder.horaApertura(hour['horaApertura'] as String);
      }
      if (hour['horaCierre'] != null) {
        builder.horaCierre(hour['horaCierre'] as String);
      }
      await builder.execute();
    }
  }

  @override
  Future<List<WashGoBusiness>> getMyBusinesses() async {
    final response = await _connector.getMyBusinesses().execute();
    return response.data.businesses.map((b) {
      return WashGoBusiness(
        id: b.id,
        nombre: b.nombre,
        ruc: b.ruc,
        businessCode: b.businessCode,
        descripcion: b.descripcion,
        telefono: b.telefono,
        latitud: b.latitud,
        longitud: b.longitud,
        status: b.status.stringValue,
        saldoPrepagoInicial: b.saldoPrepagoInicial,
        saldoPrepagoConsumido: b.saldoPrepagoConsumido,
      );
    }).toList();
  }

  @override
  Future<void> switchCurrentBusiness(String businessId) async {
    await _connector.switchCurrentBusiness(businessId: businessId).execute();
  }

  @override
  Future<void> updateBusinessPrepaidBalance({
    required String id,
    required double saldoPrepagoInicial,
    required double saldoPrepagoConsumido,
  }) async {
    await _connector
        .updateBusinessPrepaidBalance(
          id: id,
          saldoPrepagoInicial: saldoPrepagoInicial,
          saldoPrepagoConsumido: saldoPrepagoConsumido,
        )
        .execute();
  }

  @override
  Future<List<PrepaidServiceMetricModel>> getPrepaidServiceMetrics(String businessId) async {
    final response = await _connector.getPrepaidServiceMetrics(businessId: businessId).execute();
    return response.data.prepaidServiceMetrics.map((m) {
      return PrepaidServiceMetricModel(
        id: m.id,
        serviceName: m.serviceName,
        costoUnitario: m.costoUnitario,
        cantidad: m.cantidad,
        totalConsumido: m.totalConsumido,
      );
    }).toList();
  }

  @override
  Future<List<PrepaidHistoryEntryModel>> getPrepaidHistory(String businessId) async {
    final response = await _connector.getPrepaidHistory(businessId: businessId).execute();
    return response.data.prepaidHistories.map((h) {
      return PrepaidHistoryEntryModel(
        id: h.id,
        orderId: h.orderId,
        serviceName: h.serviceName,
        costoConsumido: h.costoConsumido,
        saldoResultante: h.saldoResultante,
        fecha: h.fecha.toDateTime(),
      );
    }).toList();
  }
}
