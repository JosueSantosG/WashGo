import 'dart:convert';
import 'dart:io';
<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:washgo/config/env/environment.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';

/// HTTP service that communicates with the Cloud Functions backend
/// for bank transfer payment operations.
///
/// Architecture: Flutter → HTTP → Cloud Function (Express) → Admin SDK → Data Connect
/// All mutations use @auth(NO_ACCESS) so they can only be called server-side.
class BankTransferService {
  static final BankTransferService instance = BankTransferService._();

  BankTransferService._();

  /// Builds the base URL for Cloud Functions based on environment.
  String _getFunctionsBaseUrl() {
    final projectId =
        Firebase.apps.isNotEmpty ? Firebase.app().options.projectId : 'washgo-app-8392';
    if (Environment.useEmulators) {
      return 'http://${Environment.emulatorHost}:5001/$projectId/us-central1/api';
    } else {
      return 'https://us-central1-$projectId.cloudfunctions.net/api';
    }
  }

  /// Gets the current user's ID token for authenticated requests.
  Future<String?> _getIdToken() async {
    try {
      return await FirebaseAuth.instance.currentUser?.getIdToken();
    } catch (e) {
      debugPrint('Error getting ID token: $e');
      return null;
    }
  }

  /// Common headers including auth token if available.
  Future<Map<String, String>> _headers() async {
    final token = await _getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Uploads a payment proof image for a bank transfer order.
  ///
  /// [orderId] - The order ID to attach proof to.
  /// [imageBytes] - Raw bytes of the proof image (JPEG or PNG).
  /// [extension] - File extension e.g. 'jpg', 'jpeg', 'png'.
  /// [declaredAmount] - The amount the client declares having transferred.
  /// [paymentAccountType] - 'GUAYAQUIL' or 'PICHINCHA'.
  /// [referenceNumber] - Optional bank reference/transaction number.
  /// [observations] - Optional additional notes.
  ///
  /// Returns the PaymentProofModel on success.
  /// Throws an exception with a user-friendly message on failure.
  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required List<int> imageBytes,
    required String extension,
    required double declaredAmount,
    required String paymentAccountType,
    String? referenceNumber,
    String? observations,
  }) async {
    final baseUrl = _getFunctionsBaseUrl();
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('$baseUrl/payments/upload-proof'),
      headers: await _headers(),
      body: jsonEncode({
        'orderId': orderId,
        'imageBase64': base64Image,
        'extension': extension,
        'declaredAmount': declaredAmount,
        'paymentAccountType': paymentAccountType,
        if (referenceNumber != null) 'referenceNumber': referenceNumber,
        if (observations != null) 'observations': observations,
      }),
    );

    if (response.statusCode != 200) {
      final body = _tryDecodeError(response.body);
      throw Exception(body['error'] as String? ??
          'Error al subir comprobante (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PaymentProofModel.fromJson(data['proof'] as Map<String, dynamic>);
  }

  /// Approves or rejects a payment proof (admin/business owner action).
  ///
  /// Returns a map with 'success' boolean and optional 'message'.
  Future<Map<String, dynamic>> reviewProof({
    required String orderId,
    required String status, // 'APPROVED' or 'REJECTED'
    String? observations,
  }) async {
    final baseUrl = _getFunctionsBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/payments/review-proof'),
      headers: await _headers(),
      body: jsonEncode({
        'orderId': orderId,
        'status': status,
        if (observations != null) 'observations': observations,
      }),
    );

    if (response.statusCode != 200) {
      final body = _tryDecodeError(response.body);
      throw Exception(body['error'] as String? ??
          'Error al revisar comprobante (${response.statusCode})');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Fetches the signed URL for a proof image (no auth required — URL is short-lived).
  ///
  /// Returns the image URL or null if no proof exists.
  Future<String?> getProofImageUrl(String orderId) async {
    final baseUrl = _getFunctionsBaseUrl();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/proof-image/$orderId'),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['imageUrl'] as String?;
    } catch (e) {
      debugPrint('Error fetching proof image URL: $e');
      return null;
    }
  }

  /// Fetches the payment proof status for an order (no auth required).
  ///
  /// Returns a map with:
  /// - 'proof': PaymentProofModel? (null if no proof submitted)
  /// - 'orderStatus': String
  /// - 'paymentMethod': String
  /// - 'clientName': String? (for guest flow)
  Future<Map<String, dynamic>> getProofStatus(String orderId) async {
    final baseUrl = _getFunctionsBaseUrl();

    final response = await http.get(
      Uri.parse('$baseUrl/payments/proof-status/$orderId'),
    );

    if (response.statusCode != 200) {
      final body = _tryDecodeError(response.body);
      throw Exception(body['error'] as String? ??
          'Error al obtener estado del comprobante (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['proof'] != null) {
      data['proof'] = PaymentProofModel.fromJson(
        data['proof'] as Map<String, dynamic>,
      );
    }
    return data;
  }

  /// Lists all pending payment proofs for a business (owner/admin action).
  ///
  /// Returns a list of maps, each with:
  /// - 'proof': PaymentProofModel
  /// - 'orderId': String
  /// - 'clientName': String?
  /// - 'serviceName': String?
  /// - 'businessName': String?
  Future<List<Map<String, dynamic>>> getPendingProofs(String businessId) async {
    final baseUrl = _getFunctionsBaseUrl();

    final response = await http.get(
      Uri.parse('$baseUrl/payments/pending-proofs/$businessId'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      final body = _tryDecodeError(response.body);
      throw Exception(body['error'] as String? ??
          'Error al obtener comprobantes pendientes (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      if (map['proof'] != null) {
        map['proof'] = PaymentProofModel.fromJson(
          map['proof'] as Map<String, dynamic>,
        );
      }
      return map;
    }).toList();
  }

  /// Tries to decode an error response body.
  static Map<String, dynamic> _tryDecodeError(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'error': body};
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
    }
  }
}
