import 'package:washgo/dataconnect-generated/example.dart';

class InvoiceModel {
  final String id;
  final String numeroUnico;
  final DateTime fechaEmision;
  final String? pdfUrl;
  
  // Order details
  final String orderId;
  final double price;
  final String serviceName;
  final String paymentMethod;
  final String orderStatus;
  final String businessName;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String? employeeName;
  final String? employeePhone;
  final String? observations;

  // Financial and metadata fields
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final InvoiceStatus invoiceStatus;
  final DateTime? generatedAt;

  const InvoiceModel({
    required this.id,
    required this.numeroUnico,
    required this.fechaEmision,
    this.pdfUrl,
    required this.orderId,
    required this.price,
    required this.serviceName,
    required this.paymentMethod,
    required this.orderStatus,
    required this.businessName,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.employeeName,
    this.employeePhone,
    this.observations,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.invoiceStatus,
    this.generatedAt,
  });
}

