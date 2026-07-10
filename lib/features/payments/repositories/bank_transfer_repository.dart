import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/services/bank_transfer_service.dart';

class BankTransferRepository {
  final BankTransferService _service;
  final FirebaseStorage _storage;

  BankTransferRepository({
    BankTransferService? service,
    FirebaseStorage? storage,
  })  : _service = service ?? BankTransferService(),
        _storage = storage ?? FirebaseStorage.instance;


  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required String imagePath,
    required PaymentAccountType accountType,
    required String referenceNumber,
    required double amount,
  }) async {
    return _service.uploadProof(
      orderId: orderId,
      imageFile: File(imagePath),
      accountType: accountType.name,
      referenceNumber: referenceNumber,
      amount: amount,
    );
  }

  Future<PaymentProofModel?> getProofStatus(String orderId) async {
    return _service.getProofStatus(orderId);
  }

  Future<String?> getProofImageUrl(String orderId) async {
    return _service.getProofImageUrl(orderId);
  }

  Future<void> reviewProof({
    required String orderId,
    required PaymentProofStatus status,
    String? rejectionReason,
  }) async {
    await _service.reviewProof(
      orderId: orderId,
      status: status,
      rejectionReason: rejectionReason,
    );
  }

  Future<String> uploadProofImageToStorage({
    required String orderId,
    required String imagePath,
  }) async {
    final ref = _storage
        .ref('proofs/$orderId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(File(imagePath));
    return await ref.getDownloadURL();
  }
}
