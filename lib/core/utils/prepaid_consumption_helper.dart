import 'package:flutter/foundation.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:uuid/uuid.dart';

class PrepaidConsumptionHelper {
  @visibleForTesting
  static ExampleConnector connector = ExampleConnector.instance;

  /// Consumes prepaid balance for a completed order, updates service metrics, and logs history.
  static Future<void> consumePrepaidBalanceForOrder(String orderId) async {
    try {
      debugPrint('[PrepaidConsumption] Starting consumption logic for order: $orderId');

      // 0. Check if this order has already consumed prepaid balance
      final historyResponse = await connector.getPrepaidHistoryByOrderId(orderId: orderId).execute();
      if (historyResponse.data.prepaidHistories.isNotEmpty) {
        debugPrint('[PrepaidConsumption] Balance already consumed for order $orderId. Skipping.');
        return;
      }

      // 1. Fetch order details
      final orderResponse = await connector.getOrderById(id: orderId).execute();
      final order = orderResponse.data.order;
      if (order == null) {
        debugPrint('[PrepaidConsumption] Error: Order not found for ID: $orderId');
        return;
      }

      // Check payment method - Cash payments (CASH) must not affect prepaid balance.
      final paymentMethod = order.paymentMethod is Known<PaymentMethod>
          ? (order.paymentMethod as Known<PaymentMethod>).value
          : PaymentMethod.CASH;

      if (paymentMethod == PaymentMethod.CASH) {
        debugPrint('[PrepaidConsumption] Order $orderId was paid in CASH. Skipping prepaid balance deduction.');
        return;
      }

      final businessId = order.business.id;
      final serviceName = order.serviceName ?? 'Servicio Desconocido';
      final costo = order.price;

      debugPrint('[PrepaidConsumption] Order Info - Service: $serviceName, Costo: $costo, Business ID: $businessId');

      // 2. Fetch business details to get the current prepaid balance
      final businessResponse = await connector.getBusinessDetails(id: businessId).execute();
      final business = businessResponse.data.business;
      if (business == null) {
        debugPrint('[PrepaidConsumption] Error: Business not found for ID: $businessId');
        return;
      }

      final saldoPrepagoInicial = business.saldoPrepagoInicial;
      final saldoPrepagoConsumido = business.saldoPrepagoConsumido;
      final newSaldoConsumido = saldoPrepagoConsumido + costo;
      final saldoResultante = saldoPrepagoInicial - newSaldoConsumido;

      debugPrint('[PrepaidConsumption] Prepaid Balance - Initial: $saldoPrepagoInicial, Consumido: $saldoPrepagoConsumido, New Consumido: $newSaldoConsumido');

      final historyId = const Uuid().v4();

      // 3. Check if service metric already exists
      final metricResponse = await connector.getPrepaidServiceMetricByServiceName(
        businessId: businessId,
        serviceName: serviceName,
      ).execute();

      if (metricResponse.data.prepaidServiceMetrics.isNotEmpty) {
        final existingMetric = metricResponse.data.prepaidServiceMetrics.first;
        final newCantidad = existingMetric.cantidad + 1;
        final newTotalConsumido = existingMetric.totalConsumido + costo;

        debugPrint('[PrepaidConsumption] Executing ConsumePrepaidAndUpdateMetric transaction for order: $orderId');
        await connector.consumePrepaidAndUpdateMetric(
          businessId: businessId,
          saldoPrepagoInicial: saldoPrepagoInicial,
          saldoPrepagoConsumido: newSaldoConsumido,
          historyId: historyId,
          orderId: orderId,
          serviceName: serviceName,
          costoConsumido: costo,
          saldoResultante: saldoResultante,
          metricId: existingMetric.id,
          metricCantidad: newCantidad,
          metricTotalConsumido: newTotalConsumido,
        ).execute();
      } else {
        final newMetricId = const Uuid().v4();

        debugPrint('[PrepaidConsumption] Executing ConsumePrepaidAndCreateMetric transaction for order: $orderId');
        await connector.consumePrepaidAndCreateMetric(
          businessId: businessId,
          saldoPrepagoInicial: saldoPrepagoInicial,
          saldoPrepagoConsumido: newSaldoConsumido,
          historyId: historyId,
          orderId: orderId,
          serviceName: serviceName,
          costoConsumido: costo,
          saldoResultante: saldoResultante,
          metricId: newMetricId,
          metricCostoUnitario: costo,
        ).execute();
      }

      debugPrint('[PrepaidConsumption] Prepaid consumption logic completed successfully for order: $orderId');
    } catch (e, stackTrace) {
      debugPrint('[PrepaidConsumption] Exception in consumption logic: $e\n$stackTrace');
    }
  }
}
