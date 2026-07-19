import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/services/paypal_service.dart';

class PaypalSuccessPage extends StatefulWidget {
  final String? token;
  final String? payerId;

  const PaypalSuccessPage({
    super.key,
    this.token,
    this.payerId,
  });

  @override
  State<PaypalSuccessPage> createState() => _PaypalSuccessPageState();
}

class _PaypalSuccessPageState extends State<PaypalSuccessPage> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _transactionId;
  String? _payerEmail;
  double? _amount;

  @override
  void initState() {
    super.initState();
    _completePayment();
  }

  Future<void> _completePayment() async {
    final orderId = widget.token;
    if (orderId == null || orderId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Falta el token de transacción de PayPal.';
      });
      return;
    }

    try {
      final paypalService = PaypalService();
      await paypalService.init();
      final backend = PaypalBackendService(isSandbox: paypalService.isSandbox);

      final captureResponse = await backend.captureOrder(orderId);
      if (captureResponse == null) {
        throw Exception('No se recibió respuesta al completar el pago.');
      }

      final status = captureResponse['status'];
      if (status == 'COMPLETED') {
        _transactionId = captureResponse['id'] ?? 'PAYID-$orderId';
        final purchaseUnits = captureResponse['purchase_units'] as List?;
        if (purchaseUnits != null && purchaseUnits.isNotEmpty) {
          final amountMap = purchaseUnits[0]['amount'] as Map?;
          if (amountMap != null) {
            _amount = double.tryParse(amountMap['value']?.toString() ?? '');
          }
          final payments = purchaseUnits[0]['payments'] as Map?;
          if (payments != null) {
            final captures = payments['captures'] as List?;
            if (captures != null && captures.isNotEmpty) {
              _transactionId = captures[0]['id'] ?? _transactionId;
            }
          }
        }

        final payer = captureResponse['payer'] as Map?;
        if (payer != null) {
          _payerEmail = payer['email_address'];
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        final errorDetails = captureResponse['details'] as List?;
        String errDetail = 'El pago no se pudo completar.';
        String? errorCode;
        if (errorDetails != null && errorDetails.isNotEmpty) {
          errDetail = errorDetails[0]['description'] ?? errDetail;
          errorCode = errorDetails[0]['issue'] ?? errorDetails[0]['name'];
        }

        if (errDetail.toLowerCase().contains('already captured') ||
            (errorCode != null && errorCode.toLowerCase().contains('already_captured'))) {
          setState(() {
            _transactionId = 'PAYID-$orderId';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _isLoading = false;
          _errorMessage = errDetail;
        });
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('already_captured') || errorStr.contains('already captured')) {
        setState(() {
          _transactionId = 'PAYID-$orderId';
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al completar el pago';
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
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Confirmando Pago con PayPal',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Estamos finalizando la transacción de forma segura con PayPal. No cierres esta ventana.',
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
              backgroundColor: AppColors.primary,
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
          'Tu transacción ha sido procesada de forma segura por PayPal.',
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
              _buildDetailRow('Transacción ID', _transactionId ?? 'N/A', isBold: true),
              if (_payerEmail != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow('Payer Email', _payerEmail!),
              ],
              if (_amount != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow('Monto Total', '\$${_amount!.toStringAsFixed(2)} USD', isBold: true, color: AppColors.primary),
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
