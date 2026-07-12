import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

class ProofStatusPage extends StatefulWidget {
  final String orderId;
  final String proofStatus;
  final double amount;
  final String serviceName;
  final String businessName;

  const ProofStatusPage({
    super.key,
    required this.orderId,
    required this.proofStatus,
    required this.amount,
    required this.serviceName,
    required this.businessName,
  });

  @override
  State<ProofStatusPage> createState() => _ProofStatusPageState();
}

class _ProofStatusPageState extends State<ProofStatusPage> {
  final BankTransferRepository _repository = BankTransferRepository();
  late PaymentProofStatus _currentStatus;
  PaymentProofModel? _proofDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentStatus = PaymentProofStatus.values.firstWhere(
      (s) => s.name == widget.proofStatus,
      orElse: () => PaymentProofStatus.PENDING,
    );
    _loadProofDetails();
  }

  Future<void> _loadProofDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final proof = await _repository.getProofStatus(widget.orderId);
      if (mounted) {
        setState(() {
          _proofDetails = proof;
          if (proof != null) {
            _currentStatus = proof.status;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
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
            : _error != null
                ? _buildErrorView()
                : RefreshIndicator(
                    onRefresh: _loadProofDetails,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildStatusHeader(),
                          const SizedBox(height: 24),
                          _buildInfoCard(),
                          const SizedBox(height: 16),
                          _buildTimeline(),
                          const SizedBox(height: 24),
                          _buildActions(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar información',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProofDetails,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    IconData icon;
    Color color;
    String title;
    String subtitle;

    switch (_currentStatus) {
      case PaymentProofStatus.PENDING:
        icon = Icons.access_time_rounded;
        color = const Color(0xFFD97706);
        title = 'Comprobante recibido';
        subtitle = 'Estamos revisando tu pago. Este proceso puede tomar hasta 24 horas.';
        break;
      case PaymentProofStatus.APPROVED:
        icon = Icons.check_circle_rounded;
        color = const Color(0xFF16A34A);
        title = 'Pago verificado';
        subtitle = 'Tu transferencia ha sido confirmada. Tu servicio está siendo procesado.';
        break;
      case PaymentProofStatus.REJECTED:
        icon = Icons.cancel_rounded;
        color = const Color(0xFFDC2626);
        title = 'Pago rechazado';
        subtitle = _proofDetails?.rejectionReason ??
            'El comprobante no pudo ser verificado. Por favor sube un nuevo comprobante.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 44),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Servicio', widget.serviceName),
          const Divider(height: 20),
          _buildInfoRow('Negocio', widget.businessName),
          const Divider(height: 20),
          _buildInfoRow('Orden', widget.orderId.substring(0, 12).toUpperCase()),
          const Divider(height: 20),
          _buildInfoRow(
            'Monto',
            '\$${widget.amount.toStringAsFixed(2)}',
            valueBold: true,
          ),
          if (_proofDetails?.referenceNumber != null) ...[
            const Divider(height: 20),
            _buildInfoRow('Referencia', _proofDetails!.referenceNumber!),
          ],
          if (_proofDetails?.accountType != null) ...[
            const Divider(height: 20),
            _buildInfoRow(
              'Banco',
              _proofDetails!.accountType == PaymentAccountType.GUAYAQUIL
                  ? 'Banco Guayaquil'
                  : 'Banco Pichincha',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool valueBold = false}) {
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
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
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
            'Proceso',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineStep('Comprobante enviado', true,
              isFirst: true,
              status: _currentStatus == PaymentProofStatus.PENDING
                  ? 'active'
                  : 'completed'),
          _buildTimelineStep(
            'Pago verificado',
            _currentStatus == PaymentProofStatus.APPROVED,
            status: _currentStatus == PaymentProofStatus.APPROVED
                ? 'completed'
                : _currentStatus == PaymentProofStatus.REJECTED
                    ? 'failed'
                    : 'pending',
          ),
          _buildTimelineStep('Servicio procesado',
              _currentStatus == PaymentProofStatus.APPROVED,
              status: _currentStatus == PaymentProofStatus.APPROVED
                  ? 'completed'
                  : 'pending',
              isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String label, bool isActive,
      {bool isFirst = false, bool isLast = false, String status = 'pending'}) {
    Color getColor() {
      switch (status) {
        case 'completed':
          return const Color(0xFF16A34A);
        case 'active':
          return const Color(0xFFD97706);
        case 'failed':
          return const Color(0xFFDC2626);
        default:
          return const Color(0xFFCBD5E1);
      }
    }

    IconData getIcon() {
      switch (status) {
        case 'completed':
          return Icons.check_circle_rounded;
        case 'active':
          return Icons.access_time_rounded;
        case 'failed':
          return Icons.cancel_rounded;
        default:
          return Icons.radio_button_unchecked_rounded;
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 16,
                    color: getColor().withValues(alpha: 0.3),
                  ),
                Icon(getIcon(), color: getColor(), size: 22),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: status == 'pending'
                          ? const Color(0xFFE2E8F0)
                          : getColor().withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: status == 'pending'
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF1E293B),
                fontWeight: status != 'pending' ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (_currentStatus == PaymentProofStatus.REJECTED) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {
            context.pushReplacementNamed(
              AppRoutes.proofUpload,
              extra: {
                'orderId': widget.orderId,
                'amount': widget.amount,
                'serviceName': widget.serviceName,
                'businessName': widget.businessName,
              },
            );
          },
          icon: const Icon(Icons.refresh_rounded, size: 20),
          label: Text(
            'Subir nuevo comprobante',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
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

    if (_currentStatus == PaymentProofStatus.APPROVED) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () => context.go('/reservas'),
          icon: const Icon(Icons.list_alt_rounded, size: 20),
          label: Text(
            'Ir a mis reservas',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    // PENDING status
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _loadProofDetails,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: Text(
              'Actualizar estado',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/reservas'),
          child: Text(
            'Ir a mis reservas',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
