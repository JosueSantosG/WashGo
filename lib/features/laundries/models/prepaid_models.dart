class PrepaidServiceMetricModel {
  final String id;
  final String serviceName;
  final double costoUnitario;
  final int cantidad;
  final double totalConsumido;

  const PrepaidServiceMetricModel({
    required this.id,
    required this.serviceName,
    required this.costoUnitario,
    required this.cantidad,
    required this.totalConsumido,
  });
}

class PrepaidHistoryEntryModel {
  final String id;
  final String orderId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  final DateTime fecha;

  const PrepaidHistoryEntryModel({
    required this.id,
    required this.orderId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
    required this.fecha,
  });
}
