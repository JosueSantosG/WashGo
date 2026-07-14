class OrderAuditLog {
  final String id;
  final String actionType;
  final DateTime createdAt;
  final String? previousValue;
  final String? newValue;

  const OrderAuditLog({
    required this.id,
    required this.actionType,
    required this.createdAt,
    this.previousValue,
    this.newValue,
  });
}
