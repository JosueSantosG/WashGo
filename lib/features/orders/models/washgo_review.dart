class WashGoReview {
  final String id;
  final int calificacion;
  final String? comentario;
  final int? appCalificacion;
  final String? appComentario;
  final DateTime fechaCreacion;
  final String? employeeId;
  final String? employeeName;

  const WashGoReview({
    required this.id,
    required this.calificacion,
    this.comentario,
    this.appCalificacion,
    this.appComentario,
    required this.fechaCreacion,
    this.employeeId,
    this.employeeName,
  });
}
