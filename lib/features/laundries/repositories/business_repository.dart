import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/laundries/models/washgo_business.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/laundries/models/employee_request.dart';
import 'package:washgo/features/laundries/models/active_employee.dart';
import 'package:washgo/features/laundries/models/prepaid_models.dart';

abstract class BusinessRepository {
  Future<WashGoBusiness?> getBusiness(String businessId);
  
  Future<List<EmployeeRequest>> getPendingEmployeeRequests(String businessId);
  
  Future<List<ActiveEmployee>> getActiveEmployees(String businessId);
  
  Future<List<WashGoService>> getBusinessServices(String businessId);
  
  Future<void> updateBusiness({
    required String id,
    required String nombre,
    required String ruc,
    String? descripcion,
    String? telefono,
    double? latitud,
    double? longitud,
  });
  
  Future<void> approveEmployeeRequest({
    required String requestId,
    required String employeeId,
    required String businessId,
  });
  
  Future<void> rejectEmployeeRequest({
    required String requestId,
    required String employeeId,
  });
  
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
  });
  
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
  });
  
  Future<void> updateServiceDetails({
    required String id,
    required String nombre,
    String? descripcion,
    required int duracionMinutos,
    required ServiceType tipo,
  });
  
  Future<void> deleteService(String id);
  
  Future<void> toggleServiceActive(String id, bool active);

  Future<void> superAdminApproveServicePrice({
    required String id,
    required double precioAprobadoPequeno,
    required double precioAprobadoMediano,
    required double precioAprobadoGrande,
    required double precioAprobadoMoto,
  });

  Future<EmployeeAvailability?> getEmployeeAvailability({
    required String businessId,
    required String employeeId,
  });

  Future<void> updateEmployeeAvailability({
    required String recordId,
    required bool available,
  });

  Future<List<Map<String, dynamic>>> getBusinessHours(String businessId);
  Future<void> updateBusinessHours(String businessId, List<Map<String, dynamic>> hours);

  Future<List<WashGoBusiness>> getMyBusinesses();
  Future<void> switchCurrentBusiness(String businessId);

  Future<void> updateBusinessPrepaidBalance({
    required String id,
    required double saldoPrepagoInicial,
    required double saldoPrepagoConsumido,
  });

  Future<List<PrepaidServiceMetricModel>> getPrepaidServiceMetrics(String businessId);
  Future<List<PrepaidHistoryEntryModel>> getPrepaidHistory(String businessId);
}

