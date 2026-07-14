import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/services/bank_transfer_service.dart';

import 'package:washgo/dataconnect-generated/example.dart' as dc;

class BankTransferRepository {
  final BankTransferService _service;
  final FirebaseStorage _storage;

  BankTransferRepository({
    BankTransferService? service,
    FirebaseStorage? storage,
  })  : _service = service ?? BankTransferService(),
        _storage = storage ?? FirebaseStorage.instance;

  Future<List<PaymentProofModel>> getPendingProofs(String businessId) async {
    final result = await dc.ExampleConnector.instance
        .getPendingTransferOrders(businessId: businessId)
        .execute();

    final proofs = <PaymentProofModel>[];
    for (final order in result.data.orders) {
      final proofOnOrder = order.paymentProof_on_order;
      if (proofOnOrder != null) {
        PaymentProofStatus status;
        final rawStatus = proofOnOrder.status is dc.Known<dc.PaymentProofStatus>
            ? (proofOnOrder.status as dc.Known<dc.PaymentProofStatus>).value
            : dc.PaymentProofStatus.PENDING;
        switch (rawStatus) {
          case dc.PaymentProofStatus.APPROVED:
            status = PaymentProofStatus.APPROVED;
            break;
          case dc.PaymentProofStatus.REJECTED:
            status = PaymentProofStatus.REJECTED;
            break;
          case dc.PaymentProofStatus.PENDING:
            status = PaymentProofStatus.PENDING;
            break;
        }

        PaymentAccountType accountType;
        final rawAccountType = proofOnOrder.paymentAccountType is dc.Known<dc.PaymentAccountType>
            ? (proofOnOrder.paymentAccountType as dc.Known<dc.PaymentAccountType>).value
            : dc.PaymentAccountType.GUAYAQUIL;
        switch (rawAccountType) {
          case dc.PaymentAccountType.PICHINCHA:
            accountType = PaymentAccountType.PICHINCHA;
            break;
          case dc.PaymentAccountType.GUAYAQUIL:
            accountType = PaymentAccountType.GUAYAQUIL;
            break;
        }

        proofs.add(PaymentProofModel(
          orderId: order.id,
          imageUrl: proofOnOrder.imageUrl,
          status: status,
          accountType: accountType,
          referenceNumber: proofOnOrder.referenceNumber,
          amount: proofOnOrder.declaredAmount,
          createdAt: proofOnOrder.createdAt.toDateTime(),
          rejectionReason: proofOnOrder.observations,
        ));
      }
    }
    return proofs;
  }

  Future<List<PaymentProofModel>> getAllPendingProofs({int? limit, int? offset}) async {
    var builder = dc.ExampleConnector.instance.getPendingPaymentProofs();
    if (limit != null) builder = builder.limit(limit);
    if (offset != null) builder = builder.offset(offset);
    final result = await builder.execute();

    final proofs = <PaymentProofModel>[];
    for (final proof in result.data.paymentProofs) {
      PaymentProofStatus status;
      final rawStatus = proof.status is dc.Known<dc.PaymentProofStatus>
          ? (proof.status as dc.Known<dc.PaymentProofStatus>).value
          : dc.PaymentProofStatus.PENDING;
      switch (rawStatus) {
        case dc.PaymentProofStatus.APPROVED:
          status = PaymentProofStatus.APPROVED;
          break;
        case dc.PaymentProofStatus.REJECTED:
          status = PaymentProofStatus.REJECTED;
          break;
        case dc.PaymentProofStatus.PENDING:
          status = PaymentProofStatus.PENDING;
          break;
      }

      PaymentAccountType accountType;
      final rawAccountType = proof.paymentAccountType is dc.Known<dc.PaymentAccountType>
          ? (proof.paymentAccountType as dc.Known<dc.PaymentAccountType>).value
          : dc.PaymentAccountType.GUAYAQUIL;
      switch (rawAccountType) {
        case dc.PaymentAccountType.PICHINCHA:
          accountType = PaymentAccountType.PICHINCHA;
          break;
        case dc.PaymentAccountType.GUAYAQUIL:
          accountType = PaymentAccountType.GUAYAQUIL;
          break;
      }

      final order = proof.order;
      final reservation = order.orderReservation_on_order;

      proofs.add(PaymentProofModel(
        orderId: order.id,
        imageUrl: proof.imageUrl,
        status: status,
        accountType: accountType,
        referenceNumber: proof.referenceNumber,
        amount: proof.declaredAmount,
        createdAt: proof.createdAt.toDateTime(),
        rejectionReason: proof.observations,
        businessName: order.business.nombre,
        clientName: order.client.nombreCompleto,
        clientPhone: order.client.telefono,
        serviceName: order.serviceName,
        scheduledAt: reservation?.scheduledAt.toDateTime() ?? order.createdAt?.toDateTime(),
        serviceDurationMinutos: reservation?.serviceDurationMinutos,
      ));
    }
    return proofs;
  }

