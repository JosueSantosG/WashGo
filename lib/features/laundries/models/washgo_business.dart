class WashGoBusiness {
  final String id;
  final String nombre;
  final String ruc;
  final String businessCode;
  final String? descripcion;
  final String? telefono;
  final double? latitud;
  final double? longitud;
  final String? status;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;

  const WashGoBusiness({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.businessCode,
    this.descripcion,
    this.telefono,
    this.latitud,
    this.longitud,
    this.status,
    this.saldoPrepagoInicial = 0.0,
    this.saldoPrepagoConsumido = 0.0,
  });

  double get saldoPrepagoDisponible => saldoPrepagoInicial - saldoPrepagoConsumido;
}
