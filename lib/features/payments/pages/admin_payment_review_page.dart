import 'dart:async';
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
  final ScrollController _scrollController = ScrollController();

  List<PaymentProofModel> _pendingProofs = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  StreamSubscription<List<PaymentProofModel>>? _subscription;

  int _currentLimit = 15;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPendingProofs();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    // Si el usuario llega al 90% del scroll, cargamos más
    if (maxScroll - currentScroll <= 200) {
      _loadMoreProofs();
    }
  }

  void _subscribeToPendingProofs({bool isLoadMore = false}) {
    _subscription?.cancel();
    if (!isLoadMore) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    _subscription = _repository.watchAllPendingProofs(limit: _currentLimit).listen(
      (proofs) {
        if (!mounted) return;
        setState(() {
          _pendingProofs = proofs;
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          if (_pendingProofs.isEmpty) {
            _error = e.toString();
          } else {
            debugPrint("Error watching pending proofs: $e");
          }
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
    );
  }

  Future<void> _loadMoreProofs() async {
    final hasMore = _pendingProofs.length == _currentLimit;
    if (_isLoading || _isLoadingMore || !hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentLimit += 15;
    });

    try {
      final proofs = await _repository.getAllPendingProofs(limit: _currentLimit);
      if (!mounted) return;
      setState(() {
        _pendingProofs = proofs;
        _isLoadingMore = false;
      });
      _subscribeToPendingProofs(isLoadMore: true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          debugPrint("Error loading more proofs: $e");
        });
      }
    }
  }

  Future<void> _loadPendingProofs() async {
    try {
      setState(() {
        _currentLimit = 15;
        _error = null;
      });
      final proofs = await _repository.getAllPendingProofs(limit: _currentLimit);
      if (!mounted) return;
      setState(() {
        _pendingProofs = proofs;
        _isLoading = false;
      });
      _subscribeToPendingProofs(isLoadMore: true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _reviewProof(
    PaymentProofModel proof,
    PaymentProofStatus status, {
    String? reason,
  }) async {
    try {
      setState(() => _isLoading = true);
      await _repository.reviewProof(
        orderId: proof.orderId,
        status: status,
        rejectionReason: reason,
      );
      if (mounted) {
        await _loadPendingProofs();
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == PaymentProofStatus.APPROVED
                ? 'Comprobante aprobado exitosamente'
                : 'Comprobante rechazado exitosamente',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: status == PaymentProofStatus.APPROVED
              ? const Color(0xFF10B981)
              : const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al revisar el comprobante: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'No programada';
    final localDt = dt.toLocal();
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    final day = localDt.day.toString().padLeft(2, '0');
    final month = months[localDt.month - 1];
    final hour = localDt.hour.toString().padLeft(2, '0');
    final minute = localDt.minute.toString().padLeft(2, '0');
    return '$day $month ${localDt.year}, $hour:$minute';
  }

  String _formatTimeAgo(DateTime dateTime) {
    final localDt = dateTime.toLocal();
    final difference = DateTime.now().difference(localDt);
    if (difference.inDays > 7) {
      return _formatDateTime(dateTime);
    } else if (difference.inDays >= 1) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
    } else if (difference.inHours >= 1) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
    } else if (difference.inMinutes >= 1) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
    } else {
      return 'Hace unos segundos';
    }
  }

  void _showImagePreviewDialog(PaymentProofModel proof) {
    final proofImageUrl = ValueNotifier<String?>(null);
    _repository.getProofImageUrl(proof.orderId).then((url) {
      proofImageUrl.value = url;
    });

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ValueListenableBuilder<String?>(
          valueListenable: proofImageUrl,
          builder: (context, url, _) {
            if (url == null) {
              return const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            return InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Error al cargar imagen',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(dialogContext),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRejectionDialog(PaymentProofModel proof) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Rechazar Comprobante',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Indica el motivo del rechazo. Este mensaje será notificado al cliente.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Ej. El número de referencia no coincide con el estado de cuenta.',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: GoogleFonts.inter(fontSize: 14),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El motivo de rechazo es requerido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx);
                _reviewProof(
                  proof,
                  PaymentProofStatus.REJECTED,
                  reason: controller.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(80, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Rechazar',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revisión de Comprobantes',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Módulo exclusivo de WashGo',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (!_isLoading)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Center(
                child: Text(
                  _pendingProofs.length == _currentLimit
                      ? '${_pendingProofs.length}+ pendientes'
                      : '${_pendingProofs.length} pendientes',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1D4ED8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : _pendingProofs.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadPendingProofs,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _pendingProofs.length + (_pendingProofs.length == _currentLimit ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _pendingProofs.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    );
                  }
                  return _buildProofCard(_pendingProofs[i]);
                },
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              'Ocurrió un error',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPendingProofs,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Todo al día!',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No hay comprobantes de transferencia pendientes de revisión.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadPendingProofs,
                icon: const Icon(Icons.refresh),
                label: const Text('Refrescar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E293B),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProofCard(PaymentProofModel proof) {
    // Generate filename from image path/url or orderId
    final fileName = proof.imageUrl != null
        ? proof.imageUrl!.split('/').last.split('?').first
        : 'comprobante_${proof.orderId.substring(0, 6)}.jpg';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Local (Business) & Time elapsed
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFF475569),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          proof.businessName ?? 'Local no especificado',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PENDIENTE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        icon: Icons.tag,
                        label: 'ID de Orden',
                        value: '#WASH-${proof.orderId.length > 8 ? proof.orderId.substring(0, 8).toUpperCase() : proof.orderId.toUpperCase()}',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.person_outline,
                        label: 'Cliente',
                        value: proof.clientName ?? 'N/A',
                        subValue: proof.clientPhone != null
                            ? 'Tel: ${proof.clientPhone}'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.local_laundry_service_outlined,
                        label: 'Servicio',
                        value: proof.serviceName ?? 'N/A',
                        subValue: proof.serviceDurationMinutos != null
                            ? 'Duración: ${proof.serviceDurationMinutos} mins'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Fecha Reserva',
                        value: _formatDateTime(proof.scheduledAt),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.access_time_rounded,
                        label: 'Fecha de Envío',
                        value: '${_formatDateTime(proof.createdAt)} (${_formatTimeAgo(proof.createdAt)})',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.attach_money_rounded,
                        label: 'Monto Declarado',
                        value: '\$${proof.amount.toStringAsFixed(2)}',
                        valueColor: const Color(0xFF1E293B),
                        valueFontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Proof Image Preview Column
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showImagePreviewDialog(proof),
                      child: Hero(
                        tag: 'proof_${proof.orderId}',
                        child: Container(
                          width: 90,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            color: const Color(0xFFF1F5F9),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (proof.imageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    proof.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 120,
                                    errorBuilder: (c, e, s) => const Icon(
                                      Icons.broken_image_outlined,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.image_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 28,
                                ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.fullscreen,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 90,
                      child: Text(
                        fileName,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          // Footer Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showRejectionDialog(proof),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Rechazar',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      _reviewProof(proof, PaymentProofStatus.APPROVED),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(80, 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Aprobar',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? subValue,
    Color? valueColor,
    FontWeight? valueFontWeight,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: valueFontWeight ?? FontWeight.w600,
                        color: valueColor ?? const Color(0xFF334155),
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 4),
                    trailing,
                  ],
                ],
              ),
              if (subValue != null) ...[
                const SizedBox(height: 1),
                Text(
                  subValue,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