  Stream<List<PaymentProofModel>> watchAllPendingProofs({int? limit, int? offset}) {
    var builder = dc.ExampleConnector.instance.getPendingPaymentProofs();
    if (limit != null) builder = builder.limit(limit);
    if (offset != null) builder = builder.offset(offset);
    return builder
        .ref()
        .subscribe()
        .map((result) {
      final proofs = <PaymentProofModel>[];
      for (final proof in result.data.paymentProofs) {
        PaymentProofStatus status;
        final rawStatus = proof.status is dc.Known<dc.PaymentProofStatus>
            ? (proof.status as dc.Known<dc.PaymentProofStatus>).value
            : dc.PaymentProofStatus.PENDING;
        switch (rawStatus) {
          case dc.PaymentProofStatus.APPROVED:
            status = PaymentProofStatus.APPROVED;
            break;
          case dc.PaymentProofStatus.REJECTED:
            status = PaymentProofStatus.REJECTED;
            break;
          case dc.PaymentProofStatus.PENDING:
            status = PaymentProofStatus.PENDING;
            break;
        }

        PaymentAccountType accountType;
        final rawAccountType = proof.paymentAccountType is dc.Known<dc.PaymentAccountType>
            ? (proof.paymentAccountType as dc.Known<dc.PaymentAccountType>).value
            : dc.PaymentAccountType.GUAYAQUIL;
        switch (rawAccountType) {
          case dc.PaymentAccountType.PICHINCHA:
            accountType = PaymentAccountType.PICHINCHA;
            break;
          case dc.PaymentAccountType.GUAYAQUIL:
            accountType = PaymentAccountType.GUAYAQUIL;
            break;
        }

        final order = proof.order;
        final reservation = order.orderReservation_on_order;

        proofs.add(PaymentProofModel(
          orderId: order.id,
          imageUrl: proof.imageUrl,
          status: status,
          accountType: accountType,
          referenceNumber: proof.referenceNumber,
          amount: proof.declaredAmount,
          createdAt: proof.createdAt.toDateTime(),
          rejectionReason: proof.observations,
          businessName: order.business.nombre,
          clientName: order.client.nombreCompleto,
          clientPhone: order.client.telefono,
          serviceName: order.serviceName,
          scheduledAt: reservation?.scheduledAt.toDateTime() ?? order.createdAt?.toDateTime(),
          serviceDurationMinutos: reservation?.serviceDurationMinutos,
        ));
      }
      return proofs;
    });
  }



  Future<PaymentProofModel> uploadProof({
    required String orderId,
    required XFile imageFile,
    required PaymentAccountType accountType,
    required String referenceNumber,
    required double amount,
  }) async {
    return _service.uploadProof(
      orderId: orderId,
      imageFile: imageFile,
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
    required XFile imageFile,
  }) async {
    final ref = _storage
        .ref('proofs/$orderId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final bytes = await imageFile.readAsBytes();
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }
}
