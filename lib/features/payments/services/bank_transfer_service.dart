import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:washgo/config/env/environment.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';

class BankTransferService {
  String get _baseUrl {
    var projectId = Firebase.apps.isNotEmpty
        ? Firebase.app().options.projectId
        : 'washgo-app-8392';
    if (Environment.useEmulators) {
      if (projectId.endsWith('-dev')) {
        projectId = projectId.substring(0, projectId.length - 4);
      } else if (projectId.endsWith('-staging')) {
        projectId = projectId.substring(0, projectId.length - 8);
      }
      return 'http://${Environment.emulatorHost}:5001/$projectId/us-central1';
    } else {
      return 'https://us-central1-$projectId.cloudfunctions.net';
    }
  }

  final http.Client _client;
  final FirebaseAuth _auth;

  BankTransferService({http.Client? client, FirebaseAuth? auth})
    : _client = client ?? http.Client(),
      _auth = auth ?? FirebaseAuth.instance;

  Future<String?> get _authToken async => await _auth.currentUser?.getIdToken();

  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required XFile imageFile,
    required String accountType,
    required String referenceNumber,
    required double amount,
  }) async {
    final bytes = await imageFile.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw Exception('La imagen del comprobante no puede superar los 5 MB.');
    }
    final base64Image = base64Encode(bytes);
    final ext = imageFile.name.split('.').last;

    final uri = Uri.parse('$_baseUrl/api/payments/upload-proof');
    final token = await _authToken;
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'orderId': orderId,
        'imageBase64': base64Image,
        'imageExt': ext,
        'declaredAmount': amount,
        'paymentAccountType': accountType,
        'referenceNumber': referenceNumber.isNotEmpty ? referenceNumber : null,
      }),
    );

    final body = response.body;

    if (response.statusCode != 200) {
      throw Exception(
        'Error al subir comprobante: ${response.statusCode} - $body',
      );
    }

    // Since the backend returns { success: true, message: ... } instead of the full proof,
    // construct a temporary model representing the newly created PENDING proof.
    return PaymentProofModel(
      orderId: orderId,
      status: PaymentProofStatus.PENDING,
      accountType: PaymentAccountType.values.firstWhere(
        (e) => e.name == accountType,
        orElse: () => PaymentAccountType.GUAYAQUIL,
      ),
      referenceNumber: referenceNumber,
      amount: amount,
      createdAt: DateTime.now(),
    );
  }

  Future<PaymentProofModel?> getProofStatus(String orderId) async {
    final uri = Uri.parse('$_baseUrl/api/payments/proof-status/$orderId');
    final response = await _client.get(uri);

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Error al obtener estado: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['proof'] == null) {
      return null;
    }
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
    return json['imageUrl'] as String?;
  }

  Future<void> reviewProof({
    required String orderId,
    required PaymentProofStatus status,
    String? rejectionReason,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/payments/review-proof');
    final token = await _authToken;
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'orderId': orderId,
        'status': status.name,
        'observations': rejectionReason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al revisar comprobante: ${response.statusCode}');
    }
  }
}
