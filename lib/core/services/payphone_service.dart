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
}
