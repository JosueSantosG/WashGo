import 'package:flutter_test/flutter_test.dart';
import 'package:washgo/core/utils/prepaid_consumption_helper.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

// Fake implementations for testing
class FakeFirebaseDataConnect implements FirebaseDataConnect {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeQueryResult<T, V> implements QueryResult<T, V> {
  @override
  final T data;

  FakeQueryResult(this.data);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeOperationResult<T, V> implements OperationResult<T, V> {
  @override
  final T data;

  FakeOperationResult(this.data);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// Subclasses of generated builders to return our fake data
class FakeGetPrepaidHistoryByOrderIdVariablesBuilder extends GetPrepaidHistoryByOrderIdVariablesBuilder {
  final Future<QueryResult<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables>> result;

  FakeGetPrepaidHistoryByOrderIdVariablesBuilder(this.result)
      : super(FakeFirebaseDataConnect(), orderId: '');

  @override
  Future<QueryResult<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) => result;
}

class FakeGetOrderByIdVariablesBuilder extends GetOrderByIdVariablesBuilder {
  final Future<QueryResult<GetOrderByIdData, GetOrderByIdVariables>> result;

  FakeGetOrderByIdVariablesBuilder(this.result) : super(FakeFirebaseDataConnect(), id: '');

  @override
  Future<QueryResult<GetOrderByIdData, GetOrderByIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) => result;
}

class FakeGetBusinessDetailsVariablesBuilder extends GetBusinessDetailsVariablesBuilder {
  final Future<QueryResult<GetBusinessDetailsData, GetBusinessDetailsVariables>> result;

  FakeGetBusinessDetailsVariablesBuilder(this.result) : super(FakeFirebaseDataConnect(), id: '');

  @override
  Future<QueryResult<GetBusinessDetailsData, GetBusinessDetailsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) => result;
}

class FakeGetPrepaidServiceMetricByServiceNameVariablesBuilder extends GetPrepaidServiceMetricByServiceNameVariablesBuilder {
  final Future<QueryResult<GetPrepaidServiceMetricByServiceNameData, GetPrepaidServiceMetricByServiceNameVariables>> result;

  FakeGetPrepaidServiceMetricByServiceNameVariablesBuilder(this.result)
      : super(FakeFirebaseDataConnect(), businessId: '', serviceName: '');

  @override
  Future<QueryResult<GetPrepaidServiceMetricByServiceNameData, GetPrepaidServiceMetricByServiceNameVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) => result;
}

class FakeConsumePrepaidAndUpdateMetricVariablesBuilder extends ConsumePrepaidAndUpdateMetricVariablesBuilder {
  FakeConsumePrepaidAndUpdateMetricVariablesBuilder()
      : super(
          FakeFirebaseDataConnect(),
          businessId: '',
          saldoPrepagoInicial: 0.0,
          saldoPrepagoConsumido: 0.0,
          historyId: '',
          orderId: '',
          serviceName: '',
          costoConsumido: 0.0,
          saldoResultante: 0.0,
          metricId: '',
          metricCantidad: 0,
          metricTotalConsumido: 0.0,
        );

  @override
  Future<OperationResult<ConsumePrepaidAndUpdateMetricData, ConsumePrepaidAndUpdateMetricVariables>> execute() async {
    return FakeOperationResult<ConsumePrepaidAndUpdateMetricData, ConsumePrepaidAndUpdateMetricVariables>(
      ConsumePrepaidAndUpdateMetricData(
        prepaidHistory_insert: ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert(id: 'hist_new'),
      ),
    );
  }
}

class FakeConsumePrepaidAndCreateMetricVariablesBuilder extends ConsumePrepaidAndCreateMetricVariablesBuilder {
  FakeConsumePrepaidAndCreateMetricVariablesBuilder()
      : super(
          FakeFirebaseDataConnect(),
          businessId: '',
          saldoPrepagoInicial: 0.0,
          saldoPrepagoConsumido: 0.0,
          historyId: '',
          orderId: '',
          serviceName: '',
          costoConsumido: 0.0,
          saldoResultante: 0.0,
          metricId: '',
          metricCostoUnitario: 0.0,
        );

  @override
  Future<OperationResult<ConsumePrepaidAndCreateMetricData, ConsumePrepaidAndCreateMetricVariables>> execute() async {
    return FakeOperationResult<ConsumePrepaidAndCreateMetricData, ConsumePrepaidAndCreateMetricVariables>(
      ConsumePrepaidAndCreateMetricData(
        prepaidHistory_insert: ConsumePrepaidAndCreateMetricPrepaidHistoryInsert(id: 'hist_new'),
        prepaidServiceMetric_insert: ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert(id: 'metric_new'),
      ),
    );
  }
}

