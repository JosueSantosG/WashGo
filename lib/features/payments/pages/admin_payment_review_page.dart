import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

class AdminPaymentReviewPage extends StatefulWidget {
  final String businessId;

  const AdminPaymentReviewPage({super.key, required this.businessId});

  @override
  State<AdminPaymentReviewPage> createState() => _AdminPaymentReviewPageState();
}

class _AdminPaymentReviewPageState extends State<AdminPaymentReviewPage> {
  final BankTransferRepository _repository = BankTransferRepository();
  List<GetPendingTransferOrdersOrders> _pendingOrders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingOrders();
  }

  Future<void> _loadPendingOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ExampleConnector.instance
          .getPendingTransferOrders(businessId: widget.businessId)
          .execute();

      if (mounted) {
        setState(() {
          _pendingOrders = result.data.orders;
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

  Future<void> _approveOrder(String orderId) async {
    try {
      await ExampleConnector.instance
          .updateOrderStatus(orderId: orderId, status: OrderStatus.COMPLETADO)
          .execute();
      await _loadPendingOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pago aprobado correctamente'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al aprobar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _rejectOrder(String orderId, {String? reason}) async {
    try {
      await ExampleConnector.instance
          .updateOrderStatus(orderId: orderId, status: OrderStatus.CANCELADO)
          .execute();
      await _loadPendingOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reason != null && reason.isNotEmpty
              ? 'Pago rechazado: $reason'
              : 'Pago rechazado'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al rechazar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showReviewDialog(GetPendingTransferOrdersOrders order) {
    final proofImageUrl = ValueNotifier<String?>(null);
    _repository.getProofImageUrl(order.id).then((url) {
      proofImageUrl.value = url;
    });

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Revisar pago',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Cliente', order.client.nombreCompleto),
              const SizedBox(height: 8),
              _buildDetailRow('Email', order.client.email),
              if (order.client.telefono != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Teléfono', order.client.telefono!),
              ],
              const SizedBox(height: 8),
              _buildDetailRow('Servicio', order.serviceName ?? '—'),
              const SizedBox(height: 8),
              _buildDetailRow(
                  'Monto', '\$${order.price.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildDetailRow('Orden', order.id.substring(0, 8).toUpperCase()),
              if (order.observations != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Observaciones', order.observations!),
              ],
              const SizedBox(height: 12),
              ValueListenableBuilder<String?>(
                valueListenable: proofImageUrl,
                builder: (context, url, _) {
                  if (url == null) {
                    return Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
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
              _showRejectionDialog(order);
            },
            child: const Text('Rechazar',
                style: TextStyle(color: AppColors.error)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _approveOrder(order.id);
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

  void _showRejectionDialog(GetPendingTransferOrdersOrders order) {
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
              _rejectOrder(order.id, reason: controller.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(value,
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
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
              ? _buildErrorView()
              : _pendingOrders.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadPendingOrders,
                      child: ListView.builder(
                        itemCount: _pendingOrders.length,
                        itemBuilder: (context, i) =>
                            _buildOrderCard(_pendingOrders[i]),
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
              'Error al cargar pagos pendientes',
              style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPendingOrders,
              child: const Text('Reintentar'),
            ),
          ],
        ),
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

  Widget _buildOrderCard(GetPendingTransferOrdersOrders order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFEF3C7),
          child: const Icon(Icons.access_time_rounded,
              color: Color(0xFFD97706), size: 20),
        ),
        title: Text(
          order.client.nombreCompleto,
          style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '\$${order.price.toStringAsFixed(2)} · ${order.serviceName ?? "Servicio"}',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              'Orden: ${order.id.substring(0, 8).toUpperCase()}',
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        isThreeLine: true,
        onTap: () => _showReviewDialog(order),
      ),
    );
  }
}
