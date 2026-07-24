import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:washgo/features/laundries/models/washgo_business.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/laundries/models/employee_request.dart';
import 'package:washgo/features/laundries/models/active_employee.dart';
import 'package:washgo/features/laundries/models/prepaid_models.dart';
import 'package:washgo/features/laundries/repositories/business_repository.dart';
import 'package:washgo/features/laundries/pages/prepaid_consumption_page.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class FakeBusinessRepository implements BusinessRepository {
  final List<PrepaidServiceMetricModel> metrics;
  final List<PrepaidHistoryEntryModel> history;

  FakeBusinessRepository({required this.metrics, required this.history});

  @override
  Future<List<PrepaidServiceMetricModel>> getPrepaidServiceMetrics(String businessId) async {
    return metrics;
  }

  @override
  Future<List<PrepaidHistoryEntryModel>> getPrepaidHistory(String businessId) async {
    return history;
  }

  @override
  Future<WashGoBusiness?> getBusiness(String businessId) => throw UnimplementedError();
  @override
  Future<void> updateBusinessStatus(String businessId, BusinessStatus status) => throw UnimplementedError();
  @override
  Future<List<EmployeeRequest>> getPendingEmployeeRequests(String businessId) => throw UnimplementedError();
  @override
  Future<List<ActiveEmployee>> getActiveEmployees(String businessId) => throw UnimplementedError();
  @override
  Future<List<WashGoService>> getBusinessServices(String businessId) => throw UnimplementedError();
  @override
  Future<void> updateBusiness({required String id, required String nombre, required String ruc, String? descripcion, String? telefono, double? latitud, double? longitud}) => throw UnimplementedError();
  @override
  Future<void> approveEmployeeRequest({required String requestId, required String employeeId, required String businessId}) => throw UnimplementedError();
  @override
  Future<void> rejectEmployeeRequest({required String requestId, required String employeeId}) => throw UnimplementedError();
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
  }) => throw UnimplementedError();
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
  }) => throw UnimplementedError();
  @override
  Future<void> updateServiceDetails({required String id, required String nombre, String? descripcion, required int duracionMinutos, required ServiceType tipo}) => throw UnimplementedError();
  @override
  Future<void> deleteService(String id) => throw UnimplementedError();
  @override
  Future<void> toggleServiceActive(String id, bool active) => throw UnimplementedError();
  @override
  Future<void> superAdminApproveServicePrice({
    required String id,
    required double precioAprobadoPequeno,
    required double precioAprobadoMediano,
    required double precioAprobadoGrande,
    required double precioAprobadoMoto,
  }) => throw UnimplementedError();
  @override
  Future<EmployeeAvailability?> getEmployeeAvailability({required String businessId, required String employeeId}) => throw UnimplementedError();
  @override
  Future<void> updateEmployeeAvailability({required String recordId, required bool available}) => throw UnimplementedError();
  @override
  Future<List<Map<String, dynamic>>> getBusinessHours(String businessId) => throw UnimplementedError();
  @override
  Future<void> updateBusinessHours(String businessId, List<Map<String, dynamic>> hours) => throw UnimplementedError();
  @override
  Future<List<WashGoBusiness>> getMyBusinesses() => throw UnimplementedError();
  @override
  Future<void> switchCurrentBusiness(String businessId) => throw UnimplementedError();
  @override
  Future<void> updateBusinessPrepaidBalance({required String id, required double saldoPrepagoInicial, required double saldoPrepagoConsumido}) => throw UnimplementedError();
  @override
  Future<List<EmployeeBranchStatus>> getEmployeeBranches() async => [];
  @override
  Future<List<EmployeeBranchStatus>> getEmployeePendingBranches() async => [];
  @override
  Future<void> activateEmployeeShift(String businessId) async {}
  @override
  Future<void> deactivateEmployeeShift(String businessId) async {}
  @override
  Future<void> toggleEmployeeDisabledByOwner({required String businessId, required String employeeId, required bool isDisabled}) async {}
}

void main() {
  testWidgets('PrepaidConsumptionPage renders metrics and history successfully', (WidgetTester tester) async {
    final fakeMetrics = [
      const PrepaidServiceMetricModel(
        id: 'metric_1',
        serviceName: 'Lavado Básico',
        costoUnitario: 5.0,
        cantidad: 30,
        totalConsumido: 150.0,
      ),
      const PrepaidServiceMetricModel(
        id: 'metric_2',
        serviceName: 'Lavado Premium',
        costoUnitario: 10.0,
        cantidad: 15,
        totalConsumido: 150.0,
      ),
    ];

    final fakeHistory = [
      PrepaidHistoryEntryModel(
        id: 'hist_1',
        orderId: 'order_123456789',
        serviceName: 'Lavado Premium',
        costoConsumido: 10.0,
        saldoResultante: 700.0,
        fecha: DateTime(2026, 6, 22, 12, 0),
      ),
    ];

    final fakeRepo = FakeBusinessRepository(metrics: fakeMetrics, history: fakeHistory);

    // Build the page inside MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: PrepaidConsumptionPage(
          businessId: 'test_biz_123',
          businessName: 'Lavandería Central',
          saldoInicial: 1000.0,
          saldoConsumido: 300.0,
          saldoDisponible: 700.0,
          repository: fakeRepo,
        ),
      ),
    );

    // Verify loading indicator is present initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the data load and state update
    await tester.pumpAndSettle();

    // Verify loading indicator is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify title and business name are shown
    expect(find.text('Control de Consumo Prepago'), findsOneWidget);
    expect(find.text('Lavandería Central'), findsOneWidget);

    // Verify the summary cards (Totals)
    expect(find.text('Saldo Disponible'), findsOneWidget);
    expect(find.text('\$700.00'), findsWidgets); // May appear in header/footer/cards

    expect(find.text('Consumo General'), findsOneWidget);
    expect(find.text('\$300.00'), findsWidgets);

    expect(find.text('Servicios Realizados'), findsOneWidget);
    expect(find.text('45'), findsOneWidget); // 30 + 15

    // Verify individual service metrics are rendered
    expect(find.text('Lavado Básico'), findsOneWidget);
    expect(find.text('Lavado Premium'), findsOneWidget);
    expect(find.text('Total: \$150.00'), findsNWidgets(2));

    // Verify bottom bar displays original initial balance
    expect(find.text('Saldo Prepago Inicial'), findsOneWidget);
    expect(find.text('\$1000.00'), findsOneWidget);

    // Tap on the History Tab
    await tester.tap(find.text('Historial de Transacciones'));
    await tester.pumpAndSettle();

    // Verify history entry details
    expect(find.text('Pedido ID: order_12...'), findsOneWidget);
    expect(find.text('-\$10.00'), findsOneWidget);
    expect(find.text('Saldo: \$700.00'), findsOneWidget);
  });
}
