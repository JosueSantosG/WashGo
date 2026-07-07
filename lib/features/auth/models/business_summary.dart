class BusinessSummary {
  final String id;
  final String nombre;
  final String? descripcion;

  const BusinessSummary({
    required this.id,
    required this.nombre,
    this.descripcion,
  });
}
