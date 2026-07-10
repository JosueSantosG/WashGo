import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
=======
>>>>>>> worktree-fix-flutter-analyze-errors
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

<<<<<<< HEAD
/// Page where a business owner reviews pending bank transfer payment proofs.
///
/// Lists all proofs with PENDING status for the given [businessId].
/// Each proof card shows the submitted image, declared amount, account info,
/// and client details. The owner can Approve (green) or Reject (red) each proof,
/// with an optional observation text (required for rejection).
///
/// Navigated to from the owner dashboard (Facturación tab).
class AdminPaymentReviewPage extends StatefulWidget {
  final String businessId;
  final String businessName;

  const AdminPaymentReviewPage({
    super.key,
    required this.businessId,
    required this.businessName,
  });
=======
class AdminPaymentReviewPage extends StatefulWidget {
  const AdminPaymentReviewPage({super.key});
>>>>>>> worktree-fix-flutter-analyze-errors

  @override
  State<AdminPaymentReviewPage> createState() => _AdminPaymentReviewPageState();
}

class _AdminPaymentReviewPageState extends State<AdminPaymentReviewPage> {
<<<<<<< HEAD
  final _repository = BankTransferRepository();

  List<Map<String, dynamic>> _pendingProofs = [];
  bool _isLoading = true;
  String? _error;
  String? _actionMessage;

  /// Set of orderIds currently being processed (approve/reject in-flight).
  final Set<String> _processingIds = {};
=======
  final BankTransferRepository _repository = BankTransferRepository();
  List<PaymentProofModel> _pendingProofs = [];
  bool _isLoading = true;
  String? _error;
>>>>>>> worktree-fix-flutter-analyze-errors

  @override
  void initState() {
    super.initState();
    _loadPendingProofs();
  }

  Future<void> _loadPendingProofs() async {
    setState(() {
      _isLoading = true;
      _error = null;
<<<<<<< HEAD
      _actionMessage = null;
    });

    try {
      final proofs = await _repository.getPendingProofs(widget.businessId);
      if (!mounted) return;
=======
    });

    try {
      final proofs = <PaymentProofModel>[];
      // TODO: fetch pending proofs from backend
>>>>>>> worktree-fix-flutter-analyze-errors
      setState(() {
        _pendingProofs = proofs;
        _isLoading = false;
      });
    } catch (e) {
<<<<<<< HEAD
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar comprobantes pendientes: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleApprove(String orderId) async {
    setState(() {
      _processingIds.add(orderId);
      _actionMessage = null;
    });

    try {
      await _repository.reviewProof(
        orderId: orderId,
        status: 'APPROVED',
      );
      if (!mounted) return;
      setState(() {
        _pendingProofs.removeWhere(
            (p) => (p['orderId'] as String) == orderId);
        _processingIds.remove(orderId);
        _actionMessage = 'Pago aprobado correctamente.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _processingIds.remove(orderId);
        _actionMessage = 'Error al aprobar: $e';
      });
    }
  }

  Future<void> _showRejectDialog(String orderId) async {
    final observationsController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 24),
            const SizedBox(width: 8),
            Text(
              'Rechazar Pago',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              Text(
                'Indica el motivo del rechazo para que el cliente '
                'pueda corregirlo y volver a subir su comprobante.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: observationsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Motivo del rechazo (requerido)...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF1E293B),
                ),
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
<<<<<<< HEAD
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = observationsController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Debes indicar el motivo del rechazo'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              Navigator.pop(ctx, reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Rechazar',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
          ),
        ],
      ),
    );