class FakeExampleConnector extends ExampleConnector {
  FakeExampleConnector() : super(dataConnect: FakeFirebaseDataConnect());

  GetPrepaidHistoryByOrderIdVariablesBuilder? mockHistoryBuilder;
  GetOrderByIdVariablesBuilder? mockOrderBuilder;
  GetBusinessDetailsVariablesBuilder? mockBusinessBuilder;
  GetPrepaidServiceMetricByServiceNameVariablesBuilder? mockMetricBuilder;
  
  bool consumeAndUpdateCalled = false;
  bool consumeAndCreateCalled = false;

  @override
  GetPrepaidHistoryByOrderIdVariablesBuilder getPrepaidHistoryByOrderId({required String orderId}) {
    return mockHistoryBuilder ?? FakeGetPrepaidHistoryByOrderIdVariablesBuilder(
      Future.value(FakeQueryResult(GetPrepaidHistoryByOrderIdData(prepaidHistories: []))),
    );
  }

  @override
  GetOrderByIdVariablesBuilder getOrderById({required String id}) {
    return mockOrderBuilder!;
  }

  @override
  GetBusinessDetailsVariablesBuilder getBusinessDetails({required String id}) {
    return mockBusinessBuilder!;
  }

  @override
  GetPrepaidServiceMetricByServiceNameVariablesBuilder getPrepaidServiceMetricByServiceName({
    required String businessId,
    required String serviceName,
  }) {
    return mockMetricBuilder!;
  }

  @override
  ConsumePrepaidAndUpdateMetricVariablesBuilder consumePrepaidAndUpdateMetric({
    required String businessId,
    required double saldoPrepagoInicial,
    required double saldoPrepagoConsumido,
    required String historyId,
    required String orderId,
    required String serviceName,
    required double costoConsumido,
    required double saldoResultante,
    required String metricId,
    required int metricCantidad,
    required double metricTotalConsumido,
  }) {
    consumeAndUpdateCalled = true;
    return FakeConsumePrepaidAndUpdateMetricVariablesBuilder();
  }

  @override
  ConsumePrepaidAndCreateMetricVariablesBuilder consumePrepaidAndCreateMetric({
    required String businessId,
    required double saldoPrepagoInicial,
    required double saldoPrepagoConsumido,
    required String historyId,
    required String orderId,
    required String serviceName,
    required double costoConsumido,
    required double saldoResultante,
    required String metricId,
    required double metricCostoUnitario,
  }) {
    consumeAndCreateCalled = true;
    return FakeConsumePrepaidAndCreateMetricVariablesBuilder();
  }
}

