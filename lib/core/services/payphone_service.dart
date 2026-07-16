import 'dart:convert';
import 'package:http/http.dart' as http;

class PayphoneService {
  static Future<String> preparePayment({
    required String orderId,
    required String idToken,
    required String baseUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payphone/prepare'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'orderId': orderId}),
    );
    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al preparar el pago.');
      } catch (_) {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    }
    final data = jsonDecode(response.body);
    return data['payWithCardUrl'] as String;
  }

  static Future<void> cancelPendingOrder({
    required String orderId,
    required String idToken,
    required String baseUrl,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/orders/$orderId/cancel-pending'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al cancelar la orden.');
      } catch (_) {
        throw Exception('Error del servidor al cancelar la orden: ${response.statusCode}');
      }
    }
  }

  /// Retrieves the stored PayPhone transactionId for a given order.
  /// Returns the transactionId string, or null if not found.
  static Future<String?> getStoredTransaction({
    required String orderId,
    required String baseUrl,
    required String idToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId/payphone-transaction'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['transactionId'] as String?;
      }
    } catch (e) {
      // Silently fail — caller handles the null
    }
    return null;
  }

  /// Calls the server-side PayPhone verify endpoint (read-only).
  /// Returns a map with {verified: bool, status: string, simulated?: bool}.
  /// Throws on network/server errors.
  static Future<Map<String, dynamic>> verifyTransaction({
    required String transactionId,
    required String orderId,
    required String idToken,
    required String baseUrl,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payphone/$transactionId/verify?orderId=$orderId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al verificar transacción.');
      } catch (_) {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<void> completePayment({
    required String orderId,
    required String transactionId,
    required String base64Pdf,
    required String idToken,
    required String baseUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/complete-payphone-payment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'orderId': orderId,
        'transactionId': transactionId,
        'base64Pdf': base64Pdf,
      }),
    );
    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        final errorCode = errorData['error'] ?? '';
        if (response.statusCode == 503 || errorCode == 'DATA_CONNECT_UNAVAILABLE') {
          throw Exception('DB_UNAVAILABLE: ${errorData['message'] ?? 'Base de datos no disponible.'}');
        }
        throw Exception(errorCode.isNotEmpty ? errorCode : 'Error al completar el pago.');
      } catch (e) {
        if (e.toString().contains('DB_UNAVAILABLE')) rethrow;
        throw Exception('Error del servidor al completar el pago: ${response.statusCode}');
      }
    }
  }
}
