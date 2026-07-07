import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/invoices/utils/pdf_generator.dart';
import 'package:washgo/config/env/environment.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

abstract class InvoiceRepository {
  Future<List<InvoiceModel>> getClientInvoices({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  });
  Future<List<InvoiceModel>> getEmployeeInvoices({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  });
  Future<List<InvoiceModel>> getBusinessInvoices(
    String businessId, {
    int? limit,
    int? offset,
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  });
  Future<InvoiceModel> completeOrderWithInvoice({
    required String orderId,
    required String originalObservations,
    required String employeeNotes,
    required double price,
    required String serviceName,
    required String paymentMethod,
    required String businessId,
    required String employeeId,
    required String employeeName,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
  });
  Future<InvoiceModel> regenerateInvoicePdf(String invoiceId);
}


class FirebaseInvoiceRepository implements InvoiceRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<List<InvoiceModel>> getClientInvoices({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  }) async {
    var builder = _connector.getClientInvoices();
    if (limit != null) builder = builder.limit(limit);
    if (offset != null) builder = builder.offset(offset);
    if (startDate != null) {
      builder = builder.startDate(Timestamp.fromJson(startDate.toUtc().toIso8601String()));
    }
    if (endDate != null) {
      builder = builder.endDate(Timestamp.fromJson(endDate.toUtc().toIso8601String()));
    }
    if (paymentMethod != null) builder = builder.paymentMethod(paymentMethod);
    if (status != null) builder = builder.status(status);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      builder = builder.searchQuery(searchQuery);
    }
    final response = await builder.ref().execute(
      fetchPolicy: QueryFetchPolicy.preferCache,
    );
    return response.data.invoices.map((inv) {
      return InvoiceModel(
        id: inv.id,
        numeroUnico: inv.numeroUnico,
        fechaEmision: inv.fechaEmision.toDateTime(),
        pdfUrl: inv.pdfUrl,
        orderId: inv.order.id,
        price: inv.order.price,
        serviceName: inv.order.serviceName ?? '',
        paymentMethod: inv.order.paymentMethod.stringValue,
        orderStatus: inv.order.status.stringValue,
        businessName: inv.order.business.nombre,
        employeeName: inv.order.employee?.nombreCompleto,
        employeePhone: inv.order.employee?.telefono,
        subtotal: inv.subtotal,
        discount: inv.discount,
        tax: inv.tax,
        total: inv.total,
        invoiceStatus: inv.invoiceStatus is Known<InvoiceStatus>
            ? (inv.invoiceStatus as Known<InvoiceStatus>).value
            : InvoiceStatus.PENDING,
        generatedAt: inv.generatedAt?.toDateTime(),
      );
    }).toList();
  }

  @override
  Future<List<InvoiceModel>> getEmployeeInvoices({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  }) async {
    var builder = _connector.getEmployeeInvoices();
    if (limit != null) builder = builder.limit(limit);
    if (offset != null) builder = builder.offset(offset);
    if (startDate != null) {
      builder = builder.startDate(Timestamp.fromJson(startDate.toUtc().toIso8601String()));
    }
    if (endDate != null) {
      builder = builder.endDate(Timestamp.fromJson(endDate.toUtc().toIso8601String()));
    }
    if (paymentMethod != null) builder = builder.paymentMethod(paymentMethod);
    if (status != null) builder = builder.status(status);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      builder = builder.searchQuery(searchQuery);
    }
    final response = await builder.ref().execute(
      fetchPolicy: QueryFetchPolicy.preferCache,
    );
    return response.data.invoices.map((inv) {
      return InvoiceModel(
        id: inv.id,
        numeroUnico: inv.numeroUnico,
        fechaEmision: inv.fechaEmision.toDateTime(),
        pdfUrl: inv.pdfUrl,
        orderId: inv.order.id,
        price: inv.order.price,
        serviceName: inv.order.serviceName ?? '',
        paymentMethod: inv.order.paymentMethod.stringValue,
        orderStatus: inv.order.status.stringValue,
        businessName: inv.order.business.nombre,
        clientName: inv.order.client.nombreCompleto,
        clientEmail: inv.order.client.email,
        clientPhone: inv.order.client.telefono,
        observations: inv.order.observations,
        subtotal: inv.subtotal,
        discount: inv.discount,
        tax: inv.tax,
        total: inv.total,
        invoiceStatus: inv.invoiceStatus is Known<InvoiceStatus>
            ? (inv.invoiceStatus as Known<InvoiceStatus>).value
            : InvoiceStatus.PENDING,
        generatedAt: inv.generatedAt?.toDateTime(),
      );
    }).toList();
  }

  @override
  Future<List<InvoiceModel>> getBusinessInvoices(
    String businessId, {
    int? limit,
    int? offset,
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    PaymentMethod? paymentMethod,
    InvoiceStatus? status,
    String? searchQuery,
  }) async {
    var builder = _connector.getBusinessInvoices(businessId: businessId);
    if (limit != null) builder = builder.limit(limit);
    if (offset != null) builder = builder.offset(offset);
    if (employeeId != null) builder = builder.employeeId(employeeId);
    if (startDate != null) {
      builder = builder.startDate(Timestamp.fromJson(startDate.toUtc().toIso8601String()));
    }
    if (endDate != null) {
      builder = builder.endDate(Timestamp.fromJson(endDate.toUtc().toIso8601String()));
    }
    if (paymentMethod != null) builder = builder.paymentMethod(paymentMethod);
    if (status != null) builder = builder.status(status);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      builder = builder.searchQuery(searchQuery);
    }
    final response = await builder.ref().execute(
      fetchPolicy: QueryFetchPolicy.preferCache,
    );
    return response.data.invoices.map((inv) {
      return InvoiceModel(
        id: inv.id,
        numeroUnico: inv.numeroUnico,
        fechaEmision: inv.fechaEmision.toDateTime(),
        pdfUrl: inv.pdfUrl,
        orderId: inv.order.id,
        price: inv.order.price,
        serviceName: inv.order.serviceName ?? '',
        paymentMethod: inv.order.paymentMethod.stringValue,
        orderStatus: inv.order.status.stringValue,
        businessName: '',
        clientName: inv.order.client.nombreCompleto,
        clientEmail: inv.order.client.email,
        clientPhone: inv.order.client.telefono,
        employeeName: inv.order.employee?.nombreCompleto,
        employeePhone: inv.order.employee?.telefono,
        subtotal: inv.subtotal,
        discount: inv.discount,
        tax: inv.tax,
        total: inv.total,
        invoiceStatus: inv.invoiceStatus is Known<InvoiceStatus>
            ? (inv.invoiceStatus as Known<InvoiceStatus>).value
            : InvoiceStatus.PENDING,
        generatedAt: inv.generatedAt?.toDateTime(),
      );
    }).toList();
  }

  String _getFunctionsBaseUrl() {
    final projectId = Firebase.apps.isNotEmpty ? Firebase.app().options.projectId : 'washgo-app-8392';
    if (Environment.useEmulators) {
      return 'http://${Environment.emulatorHost}:5001/$projectId/us-central1/api';
    } else {
      return 'https://us-central1-$projectId.cloudfunctions.net/api';
    }
  }

  @override
  Future<InvoiceModel> completeOrderWithInvoice({
    required String orderId,
    required String originalObservations,
    required String employeeNotes,
    required double price,
    required String serviceName,
    required String paymentMethod,
    required String businessId,
    required String employeeId,
    required String employeeName,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
  }) async {
    final bool isCash = paymentMethod.toUpperCase() == 'CASH';

    if (isCash) {
      // 1. Fetch business details
      final businessResponse = await _connector.getBusinessDetails(id: businessId).execute();
      final biz = businessResponse.data.business;
      final String businessName = biz?.nombre ?? 'WashGo';
      final String ruc = biz?.ruc ?? '20123456789';
      final String description = biz?.descripcion ?? 'Lavado Profesional';

      final now = DateTime.now();
      final uniqueSuffix = (now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
      final tempInvoiceNumber = 'FAC-${now.year}-$uniqueSuffix';

      // Combine observations safely
      String finalObservations = originalObservations;
      if (employeeNotes.trim().isNotEmpty) {
        if (finalObservations.isNotEmpty) {
          finalObservations += ' | Notas de Entrega: ${employeeNotes.trim()}';
        } else {
          finalObservations = 'Notas de Entrega: ${employeeNotes.trim()}';
        }
      }

      final pdfBytes = await PdfGenerator.generateInvoicePdf(
        invoiceNumber: tempInvoiceNumber,
        fechaEmision: now,
        businessName: businessName,
        ruc: ruc,
        description: description,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        employeeName: employeeName,
        serviceName: serviceName,
        price: price,
        paymentMethod: paymentMethod,
        observations: finalObservations,
      );

      final base64Pdf = base64Encode(pdfBytes);
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      final baseUrl = _getFunctionsBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/orders/complete-cash-payment'),
        headers: {
          'Content-Type': 'application/json',
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'orderId': orderId,
          'base64Pdf': base64Pdf,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to complete cash payment: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      final String invoiceId = responseData['invoiceId'] as String;
      final String numeroUnico = responseData['numeroUnico'] as String;
      final String? pdfUrl = responseData['invoiceUrl'] as String?;

      final double subtotal = price / 1.15;
      final double tax = price - subtotal;

      return InvoiceModel(
        id: invoiceId,
        numeroUnico: numeroUnico,
        fechaEmision: now,
        pdfUrl: pdfUrl,
        orderId: orderId,
        price: price,
        serviceName: serviceName,
        paymentMethod: paymentMethod,
        orderStatus: 'COMPLETADO',
        businessName: businessName,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        employeeName: employeeName,
        employeePhone: null,
        subtotal: subtotal,
        discount: 0.0,
        tax: tax,
        total: price,
        invoiceStatus: InvoiceStatus.GENERATED,
        generatedAt: now,
      );
    }

    // Prepaid/PayPal local flow if not CASH
    // 1. Fetch business details
    final businessResponse = await _connector.getBusinessDetails(id: businessId).execute();
    final biz = businessResponse.data.business;
    final String businessName = biz?.nombre ?? 'WashGo';
    final String ruc = biz?.ruc ?? '20123456789';
    final String description = biz?.descripcion ?? 'Lavado Profesional';

    // 2. Generate unique invoice number: FAC-YYYY-XXXXXX
    final now = DateTime.now();
    final uniqueSuffix = (now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    final invoiceNumber = 'FAC-${now.year}-$uniqueSuffix';

    // Combine observations safely
    String finalObservations = originalObservations;
    if (employeeNotes.trim().isNotEmpty) {
      if (finalObservations.isNotEmpty) {
        finalObservations += ' | Notas de Entrega: ${employeeNotes.trim()}';
      } else {
        finalObservations = 'Notas de Entrega: ${employeeNotes.trim()}';
      }
    }

    // 3. Compute financial details
    final double subtotal = price / 1.18;
    final double discount = 0.0;
    final double tax = price - subtotal;
    final double total = price;
    final PaymentMethod pmVal = (paymentMethod.toUpperCase() == 'PAYPAL')
        ? PaymentMethod.PAYPAL
        : PaymentMethod.CASH;

    final String invoiceId = orderId;

    // 4. Generate and Upload PDF with CORS safety (try-catch)
    String? pdfUrl;
    InvoiceStatus finalStatus = InvoiceStatus.PENDING;
    try {
      final pdfBytes = await PdfGenerator.generateInvoicePdf(
        invoiceNumber: invoiceNumber,
        fechaEmision: now,
        businessName: businessName,
        ruc: ruc,
        description: description,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        employeeName: employeeName,
        serviceName: serviceName,
        price: price,
        paymentMethod: paymentMethod,
        observations: finalObservations,
      );

      final storageRef = FirebaseStorage.instance.ref().child('invoices/$orderId.pdf');
      final metadata = SettableMetadata(contentType: 'application/pdf');
      final uploadTask = await storageRef.putData(pdfBytes, metadata);
      pdfUrl = await uploadTask.ref.getDownloadURL();
      finalStatus = InvoiceStatus.GENERATED;
    } catch (e) {
      debugPrint('Error generating/uploading PDF invoice: $e');
      finalStatus = InvoiceStatus.FAILED;
    }

    // 5. Execute single atomic transaction!
    final double saldoPrepagoInicial = biz?.saldoPrepagoInicial ?? 0.0;
    final double saldoPrepagoConsumido = biz?.saldoPrepagoConsumido ?? 0.0;
    final double newSaldoConsumido = saldoPrepagoConsumido + price;
    final double saldoResultante = saldoPrepagoInicial - newSaldoConsumido;
    
    final historyId = const Uuid().v4();

    // Check if service metric already exists
    final metricResponse = await _connector.getPrepaidServiceMetricByServiceName(
      businessId: businessId,
      serviceName: serviceName,
    ).execute();

    if (metricResponse.data.prepaidServiceMetrics.isNotEmpty) {
      final existingMetric = metricResponse.data.prepaidServiceMetrics.first;
      final newCantidad = existingMetric.cantidad + 1;
      final newTotalConsumido = existingMetric.totalConsumido + price;

      await _connector.completeOrderWithPrepaidAndUpdateMetric(
        orderId: orderId,
        orderIdStr: orderId,
        invoiceId: invoiceId,
        numeroUnico: invoiceNumber,
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        total: total,
        paymentMethod: pmVal,
        invoiceStatus: finalStatus,
        businessId: businessId,
        saldoPrepagoInicial: saldoPrepagoInicial,
        saldoPrepagoConsumido: newSaldoConsumido,
        historyId: historyId,
        serviceName: serviceName,
        costoConsumido: price,
        saldoResultante: saldoResultante,
        metricId: existingMetric.id,
        metricCantidad: newCantidad,
        metricTotalConsumido: newTotalConsumido,
      )
      .observations(finalObservations)
      .invoiceUrl(pdfUrl)
      .execute();
    } else {
      final newMetricId = const Uuid().v4();

      await _connector.completeOrderWithPrepaidAndCreateMetric(
        orderId: orderId,
        orderIdStr: orderId,
        invoiceId: invoiceId,
        numeroUnico: invoiceNumber,
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        total: total,
        paymentMethod: pmVal,
        invoiceStatus: finalStatus,
        businessId: businessId,
        saldoPrepagoInicial: saldoPrepagoInicial,
        saldoPrepagoConsumido: newSaldoConsumido,
        historyId: historyId,
        serviceName: serviceName,
        costoConsumido: price,
        saldoResultante: saldoResultante,
        metricId: newMetricId,
        metricCostoUnitario: price,
      )
      .observations(finalObservations)
      .invoiceUrl(pdfUrl)
      .execute();
    }

    return InvoiceModel(
      id: invoiceId,
      numeroUnico: invoiceNumber,
      fechaEmision: now,
      pdfUrl: pdfUrl,
      orderId: orderId,
      price: price,
      serviceName: serviceName,
      paymentMethod: paymentMethod,
      orderStatus: 'COMPLETADO',
      businessName: businessName,
      clientName: clientName,
      clientEmail: clientEmail,
      clientPhone: clientPhone,
      employeeName: employeeName,
      employeePhone: null,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      invoiceStatus: finalStatus,
      generatedAt: now,
    );
  }

  @override
  Future<InvoiceModel> regenerateInvoicePdf(String invoiceId) async {
    // 1. Fetch the invoice details via DataConnect
    final response = await _connector.getInvoiceById(id: invoiceId).ref().execute(
      fetchPolicy: QueryFetchPolicy.serverOnly,
    );
    final inv = response.data.invoice;
    if (inv == null) {
      throw Exception('Invoice not found: $invoiceId');
    }

    final String businessName = inv.order.business.nombre;
    final String ruc = inv.order.business.ruc;
    final String description = inv.order.business.descripcion ?? 'Lavado Profesional';
    final String invoiceNumber = inv.numeroUnico;
    final DateTime now = inv.fechaEmision.toDateTime();
    final String clientName = inv.order.client.nombreCompleto;
    final String clientEmail = inv.order.client.email;
    final String? clientPhone = inv.order.client.telefono;
    final String? employeeName = inv.order.employee?.nombreCompleto;
    final String serviceName = inv.order.serviceName ?? '';
    final double price = inv.order.price;
    final String paymentMethod = inv.order.paymentMethod.stringValue;
    final String finalObservations = inv.order.observations ?? '';

    // 2. Generate and Upload PDF
    String? pdfUrl;
    InvoiceStatus finalStatus = InvoiceStatus.PENDING;
    try {
      final pdfBytes = await PdfGenerator.generateInvoicePdf(
        invoiceNumber: invoiceNumber,
        fechaEmision: now,
        businessName: businessName,
        ruc: ruc,
        description: description,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        employeeName: employeeName ?? 'Sin asignar',
        serviceName: serviceName,
        price: price,
        paymentMethod: paymentMethod,
        observations: finalObservations,
      );

      final storageRef = FirebaseStorage.instance.ref().child('invoices/$invoiceId.pdf');
      final metadata = SettableMetadata(contentType: 'application/pdf');
      final uploadTask = await storageRef.putData(pdfBytes, metadata);
      pdfUrl = await uploadTask.ref.getDownloadURL();
      finalStatus = InvoiceStatus.GENERATED;
    } catch (e) {
      debugPrint('Error regenerating/uploading PDF invoice: $e');
      finalStatus = InvoiceStatus.FAILED;
    }

    // 3. Update the Invoice with pdfUrl (if generated successfully) and finalStatus
    try {
      await _connector.updateInvoicePdf(
        id: invoiceId,
        invoiceStatus: finalStatus,
      ).pdfUrl(pdfUrl).execute();
    } catch (e) {
      debugPrint('Error updating invoice PDF status in DB: $e');
    }

    // 4. Update the order with finalObservations and invoiceUrl
    try {
      await _connector.updateOrderCompletion(
        orderId: invoiceId,
      )
      .observations(finalObservations)
      .invoiceUrl(pdfUrl)
      .execute();
    } catch (e) {
      debugPrint('Error updating order completion: $e');
    }

    return InvoiceModel(
      id: invoiceId,
      numeroUnico: invoiceNumber,
      fechaEmision: now,
      pdfUrl: pdfUrl,
      orderId: invoiceId,
      price: price,
      serviceName: serviceName,
      paymentMethod: paymentMethod,
      orderStatus: inv.order.status.stringValue,
      businessName: businessName,
      clientName: clientName,
      clientEmail: clientEmail,
      clientPhone: clientPhone,
      employeeName: employeeName,
      employeePhone: inv.order.employee?.telefono,
      subtotal: inv.subtotal,
      discount: inv.discount,
      tax: inv.tax,
      total: inv.total,
      invoiceStatus: finalStatus,
      generatedAt: now,
    );
  }
}
