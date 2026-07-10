import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

/// Page that shows the status of a submitted bank transfer proof.
///
/// Auto-polls every 15 seconds while the proof status is PENDING.
/// Shows the uploaded image, current status badge, and relevant actions.
class ProofStatusPage extends StatefulWidget {
  final String orderId;
  final String serviceName;
  final String businessName;

  const ProofStatusPage({
    super.key,
    required this.orderId,
    required this.serviceName,
    required this.businessName,
  });

  @override
  State<ProofStatusPage> createState() => _ProofStatusPageState();
}

class _ProofStatusPageState extends State<ProofStatusPage> {
  final _repository = BankTransferRepository();

  PaymentProofModel? _proof;
  String? _imageUrl;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<PaymentProofModel?>? _pollSubscription;

  @override
  void initState() {
    super.initState();
    _loadInitialStatus();
  }

  @override
  void dispose() {
    _pollSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialStatus() async {
    try {
      final data = await _repository.getProofStatus(widget.orderId);
      final proof = data['proof'] as PaymentProofModel?;

      if (!mounted) return;

      setState(() {
        _proof = proof;
        _isLoading = false;
      });

      // Load image URL if proof exists
      if (proof != null) {
        _loadImageUrl();
      }

      // Start polling if status is PENDING
      if (proof != null && proof.isPending) {
        _startPolling();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar estado: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadImageUrl() async {
    try {
      final url = await _repository.getProofImageUrl(widget.orderId);
      if (!mounted) return;
      setState(() => _imageUrl = url);
    } catch (_) {
      // Non-critical — image URL may not be ready immediately
    }
  }

  void _startPolling() {
    _pollSubscription?.cancel();
    _pollSubscription = _repository
        .watchProofStatus(widget.orderId)
        .listen((PaymentProofModel? updated) {
      if (updated != null && mounted) {
        setState(() {
          _proof = updated;
          // Stop polling once status is no longer PENDING
          if (!updated.isPending) {
            _pollSubscription?.cancel();
            _pollSubscription = null;
          }
        });
        // Reload image URL in case a new image was attached
        _loadImageUrl();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Estado del Pago',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _proof == null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Color(0xFFFCA5A5)),
            const SizedBox(height: 16),
            Text(
              'No pudimos verificar el estado de tu pago',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Intenta de nuevo más tarde.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadInitialStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reintentar',
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Center(child: _buildStatusBadge()),
          const SizedBox(height: 24),

          // Status message
          if (_proof != null) _buildStatusMessage(),
          if (_proof != null) const SizedBox(height: 24),

          // Proof image
          if (_imageUrl != null || _proof != null) _buildProofImageSection(),
          if (_proof != null) const SizedBox(height: 24),

          // Order summary
          _buildOrderSummary(),

          if (_proof != null && _proof!.isRejected) ...[
            const SizedBox(height: 24),
            _buildReuploadButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final bool isPending = _proof?.isPending ?? true;
    final bool isApproved = _proof?.isApproved ?? false;
    final bool isRejected = _proof?.isRejected ?? false;

    IconData icon;
    Color color;
    Color bgColor;
    String label;

    if (isApproved) {
      icon = Icons.check_circle_rounded;
      color = const Color(0xFF16A34A);
      bgColor = const Color(0xFFF0FDF4);
      label = 'Pago Verificado';
    } else if (isRejected) {
      icon = Icons.cancel_rounded;
      color = const Color(0xFFDC2626);
      bgColor = const Color(0xFFFEF2F2);
      label = 'Pago Rechazado';
    } else {
      icon = Icons.access_time_rounded;
      color = const Color(0xFFD97706);
      bgColor = const Color(0xFFFFFBEB);
      label = 'Pago Pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage() {
    if (_proof!.isApproved) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF16A34A), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tu pago ha sido verificado exitosamente. '
                'Tu orden está siendo procesada.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF166534),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_proof!.isRejected) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel_rounded,
                    color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tu comprobante no ha sido aceptado.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF991B1B),
                    ),
                  ),
                ),
              ],
            ),
            if (_proof!.observations != null) ...[
              const SizedBox(height: 8),
              Text(
                'Motivo: ${_proof!.observations}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF991B1B),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Puedes subir un nuevo comprobante.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF991B1B),
              ),
            ),
          ],
        ),
      );
    }

    // PENDING
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFFD97706),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tu comprobante está siendo revisado por el negocio. '
              'Este proceso puede tomar unos minutos.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF92400E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProofImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comprobante enviado',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: _imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                )
              : _buildImagePlaceholder(),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(Icons.image_rounded, size: 48, color: Color(0xFFCBD5E1)),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de la orden',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Servicio', widget.serviceName),
          const SizedBox(height: 8),
          _buildSummaryRow('Negocio', widget.businessName),
          if (_proof != null) ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Monto',
                '\$${_proof!.declaredAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow('Cuenta', _proof!.accountDisplay),
            if (_proof!.referenceNumber != null) ...[
              const SizedBox(height: 8),
              _buildSummaryRow('Referencia', _proof!.referenceNumber!),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildReuploadButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          // Pop back to proof upload page with same order data
          // The upload page will create a fresh proof replacing the rejected one
          Navigator.pushReplacementNamed(
            context,
            '/bank-transfer/upload-proof',
            extra: {
              'orderId': widget.orderId,
              if (_proof != null) 'amount': _proof!.declaredAmount,
              'serviceName': widget.serviceName,
              'businessName': widget.businessName,
              if (_proof != null)
                'paymentAccountType': _proof!.paymentAccountType,
            },
          );
        },
        icon: const Icon(Icons.refresh_rounded),
        label: Text(
          'Subir nuevo comprobante',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
