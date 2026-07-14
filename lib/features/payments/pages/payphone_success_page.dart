import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:washgo/config/env/environment.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/invoices/utils/pdf_generator.dart';

class PayphoneSuccessPage extends StatefulWidget {
  final String? transactionId;
  final String? orderId;

  const PayphoneSuccessPage({
    super.key,
    this.transactionId,
    this.orderId,
  });

  @override
  State<PayphoneSuccessPage> createState() => _PayphoneSuccessPageState();
}

class _PayphoneSuccessPageState extends State<PayphoneSuccessPage> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _confirmedTransactionId;
  String? _invoiceNumber;
  double? _amount;
  String? _businessName;
  String? _serviceName;

  @override
  void initState() {
    super.initState();
    _completePayment();
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

  Future<void> _completePayment() async {
    final orderId = widget.orderId;
    final transactionId = widget.transactionId;

    if (orderId == null || orderId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Falta el ID del pedido.';
      });
      return;
    }

    if (transactionId == null || transactionId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Falta el ID de transacción de PayPhone.';
      });
      return;
    }

    try {
      // Wait for Firebase Auth to restore session (max 2 seconds)
      if (FirebaseAuth.instance.currentUser == null) {
        await Future.any([
          FirebaseAuth.instance.authStateChanges().firstWhere((user) => user != null),
          Future.delayed(const Duration(seconds: 2)),
        ]);
      }

      // 1. Fetch Order Details
      final connector = ExampleConnector.instance;
      final orderResult = await connector.getOrderById(id: orderId).execute();
      final order = orderResult.data.order;
      if (order == null) {
        throw Exception('No se encontró el pedido.');
      }

      _amount = order.price;
      _businessName = order.business.nombre;
      _serviceName = order.serviceName ?? 'Servicio de Lavandería';

      // 2. Fetch Business Details for RUC & Description
      final businessResult = await connector.getBusinessDetails(id: order.business.id).execute();
      final biz = businessResult.data.business;
      final String ruc = biz?.ruc ?? '20123456789';
      final String description = biz?.descripcion ?? 'Lavado Profesional';

      // 3. Generate Temporary Invoice Details
      final now = DateTime.now();
      final uniqueSuffix = (now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
      final tempInvoiceNumber = 'FAC-${now.year}-$uniqueSuffix';

      // 4. Generate local PDF invoice
      final pdfBytes = await PdfGenerator.generateInvoicePdf(
        invoiceNumber: tempInvoiceNumber,
        fechaEmision: now,
        businessName: order.business.nombre,
        ruc: ruc,
        description: description,
        clientName: order.client.nombreCompleto,
        clientEmail: order.client.email,
        clientPhone: order.client.telefono,
        employeeName: order.employee?.nombreCompleto ?? 'Sin asignar',
        serviceName: _serviceName!,
        price: order.price,
        paymentMethod: 'PAYPHONE',
        observations: order.observations ?? '',
      );

      final base64Pdf = base64Encode(pdfBytes);

      // 5. Complete PayPhone Payment with Backend
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      final baseUrl = _getFunctionsBaseUrl();

      final response = await http.post(
        Uri.parse('$baseUrl/orders/complete-payphone-payment'),
        headers: {
          'Content-Type': 'application/json',
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'orderId': orderId,
          'transactionId': transactionId,
          'base64Pdf': base64Pdf,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('El servidor respondió con código ${response.statusCode}: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        setState(() {
          _confirmedTransactionId = transactionId;
          _invoiceNumber = responseData['numeroUnico'] ?? tempInvoiceNumber;
          _isLoading = false;
        });
      } else {
        throw Exception('Error al validar la transacción con PayPhone.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al completar el pago: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? _buildLoadingState()
                  : (_errorMessage != null ? _buildErrorState() : _buildSuccessState()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6C00)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Confirmando Pago con PayPhone',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Estamos finalizando la transacción de forma segura con PayPhone. No cierres esta ventana.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF2F2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Error al Procesar Pago',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _errorMessage ?? 'Ocurrió un error inesperado al completar el pago.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6C00),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Volver al Inicio',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFECFDF5),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¡Pago Confirmado!',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Tu transacción ha sido procesada de forma segura por PayPhone.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildDetailRow('Transacción ID', _confirmedTransactionId ?? 'N/A', isBold: true),
              if (_invoiceNumber != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow('Factura Nro.', _invoiceNumber!),
              ],
              if (_businessName != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow('Establecimiento', _businessName!),
              ],
              if (_serviceName != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow('Servicio', _serviceName!),
              ],
              if (_amount != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow(
                  'Monto Total',
                  '\$${_amount!.toStringAsFixed(2)} USD',
                  isBold: true,
                  color: const Color(0xFFFF6C00),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Volver al Inicio',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
