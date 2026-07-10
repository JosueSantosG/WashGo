import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/services/bank_transfer_service.dart';

/// Repository for bank transfer payment operations.
///
/// Wraps [BankTransferService] and provides cached state management
/// for proof status polling, matching the pattern used by other repositories.
class BankTransferRepository {
  final BankTransferService _service;

  BankTransferRepository({BankTransferService? service})
      : _service = service ?? BankTransferService.instance;

  // --- Proof status polling cache ---
  final Map<String, _ProofStatusState> _statusCache = {};

  /// Uploads a payment proof image.
  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required List<int> imageBytes,
    required String extension,
    required double declaredAmount,
    required String paymentAccountType,
    String? referenceNumber,
    String? observations,
  }) async {
    final proof = await _service.uploadProof(
      orderId: orderId,
      imageBytes: imageBytes,
      extension: extension,
      declaredAmount: declaredAmount,
      paymentAccountType: paymentAccountType,
      referenceNumber: referenceNumber,
      observations: observations,
    );

    // Update cache
    _statusCache[orderId] = _ProofStatusState(
      latestProof: proof,
      lastFetch: DateTime.now(),
    );

    return proof;
  }

  /// Approves or rejects a payment proof (owner/admin action).
  Future<Map<String, dynamic>> reviewProof({
    required String orderId,
    required String status,
    String? observations,
  }) async {
    final result = await _service.reviewProof(
      orderId: orderId,
      status: status,
      observations: observations,
    );

    // Invalidate cache so next poll fetches fresh data
    _statusCache.remove(orderId);

    return result;
  }

  /// Gets a signed URL for the proof image (cached for a short period).
  Future<String?> getProofImageUrl(String orderId) async {
    return _service.getProofImageUrl(orderId);
  }

  /// Gets the current proof status, with optional cache.
  Future<Map<String, dynamic>> getProofStatus(
    String orderId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _statusCache[orderId];
      if (cached != null &&
          DateTime.now().difference(cached.lastFetch).inSeconds < 30) {
        return {
          'proof': cached.latestProof,
          'orderStatus': cached.orderStatus,
          'paymentMethod': 'TRANSFERENCIA_BANCARIA',
          'clientName': cached.clientName,
        };
      }
    }

    final data = await _service.getProofStatus(orderId);

    // Update cache
    final proof = data['proof'] as PaymentProofModel?;
    if (proof != null) {
      _statusCache[orderId] = _ProofStatusState(
        latestProof: proof,
        orderStatus: data['orderStatus'] as String? ?? '',
        clientName: data['clientName'] as String?,
        lastFetch: DateTime.now(),
      );
    }

    return data;
  }

  /// Returns a stream that polls proof status at a given interval.
  ///
  /// Useful for the proof status page that needs to auto-refresh
  /// while the admin reviews the proof.
  Stream<PaymentProofModel?> watchProofStatus(
    String orderId, {
    Duration interval = const Duration(seconds: 15),
  }) async* {
    // Yield cached value first if available
    final cached = _statusCache[orderId];
    if (cached != null) {
      yield cached.latestProof;
    }

    await for (final _ in Stream.periodic(interval)) {
      try {
        final data = await getProofStatus(orderId, forceRefresh: true);
        yield data['proof'] as PaymentProofModel?;
      } catch (e) {
        debugPrint('Error polling proof status: $e');
        yield null;
      }
    }
  }

  /// Lists all pending payment proofs for a business.
  Future<List<Map<String, dynamic>>> getPendingProofs(String businessId) async {
    return _service.getPendingProofs(businessId);
  }

  /// Clears the cache for a specific order.
  void clearCache(String orderId) {
    _statusCache.remove(orderId);
  }

  /// Clears all cached data.
  void clearAll() {
    _statusCache.clear();
  }
}

class _ProofStatusState {
  final PaymentProofModel latestProof;
  final String orderStatus;
  final String? clientName;
  final DateTime lastFetch;

  _ProofStatusState({
    required this.latestProof,
    this.orderStatus = '',
    this.clientName,
    required this.lastFetch,
  });
}
