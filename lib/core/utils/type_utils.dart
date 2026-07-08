// Utility functions for safe type conversion, particularly addressing
// the Firebase Data Connect emulator returning incorrect types (like booleans)
// for numeric fields on Flutter Web.

/// Safely converts a dynamic value (bool, int, double, num) to a double.
/// If the value is a boolean (e.g. true/false from polluted emulator data), returns 0.0.
double safeDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is bool) return 0.0;
  return 0.0;
}

/// Safely converts a dynamic value (bool, int, double, num) to a nullable double.
/// If the value is null, returns null. If it is a boolean, returns 0.0.
double? safeDoubleNullable(dynamic value) {
  if (value == null) return null;
  return safeDouble(value);
}
