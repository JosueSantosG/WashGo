import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

class AdminPaymentReviewPage extends StatefulWidget {
  const AdminPaymentReviewPage({super.key});

  @override
  State<AdminPaymentReviewPage> createState() => _AdminPaymentReviewPageState();
}

class _AdminPaymentReviewPageState extends State<AdminPaymentReviewPage> {
  final BankTransferRepository _repository = BankTransferRepository();
  List<PaymentProofModel> _pendingProofs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingProofs();
  }

  Future<void> _loadPendingProofs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final proofs = <PaymentProofModel>[];
      // TODO: fetch pending proofs from backend
      setState(() {
        _pendingProofs = proofs;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _reviewProof(PaymentProofModel proof, PaymentProofStatus status,
      {String? reason}) async {
    try {
      setState(() => _isLoading = true);
      await _repository.reviewProof(
        orderId: proof.orderId,
        status: status,
        rejectionReason: reason,
      );
      await _loadPendingProofs();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  void _showReviewDialog(PaymentProofModel proof) {
    final proofImageUrl = ValueNotifier<String?>(null);
    _repository.getProofImageUrl(proof.orderId).then((url) {
      proofImageUrl.value = url;
    });

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Revisar comprobante',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (proof.referenceNumber != null)
                Text('Referencia: ${proof.referenceNumber}'),
              const SizedBox(height: 8),
              Text('Monto: \$${proof.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Orden: ${proof.orderId.substring(0, 8)}...'),
              const SizedBox(height: 12),
              ValueListenableBuilder<String?>(
                valueListenable: proofImageUrl,
                builder: (context, url, _) {
                  if (url == null) return const CircularProgressIndicator();
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url, height: 200, fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showRejectionDialog(proof);
            },
            child: const Text('Rechazar',
                style: TextStyle(color: AppColors.error)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _reviewProof(proof, PaymentProofStatus.APPROVED);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(PaymentProofModel proof) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Motivo del rechazo',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Explica por qué se rechaza...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reviewProof(proof, PaymentProofStatus.REJECTED,
                  reason: controller.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revisar pagos',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _pendingProofs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _pendingProofs.length,
                      itemBuilder: (context, i) =>
                          _buildProofCard(_pendingProofs[i]),
                    ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 80, color: Color(0xFF16A34A)),
          const SizedBox(height: 16),
          Text('No hay pagos pendientes',
              style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Todos los comprobantes han sido revisados',
              style: GoogleFonts.inter(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildProofCard(PaymentProofModel proof) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text('Orden: ${proof.orderId.substring(0, 8)}...'),
        subtitle: Text('\$${proof.amount.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showReviewDialog(proof),
      ),
    );
  }
}
