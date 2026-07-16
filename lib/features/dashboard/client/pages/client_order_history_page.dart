import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/features/invoices/utils/invoice_cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/features/orders/widgets/review_bottom_sheet.dart';
import 'package:washgo/dataconnect-generated/example.dart' hide PaymentProofStatus;

class ClientOrderHistoryPage extends StatefulWidget {
  const ClientOrderHistoryPage({super.key});

  @override
  State<ClientOrderHistoryPage> createState() => _ClientOrderHistoryPageState();
}

class _ClientOrderHistoryPageState extends State<ClientOrderHistoryPage> {
  final OrderRepository _orderRepository = FirebaseOrderRepository();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Historial de Lavados',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.outline,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Completados'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Cancelados'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _HistoryListTab(
              orderRepository: _orderRepository,
              statuses: const [OrderStatus.COMPLETADO],
              emptyMessage: 'No tienes lavados completados.',
            ),
            _HistoryListTab(
              orderRepository: _orderRepository,
              statuses: const [OrderStatus.CANCELADO],
              emptyMessage: 'No tienes lavados cancelados.',
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryListTab extends StatefulWidget {
  final OrderRepository orderRepository;
  final List<OrderStatus> statuses;
  final String emptyMessage;

  const _HistoryListTab({
    required this.orderRepository,
    required this.statuses,
    required this.emptyMessage,
  });

  @override
  State<_HistoryListTab> createState() => _HistoryListTabState();
}

class _HistoryListTabState extends State<_HistoryListTab> {
  final ScrollController _scrollController = ScrollController();
  final List<ClientOrder> _orders = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadInitialOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (maxScroll - currentScroll <= threshold) {
      _loadMoreOrders();
    }
  }

  Future<void> _loadInitialOrders() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _orders.clear();
      _offset = 0;
      _hasMore = true;
    });

    try {
      final fetched = await widget.orderRepository.getClientHistoryOrdersPaged(
        statuses: widget.statuses,
        limit: _limit,
        offset: 0,
      );

      if (mounted) {
        setState(() {
          _orders.addAll(fetched);
          _isLoading = false;
          _offset = fetched.length;
          _hasMore = fetched.length >= _limit;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreOrders() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final fetched = await widget.orderRepository.getClientHistoryOrdersPaged(
        statuses: widget.statuses,
        limit: _limit,
        offset: _offset,
      );

      if (mounted) {
        setState(() {
          _orders.addAll(fetched);
          _isLoadingMore = false;
          _offset += fetched.length;
          _hasMore = fetched.length >= _limit;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadInitialOrders();
  }

  void _showInvoiceOptions(BuildContext context, String orderId, String pdfUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Opciones de Factura',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Visualice, imprima o comparta su factura oficial.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                ),
                title: Text(
                  'Ver y Descargar Factura',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Abrir en el lector de PDF y guardar offline',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.outline),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                  final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                  await InvoiceCacheManager.printOrViewInvoice(
                    orderId,
                    pdfUrl,
                    baseUrl: baseUrl,
                    idToken: idToken,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share_rounded, color: Colors.green.shade700),
                ),
                title: Text(
                  'Compartir Factura',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Enviar PDF por WhatsApp, correo, etc.',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.outline),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                  final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                  await InvoiceCacheManager.shareInvoice(
                    orderId,
                    pdfUrl,
                    baseUrl: baseUrl,
                    idToken: idToken,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, ClientOrder order) {
    final isCancelled = order.status == 'CANCELADO';
    final isCompleted = order.status == 'COMPLETADO';
    final isEco = order.businessName.toLowerCase().contains('eco');
    final parsed = ParsedObservations.parse(order.observations);
    final vehicle = parsed.vehicleDetails;
    final date = '${parsed.scheduleType} (${parsed.dateTime})';
    final washType = order.serviceName ?? 'Lavado Completo';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isCancelled
                ? Colors.red.shade50
                : (isEco
                    ? Colors.green.shade50
                    : AppColors.primary.withValues(alpha: 0.05)),
            child: Icon(
              isCancelled
                  ? Icons.cancel_rounded
                  : (isEco ? Icons.eco_rounded : Icons.local_car_wash_rounded),
              color: isCancelled
                  ? Colors.red.shade700
                  : (isEco ? Colors.green.shade700 : AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.businessName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '$washType • $vehicle',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCancelled) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Motivo: ${(order.cancellationReason != null && order.cancellationReason!.isNotEmpty) ? order.cancellationReason! : 'Cancelado'}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.price.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCancelled ? 'Cancelado' : 'Completado',
                  style: GoogleFonts.inter(
                    color: isCancelled ? Colors.red.shade700 : Colors.green.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isCompleted && order.invoiceUrl != null && order.invoiceUrl!.isNotEmpty) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showInvoiceOptions(context, order.id, order.invoiceUrl!),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Factura',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (isCompleted && !order.hasReview) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    ReviewBottomSheet.show(
                      context,
                      orderId: order.id,
                      businessId: order.businessId,
                      employeeId: order.employee?.id,
                      businessName: order.businessName,
                      onReviewSubmitted: () => _onRefresh(),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Calificar',
                          style: GoogleFonts.inter(
                            color: Colors.amber.shade800,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.statuses.contains(OrderStatus.CANCELADO)
                      ? Icons.cancel_presentation_rounded
                      : Icons.assignment_turned_in_rounded,
                  size: 64,
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.emptyMessage,
                  style: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: _orders.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _orders.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }

          final order = _orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildHistoryCard(context, order),
          );
        },
      ),
    );
  }
}
