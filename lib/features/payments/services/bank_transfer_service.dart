import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:washgo/features/payments/models/payment_proof_model.dart';

class BankTransferService {
  static const String _baseUrl =
      'https://us-central1-washgo-app-8392.cloudfunctions.net';
  final http.Client _client;
  final FirebaseAuth _auth;

  BankTransferService({http.Client? client, FirebaseAuth? auth})
      : _client = client ?? http.Client(),
        _auth = auth ?? FirebaseAuth.instance;

  String? get _authToken => _auth.currentUser?.uid;

  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required File imageFile,
    required String accountType,
    required String referenceNumber,
    required double amount,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/payments/upload-proof');
    final request = http.MultipartRequest('POST', uri)
      ..fields['orderId'] = orderId
      ..fields['accountType'] = accountType
      ..fields['referenceNumber'] = referenceNumber
      ..fields['amount'] = amount.toString()
      ..headers['Authorization'] = 'Bearer $_authToken'
      ..files
          .add(await http.MultipartFile.fromPath('proof', imageFile.path));

    final response = await _client.send(request);
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
          'Error al subir comprobante: ${response.statusCode} - $body');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return PaymentProofModel.fromJson(json);
  }

  Future<PaymentProofModel?> getProofStatus(String orderId) async {
    final uri = Uri.parse('$_baseUrl/api/payments/proof-status/$orderId');
    final response = await _client.get(uri);

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Error al obtener estado: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PaymentProofModel.fromJson(json);
  }

  Future<String?> getProofImageUrl(String orderId) async {
    final uri = Uri.parse('$_baseUrl/api/payments/proof-image/$orderId');
    final response = await _client.get(uri);

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Error al obtener imagen: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['signedUrl'] as String?;
  }

  Future<void> reviewProof({
    required String orderId,
    required PaymentProofStatus status,
    String? rejectionReason,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/payments/review-proof');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode({
        'orderId': orderId,
        'status': status.name,
        'rejectionReason': rejectionReason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al revisar comprobante: ${response.statusCode}');
    }
  }
}
