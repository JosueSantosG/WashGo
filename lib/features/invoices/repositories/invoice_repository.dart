import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/config/env/environment.dart';
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
  Future<InvoiceModel> regenerateInvoicePdf(InvoiceModel invoiceData);
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
        proofImageUrl: inv.order.paymentProof_on_order?.imageUrl,
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
    var projectId = Firebase.apps.isNotEmpty ? Firebase.app().options.projectId : 'washgo-app-8392';
    if (Environment.useEmulators) {
      if (projectId.endsWith('-dev')) {
        projectId = projectId.substring(0, projectId.length - 4);
      } else if (projectId.endsWith('-staging')) {
        projectId = projectId.substring(0, projectId.length - 8);
      }
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

      final now = DateTime.now();
      final uniqueSuffix = (now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');

      // Combine observations safely
      String finalObservations = originalObservations;
      if (employeeNotes.trim().isNotEmpty) {
        if (finalObservations.isNotEmpty) {
          finalObservations += ' | Notas de Entrega: ${employeeNotes.trim()}';
        } else {
          finalObservations = 'Notas de Entrega: ${employeeNotes.trim()}';
        }
      }

      // PDF generation disabled — digital invoice only
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
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to complete cash payment: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      final String invoiceId = responseData['invoiceId'] as String;
      final String numeroUnico = responseData['numeroUnico'] as String;
      final String? pdfUrl = null;

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

    // Prepaid/PayPal/PayPhone/Transferencia — call HTTP endpoint (same pattern as CASH)
    // 1. Fetch business details
    final businessResponse = await _connector.getBusinessDetails(id: businessId).execute();
    final biz = businessResponse.data.business;
    final String businessName = biz?.nombre ?? 'WashGo';
    final now = DateTime.now();

    // 2. Combine observations safely
    String finalObservations = originalObservations;
    if (employeeNotes.trim().isNotEmpty) {
      if (finalObservations.isNotEmpty) {
        finalObservations += ' | Notas de Entrega: ${employeeNotes.trim()}';
      } else {
        finalObservations = 'Notas de Entrega: ${employeeNotes.trim()}';
      }
    }

    // PDF generation disabled — digital invoice only
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    // 5. Call HTTP endpoint (which handles NO_ACCESS mutations server-side)
    final baseUrl = _getFunctionsBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/orders/complete-prepaid-payment'),
      headers: {
        'Content-Type': 'application/json',
        if (idToken != null) 'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'orderId': orderId,
        'paymentMethod': paymentMethod.toUpperCase(),
        'observations': finalObservations,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete prepaid payment: ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    final String invoiceId = responseData['invoiceId'] as String;
    final String numeroUnico = responseData['numeroUnico'] as String;
    final String? pdfUrl = null;

    final double subtotal = price / 1.18;
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

  @override
  Future<InvoiceModel> regenerateInvoicePdf(InvoiceModel invoiceData) async {
    // PDF regeneration disabled — return the invoice data unchanged
    return invoiceData;
  }
}