<<<<<<< HEAD

    observationsController.dispose();

    if (result != null && mounted) {
      await _handleReject(orderId, result);
    }
  }

  Future<void> _handleReject(String orderId, String observations) async {
    setState(() {
      _processingIds.add(orderId);
      _actionMessage = null;
    });

    try {
      await _repository.reviewProof(
        orderId: orderId,
        status: 'REJECTED',
        observations: observations,
      );
      if (!mounted) return;
      setState(() {
        _pendingProofs.removeWhere(
            (p) => (p['orderId'] as String) == orderId);
        _processingIds.remove(orderId);
        _actionMessage = 'Pago rechazado. Se notificó al cliente.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _processingIds.remove(orderId);
        _actionMessage = 'Error al rechazar: $e';
      });
    }
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Revisar Pagos',
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // Action feedback banner
        if (_actionMessage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: _actionMessage!.startsWith('Error')
                ? const Color(0xFFFEF2F2)
                : const Color(0xFFF0FDF4),
            child: Row(
              children: [
                Icon(
                  _actionMessage!.startsWith('Error')
                      ? Icons.error_outline_rounded
                      : Icons.check_circle_rounded,
                  size: 18,
                  color: _actionMessage!.startsWith('Error')
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF16A34A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _actionMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _actionMessage!.startsWith('Error')
                          ? const Color(0xFF991B1B)
                          : const Color(0xFF166534),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Header summary
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pending_actions_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.businessName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _pendingProofs.isEmpty
                          ? 'No hay comprobantes pendientes'
                          : '${_pendingProofs.length} comprobante${_pendingProofs.length == 1 ? '' : 's'} pendiente${_pendingProofs.length == 1 ? '' : 's'}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _pendingProofs.isEmpty
                            ? const Color(0xFF64748B)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_pendingProofs.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded,
                      color: AppColors.primary),
                  onPressed: _loadPendingProofs,
                  tooltip: 'Actualizar',
                ),
            ],
          ),
        ),

        if (_pendingProofs.isEmpty)
          Expanded(child: _buildEmptyState())
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadPendingProofs,
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _pendingProofs.length,
                itemBuilder: (context, index) =>
                    _buildProofCard(_pendingProofs[index]),
              ),
            ),
          ),
      ],
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
    );
  }

  Widget _buildEmptyState() {
    return Center(
<<<<<<< HEAD
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Todo al día',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay comprobantes de pago pendientes por revisar.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
      ),
    );
  }

<<<<<<< HEAD
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
              'No pudimos cargar los comprobantes',
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
              onPressed: _loadPendingProofs,
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

  Widget _buildProofCard(Map<String, dynamic> item) {
    final proof = item['proof'] as PaymentProofModel;
    final orderId = item['orderId'] as String;
    final clientName = item['clientName'] as String?;
    final serviceName = item['serviceName'] as String?;
    final businessName = item['businessName'] as String?;
    final isProcessing = _processingIds.contains(orderId);

    final bool hasImage = proof.imageUrl.isNotEmpty;
    final dateStr = DateFormat('dd/MM/yy HH:mm').format(proof.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isProcessing
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: isProcessing
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: client name + status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clientName ?? 'Cliente',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Orden: ${orderId.length > 12 ? '...${orderId.substring(orderId.length - 12)}' : orderId}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFFDE68A)),
                        ),
                        child: Text(
                          'Pendiente',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Service & business info
                  if (serviceName != null || businessName != null) ...[
                    Row(
                      children: [
                        if (serviceName != null) ...[
                          const Icon(Icons.local_laundry_service_rounded,
                              size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              serviceName,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Amount + Account row
                  Row(
                    children: [
                      Text(
                        'Monto: ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '\$${proof.declaredAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          proof.accountDisplay,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Reference number
                  if (proof.referenceNumber != null) ...[
                    Text(
                      'Referencia: ${proof.referenceNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Date
                  Text(
                    'Enviado: $dateStr',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),

                  // Proof image thumbnail
                  if (hasImage) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _showImageDialog(proof.imageUrl),
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            proof.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFF8F9FA),
                              child: const Center(
                                child: Icon(Icons.image_not_supported_rounded,
                                    size: 36, color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Customer observations
                  if (proof.observations != null &&
                      proof.observations!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              proof.observations!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Action buttons
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: () => _showRejectDialog(orderId),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: Text(
                              'Rechazar',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFFECACA)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () => _handleApprove(orderId),
                            icon:
                                const Icon(Icons.check_rounded, size: 18),
                            label: Text(
                              'Aprobar',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black87,
                  child: const Center(
                    child: Icon(Icons.image_not_supported_rounded,
                        size: 48, color: Colors.white54),
                  ),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.black87,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
=======
  Widget _buildProofCard(PaymentProofModel proof) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text('Orden: ${proof.orderId.substring(0, 8)}...'),
        subtitle: Text('\$${proof.amount.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showReviewDialog(proof),
>>>>>>> worktree-fix-flutter-analyze-errors
      ),
    );
  }
}