void main() {
  late FakeExampleConnector fakeConnector;

  setUp(() {
    fakeConnector = FakeExampleConnector();
    PrepaidConsumptionHelper.connector = fakeConnector;
  });

  group('PrepaidConsumptionHelper Tests', () {
    test('Skips consumption if prepaid balance was already consumed for this order', () async {
      fakeConnector.mockHistoryBuilder = FakeGetPrepaidHistoryByOrderIdVariablesBuilder(
        Future.value(FakeQueryResult(GetPrepaidHistoryByOrderIdData(
          prepaidHistories: [
            GetPrepaidHistoryByOrderIdPrepaidHistories(
              id: 'hist_1',
              serviceName: 'Lavado Rapido',
              costoConsumido: 0.0,
              saldoResultante: 500.0,
            ),
          ],
        ))),
      );

      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder('order_123');

      expect(fakeConnector.consumeAndUpdateCalled, isFalse);
      expect(fakeConnector.consumeAndCreateCalled, isFalse);
    });

    test('Skips consumption if order payment method is CASH', () async {
      fakeConnector.mockOrderBuilder = FakeGetOrderByIdVariablesBuilder(
        Future.value(FakeQueryResult(GetOrderByIdData(
          order: GetOrderByIdOrder(
            id: 'order_123',
            business: GetOrderByIdOrderBusiness(
              id: 'biz_1',
              nombre: 'Biz 1',
              saldoPrepagoInicial: 100.0,
              saldoPrepagoConsumido: 20.0,
              owner: GetOrderByIdOrderBusinessOwner(id: 'owner_1'),
            ),
            costo: 10.0,
            price: 10.0,
            status: const Known(OrderStatus.COMPLETADO),
            paymentMethod: const Known(PaymentMethod.CASH),
            type: const Known(OrderType.LOCAL),
            client: GetOrderByIdOrderClient(id: 'cli_1', nombreCompleto: 'Client', email: 'cli@test.com'),
          ),
        ))),
      );

      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder('order_123');

      expect(fakeConnector.consumeAndUpdateCalled, isFalse);
      expect(fakeConnector.consumeAndCreateCalled, isFalse);
    });

    test('Completes prepaid deduction and updates metric when metric already exists', () async {
      fakeConnector.mockOrderBuilder = FakeGetOrderByIdVariablesBuilder(
        Future.value(FakeQueryResult(GetOrderByIdData(
          order: GetOrderByIdOrder(
            id: 'order_123',
            business: GetOrderByIdOrderBusiness(
              id: 'biz_1',
              nombre: 'Biz 1',
              saldoPrepagoInicial: 100.0,
              saldoPrepagoConsumido: 20.0,
              owner: GetOrderByIdOrderBusinessOwner(id: 'owner_1'),
            ),
            costo: 15.0,
            price: 15.0,
            serviceName: 'Lavado Básico',
            status: const Known(OrderStatus.COMPLETADO),
            paymentMethod: const Known(PaymentMethod.PAYPAL),
            type: const Known(OrderType.LOCAL),
            client: GetOrderByIdOrderClient(id: 'cli_1', nombreCompleto: 'Client', email: 'cli@test.com'),
          ),
        ))),
      );

      fakeConnector.mockBusinessBuilder = FakeGetBusinessDetailsVariablesBuilder(
        Future.value(FakeQueryResult(GetBusinessDetailsData(
          business: GetBusinessDetailsBusiness(
            id: 'biz_1',
            nombre: 'Biz 1',
            ruc: '12345',
            saldoPrepagoInicial: 100.0,
            saldoPrepagoConsumido: 20.0,
          ),
        ))),
      );

      fakeConnector.mockMetricBuilder = FakeGetPrepaidServiceMetricByServiceNameVariablesBuilder(
        Future.value(FakeQueryResult(GetPrepaidServiceMetricByServiceNameData(
          prepaidServiceMetrics: [
            GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics(
              id: 'metric_1',
              serviceName: 'Lavado Básico',
              costoUnitario: 15.0,
              cantidad: 2,
              totalConsumido: 30.0,
            ),
          ],
        ))),
      );

      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder('order_123');

      expect(fakeConnector.consumeAndUpdateCalled, isTrue);
      expect(fakeConnector.consumeAndCreateCalled, isFalse);
    });

    test('Completes prepaid deduction and creates metric when metric does not exist', () async {
      fakeConnector.mockOrderBuilder = FakeGetOrderByIdVariablesBuilder(
        Future.value(FakeQueryResult(GetOrderByIdData(
          order: GetOrderByIdOrder(
            id: 'order_123',
            business: GetOrderByIdOrderBusiness(
              id: 'biz_1',
              nombre: 'Biz 1',
              saldoPrepagoInicial: 100.0,
              saldoPrepagoConsumido: 20.0,
              owner: GetOrderByIdOrderBusinessOwner(id: 'owner_1'),
            ),
            costo: 15.0,
            price: 15.0,
            serviceName: 'Lavado Express',
            status: const Known(OrderStatus.COMPLETADO),
            paymentMethod: const Known(PaymentMethod.PAYPAL),
            type: const Known(OrderType.LOCAL),
            client: GetOrderByIdOrderClient(id: 'cli_1', nombreCompleto: 'Client', email: 'cli@test.com'),
          ),
        ))),
      );

      fakeConnector.mockBusinessBuilder = FakeGetBusinessDetailsVariablesBuilder(
        Future.value(FakeQueryResult(GetBusinessDetailsData(
          business: GetBusinessDetailsBusiness(
            id: 'biz_1',
            nombre: 'Biz 1',
            ruc: '12345',
            saldoPrepagoInicial: 100.0,
            saldoPrepagoConsumido: 20.0,
          ),
        ))),
      );

      fakeConnector.mockMetricBuilder = FakeGetPrepaidServiceMetricByServiceNameVariablesBuilder(
        Future.value(FakeQueryResult(GetPrepaidServiceMetricByServiceNameData(
          prepaidServiceMetrics: [],
        ))),
      );

      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder('order_123');

      expect(fakeConnector.consumeAndUpdateCalled, isFalse);
      expect(fakeConnector.consumeAndCreateCalled, isTrue);
    });
  });
}
