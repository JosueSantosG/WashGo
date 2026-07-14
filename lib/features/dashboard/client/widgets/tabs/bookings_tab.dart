import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/invoices/utils/invoice_cache_manager.dart';
import 'package:washgo/features/orders/widgets/review_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/dashboard/client/widgets/payment_selection_page.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/core/session/booking_intent_manager.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/dataconnect-generated/example.dart' hide PaymentProofStatus;
import 'package:latlong2/latlong.dart';

class BookingsTab extends StatefulWidget {
  final List<ClientOrder> orders;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final Function(BuildContext, String) onShowContactSuccessSnackBar;
  final Function(String) onMakePhoneCall;
  final Function(String) onOpenWhatsApp;
  final VoidCallback onExplorePressed;
  final Function(BuildContext, ClientOrder) onCancelOrder;
  final Function(BuildContext, ClientOrder) onRescheduleOrder;
  final Future<QueuePosition> Function(String businessId, String orderId)? getQueuePosition;

  const BookingsTab({
    super.key,
    required this.orders,
    required this.isLoading,
    required this.onRefresh,
    required this.onShowContactSuccessSnackBar,
    required this.onMakePhoneCall,
    required this.onOpenWhatsApp,
    required this.onExplorePressed,
    required this.onCancelOrder,
    required this.onRescheduleOrder,
    this.getQueuePosition,
  });

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  final Map<String, Future<QueuePosition>> _queueFutures = {};

  @override
  void initState() {
    super.initState();
  }

  DateTime? _parseOrderDateTime(String dtStr) {
    try {
      final parts = dtStr.trim().split(' ');
      if (parts.length != 2) return null;
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 2) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  void _showPaymentSelectionForExistingOrder(BuildContext context, ClientOrder order) {
    final parsed = ParsedObservations.parse(order.observations);
    final serviceType = order.type == 'DELIVERY' ? OrderType.DELIVERY : OrderType.LOCAL;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => PaymentSelectionPage(
          laundry: LaundryItem(
            id: order.businessId,
            name: order.businessName,
            type: '',
            rating: 0.0,
            reviewsCount: 0,
            distance: '',
            distanceInMeters: 0,
            price: order.price,
            location: const LatLng(0, 0),
            isEco: false,
            isOpen: true,
            waitTime: '',
            phone: order.businessPhone ?? '',
          ),
          serviceName: order.serviceName ?? 'Servicio',
          servicePrice: order.price,
          serviceType: serviceType,
          selectedCategory: parsed.vehicleDetails,
          scheduleNow: parsed.scheduleType == 'Ahora mismo',
          scheduledDateTime: _parseOrderDateTime(parsed.dateTime) ?? DateTime.now(),
          serviceDuration: 30,
          onPaymentCompleted: (paymentMethod, {transactionId, phoneNumber}) async {
            final status = (paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA ||
                    paymentMethod == PaymentMethod.PAYPHONE ||
                    paymentMethod == PaymentMethod.PAYPAL)
                ? OrderStatus.PENDIENTE_PAGO
                : OrderStatus.EN_COLA;

            final repository = FirebaseOrderRepository();
            await repository.updateOrderPaymentMethodAndStatus(
              orderId: order.id,
              paymentMethod: paymentMethod,
              status: status,
            );

            if (paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA) {
              BookingIntentManager.instance.savePendingPaymentIntent(
                PendingPaymentIntent(
                  orderId: order.id,
                  paymentMethod: 'TRANSFERENCIA_BANCARIA',
                  amount: order.price,
                  serviceName: order.serviceName ?? 'Servicio',
                  businessName: order.businessName,
                  businessId: order.businessId,
                  createdAt: DateTime.now(),
                ),
              );
            }

            if (paymentMethod == PaymentMethod.PAYPHONE) {
              return order.id;
            }

            if (!routeContext.mounted) return order.id;

            Navigator.pop(routeContext);

            if (paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA) {
              if (context.mounted) {
                context.pushNamed(
                  AppRoutes.proofUpload,
                  extra: {
                    'orderId': order.id,
                    'amount': order.price,
                    'serviceName': order.serviceName ?? 'Servicio',
                    'businessName': order.businessName,
                  },
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Pago completado exitosamente!'),
                  backgroundColor: AppColors.success,
                ),
              );
              widget.onRefresh();
            }

            return order.id;
          },
        ),
      ),
    );
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
                onTap: () {
                  Navigator.pop(context);
                  InvoiceCacheManager.printOrViewInvoice(orderId, pdfUrl);
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
                onTap: () {
                  Navigator.pop(context);
                  InvoiceCacheManager.shareInvoice(orderId, pdfUrl);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant BookingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool ordersChanged = oldWidget.orders.length != widget.orders.length;
    if (!ordersChanged) {
      for (int i = 0; i < widget.orders.length; i++) {
        if (oldWidget.orders[i].id != widget.orders[i].id ||
            oldWidget.orders[i].status != widget.orders[i].status) {
          ordersChanged = true;
          break;
        }
      }
    }
    if (ordersChanged) {
      _queueFutures.clear();
    }
  }

  Future<QueuePosition> _getQueueFuture(String businessId, String orderId) {
    return _queueFutures.putIfAbsent(
      orderId,
      () => widget.getQueuePosition!(businessId, orderId),
    );
  }

  int _getStepFromStatus(String statusStr) {
    switch (statusStr) {
      case 'PENDIENTE_PAGO':
      case 'EN_COLA':
        return 0;
      case 'ACEPTADO':
      case 'EN_CAMINO':
        return 1;
      case 'EN_SERVICIO':
        return 2;
      case 'COMPLETADO':
        return 3;
      default:
        return 0;
    }
  }

  String _getStepStatusTitle(String statusStr) {
    switch (statusStr) {
      case 'PENDIENTE_PAGO':
        return 'Pendiente de Pago';
      case 'EN_COLA':
        return 'En Cola / Solicitado ⏳';
      case 'ACEPTADO':
        return 'Aceptado por empleado 🤝';
      case 'EN_CAMINO':
        return 'Empleado en camino 🚲';
      case 'EN_SERVICIO':
        return 'Lavando tu vehículo 🧼';
      case 'COMPLETADO':
        return 'Entregado / Completado ✅';
      default:
        return 'Procesando tu pedido';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return _buildGuestPlaceholder(context);
    }
    final activeOrders = widget.orders
        .where((order) => order.status != 'COMPLETADO' && order.status != 'CANCELADO')
        .toList();
    final historyOrders = widget.orders
        .where((order) => order.status == 'COMPLETADO' || order.status == 'CANCELADO')
        .toList();
    final pendingReviewOrders = widget.orders
        .where((order) => order.status == 'COMPLETADO' && !order.hasReview)
        .toList();

    return SafeArea(
      key: const ValueKey('bookings_section'),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _queueFutures.clear();
          });
          await widget.onRefresh();
        },
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis Reservas',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sigue el estado de tus lavados activos y revisa tu historial.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (pendingReviewOrders.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 24),
                sliver: SliverToBoxAdapter(
                  child: _buildPendingReviewsCard(context, pendingReviewOrders),
                ),
              ),

            // Section: Active Orders
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'RESERVAS ACTIVAS',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (widget.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (activeOrders.isEmpty)
                      _buildEmptyActiveState()
                    else
                      ...activeOrders.map(
                        (order) => _buildActiveOrderCard(context, order),
                      ),
                  ],
                ),
              ),
            ),

            // Section: History
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HISTORIAL DE LAVADOS',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.outline,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (widget.isLoading && widget.orders.isEmpty)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    else if (historyOrders.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'No tienes lavados anteriores completados.',
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      ...historyOrders.map((order) {
                        final parsed = ParsedObservations.parse(
                          order.observations,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildHistoryCard(
                            order: order,
                            washType: order.serviceName ?? 'Lavado Completo',
                            vehicle: parsed.vehicleDetails,
                            date: '${parsed.scheduleType} (${parsed.dateTime})',
                            isEco: order.businessName.toLowerCase().contains(
                              'eco',
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyActiveState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_car_wash_rounded,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin Reservas Activas',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¿Tu auto necesita un lavado? Reserva un turno en segundos.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: widget.onExplorePressed,
            icon: const Icon(Icons.explore_rounded, size: 18),
            label: const Text('Explorar Lavanderías'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard(
    BuildContext context,
    ClientOrder order,
  ) {
    final statusStr = order.status;
    final step = _getStepFromStatus(statusStr);
    final displayId = order.id.length > 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();
    final parsed = ParsedObservations.parse(order.observations);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  Icons.local_car_wash_rounded,
                  color: AppColors.primary,
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
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '${order.serviceName ?? "Lavado Completo"} • ${parsed.vehicleDetails}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),

          // Order ID and instructions (Estado del Pedido style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID de orden:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '#WASH-$displayId',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Muestra este código al llegar al establecimiento para iniciar tu servicio inmediatamente.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Estado de comprobante de pago (Transferencia Bancaria)
          if (order.paymentMethod == 'TRANSFERENCIA_BANCARIA' &&
              statusStr == 'PENDIENTE_PAGO') ...[
            FutureBuilder<PaymentProofModel?>(
              future: BankTransferRepository().getProofStatus(order.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Verificando estado del pago...',
                          style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }

                final proof = snapshot.data;
                if (proof == null) {
                  // No se ha subido comprobante aún
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () async {
                          final result = await context.pushNamed(
                            AppRoutes.proofUpload,
                            extra: {
                              'orderId': order.id,
                              'amount': order.price.toDouble(),
                              'serviceName': order.serviceName ?? "Lavado Completo",
                              'businessName': order.businessName,
                            },
                          );
                          if (result != null && context.mounted) {
                            await context.pushNamed(
                              AppRoutes.proofStatus,
                              extra: {
                                'orderId': order.id,
                                'proofStatus': 'PENDIENTE',
                                'amount': order.price.toDouble(),
                                'serviceName': order.serviceName ?? "Lavado Completo",
                                'businessName': order.businessName,
                              },
                            );
                          }
                          if (context.mounted) {
                            widget.onRefresh();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: Colors.blue.shade700, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Pendiente de comprobante — Sube tu comprobante de pago para que el dueño lo revise.',
                                  style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right_rounded, color: Colors.blue.shade700, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                IconData icon;
                MaterialColor color;
                String message;

                switch (proof.status) {
                  case PaymentProofStatus.PENDING:
                    icon = Icons.access_time_rounded;
                    color = Colors.amber;
                    message = 'Comprobante recibido. El dueño lo está revisando...';
                  case PaymentProofStatus.APPROVED:
                    icon = Icons.check_circle_rounded;
                    color = Colors.green;
                    message = 'Pago verificado correctamente.';
                  case PaymentProofStatus.REJECTED:
                    icon = Icons.cancel_rounded;
                    color = Colors.red;
                    message = proof.rejectionReason != null
                        ? 'Comprobante rechazado: ${proof.rejectionReason}'
                        : 'Comprobante rechazado. Sube uno nuevo.';
                }

                // If proof is rejected, clicking it should allow re-uploading a new proof.
                // If it is pending or approved, they click to view the status details.
                final bool isRejected = proof.status == PaymentProofStatus.REJECTED;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () async {
                        if (isRejected) {
                          final result = await context.pushNamed(
                            AppRoutes.proofUpload,
                            extra: {
                              'orderId': order.id,
                              'amount': order.price.toDouble(),
                              'serviceName': order.serviceName ?? "Lavado Completo",
                              'businessName': order.businessName,
                            },
                          );
                          if (result != null && context.mounted) {
                            await context.pushNamed(
                              AppRoutes.proofStatus,
                              extra: {
                                'orderId': order.id,
                                'proofStatus': 'PENDIENTE',
                                'amount': order.price.toDouble(),
                                'serviceName': order.serviceName ?? "Lavado Completo",
                                'businessName': order.businessName,
                              },
                            );
                          }
                        } else {
                          await context.pushNamed(
                            AppRoutes.proofStatus,
                            extra: {
                              'orderId': order.id,
                              'proofStatus': proof.status.name,
                              'amount': order.price.toDouble(),
                              'serviceName': order.serviceName ?? "Lavado Completo",
                              'businessName': order.businessName,
                            },
                          );
                        }
                        if (context.mounted) {
                          widget.onRefresh();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: color.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, color: color.shade700, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                message,
                                style: TextStyle(fontSize: 13, color: color.shade900, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right_rounded, color: color.shade700, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          // Advertencia de expiración de pago para PayPhone/PayPal
          if (statusStr == 'PENDIENTE_PAGO' &&
              (order.paymentMethod == 'PAYPHONE' || order.paymentMethod == 'PAYPAL') &&
              order.createdAt != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago pendiente',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Completa el pago dentro de los 30 minutos de la reserva o será cancelada.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        PaymentCountdownText(
                          createdAt: order.createdAt!,
                          onExpired: () {
                            widget.onRefresh();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Fecha y Hora de la Reserva
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cita: ${parsed.scheduleType} (${parsed.dateTime})',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dynamic Turn & Wait Time in Real-Time
          if ((statusStr == 'EN_COLA' || statusStr == 'PENDIENTE_PAGO') &&
              widget.getQueuePosition != null) ...[
            const SizedBox(height: 12),
            FutureBuilder<QueuePosition>(
              future: _getQueueFuture(order.businessId, order.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Calculando tiempo de espera...',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final queueData = snapshot.data!;
                final pos = queueData.position;
                final estTime = queueData.estimatedWaitTime;

                if (pos == -1) {
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tu Turno en Cola:',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#$pos',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.hourglass_empty_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tiempo Estimado:',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            pos == 1 ? 'Inmediato' : '~$estTime minutos',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pos == 1
                            ? '¡Eres el siguiente en la cola! El personal iniciará tu lavado muy pronto.'
                            : 'Hay ${pos - 1} vehículo(s) antes que tú. El tiempo de espera es dinámico y depende de la rapidez del personal.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 20),

          // Stepper status
          _buildStatusStepper(step: step, statusStr: statusStr, order: order),

          if (order.businessPhone != null && order.businessPhone!.isNotEmpty) ...[
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.store_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contacto del Local',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.businessName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.businessPhone!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => widget.onMakePhoneCall(order.businessPhone!),
                        icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                        tooltip: 'Llamar al local',
                      ),
                      IconButton(
                        onPressed: () => widget.onOpenWhatsApp(order.businessPhone!),
                        icon: const Icon(Icons.message_rounded, color: AppColors.primary),
                        tooltip: 'WhatsApp al local',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Employee Assignment Info
          if (order.employee != null) ...[
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: order.employee!.fotoPerfil != null &&
                            order.employee!.fotoPerfil!.isNotEmpty
                        ? CachedNetworkImageProvider(order.employee!.fotoPerfil!)
                        : null,
                    backgroundColor: Colors.green.shade200,
                    child: order.employee!.fotoPerfil == null ||
                            order.employee!.fotoPerfil!.isEmpty
                        ? const Icon(Icons.person, color: Colors.green)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.employee!.nombreCompleto,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Personal verificado',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_actions_rounded,
                    color: Colors.orange.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Diríjase al local y presente su orden para que un empleado pueda iniciar el servicio.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (statusStr == 'PENDIENTE_PAGO' ||
              statusStr == 'EN_COLA' ||
              statusStr == 'ACEPTADO') ...[
            const Divider(height: 32),
            Row(
              children: [
                if (statusStr == 'PENDIENTE_PAGO' || statusStr == 'EN_COLA') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.onCancelOrder(context, order),
                      icon: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 18),
                      label: const Text('Cancelar Reserva'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onRescheduleOrder(context, order),
                    icon: const Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 18),
                    label: const Text('Postergar Cita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Botón Pagar ahora para PayPhone y PayPal
          if (statusStr == 'PENDIENTE_PAGO' &&
              (order.paymentMethod == 'PAYPHONE' || order.paymentMethod == 'PAYPAL')) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showPaymentSelectionForExistingOrder(context, order),
                icon: const Icon(Icons.payment_rounded, color: Colors.white, size: 18),
                label: const Text('Pagar ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],

          // Botón alternativo de pago en línea para transferencia bancaria (si no hay comprobante subido o fue rechazado)
          if (statusStr == 'PENDIENTE_PAGO' && order.paymentMethod == 'TRANSFERENCIA_BANCARIA') ...[
            FutureBuilder<PaymentProofModel?>(
              future: BankTransferRepository().getProofStatus(order.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                final proof = snapshot.data;
                if (proof == null || proof.status == PaymentProofStatus.REJECTED) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showPaymentSelectionForExistingOrder(context, order),
                        icon: const Icon(Icons.payment_rounded, color: AppColors.primary, size: 18),
                        label: const Text('Pagar con otros medios'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],

          // Bank transfer action button
          if (order.paymentMethod == 'TRANSFERENCIA_BANCARIA' &&
              statusStr == 'PENDIENTE_PAGO') ...[
            const SizedBox(height: 12),
            FutureBuilder<PaymentProofModel?>(
              future: BankTransferRepository().getProofStatus(order.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                final proof = snapshot.data;
                if (proof == null || proof.status == PaymentProofStatus.REJECTED) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await context.pushNamed(
                          AppRoutes.proofUpload,
                          extra: {
                            'orderId': order.id,
                            'amount': order.price.toDouble(),
                            'serviceName': order.serviceName ?? 'Servicio',
                            'businessName': order.businessName,
                          },
                        );
                        if (result != null && context.mounted) {
                          await context.pushNamed(
                            AppRoutes.proofStatus,
                            extra: {
                              'orderId': order.id,
                              'proofStatus': 'PENDIENTE',
                              'amount': order.price.toDouble(),
                              'serviceName': order.serviceName ?? 'Servicio',
                              'businessName': order.businessName,
                            },
                          );
                        }
                        if (context.mounted) {
                          widget.onRefresh();
                        }
                      },
                      icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 18),
                      label: Text(proof == null ? 'Subir Comprobante' : 'Subir nuevo comprobante'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                } else if (proof.status == PaymentProofStatus.PENDING) {
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await context.pushNamed(
                          AppRoutes.proofStatus,
                          extra: {
                            'orderId': order.id,
                            'proofStatus': 'PENDING',
                            'amount': order.price.toDouble(),
                            'serviceName': order.serviceName ?? 'Servicio',
                            'businessName': order.businessName,
                          },
                        );
                        if (context.mounted) {
                          widget.onRefresh();
                        }
                      },
                      icon: const Icon(Icons.visibility_outlined, color: AppColors.primary, size: 18),
                      label: const Text('Ver Estado de Pago'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],

        ],
      ),
    );
  }

  Widget _buildStatusStepper({
    required int step,
    required String statusStr,
    required ClientOrder order,
  }) {
    final steps = ['En cola', 'Aceptado', 'En servicio', 'Completado'];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Estado: ${_getStepStatusTitle(statusStr)}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            if (statusStr != 'COMPLETADO')
              if ((statusStr == 'EN_COLA' || statusStr == 'PENDIENTE_PAGO') &&
                  widget.getQueuePosition != null)
                FutureBuilder<QueuePosition>(
                  future: _getQueueFuture(order.businessId, order.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final queueData = snapshot.data!;
                    final pos = queueData.position;
                    final estTime = queueData.estimatedWaitTime;
                    if (pos <= 0) return const SizedBox.shrink();
                    return Text(
                      pos == 1 ? 'Siguiente en cola' : 'Espera: ~$estTime min',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    );
                  },
                )
              else
                Text(
                  statusStr == 'EN_SERVICIO'
                      ? '15 Minutos left'
                      : '30 Minutos left',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(4, (index) {
            final isCompleted = index < step;
            final isActive = index == step;
            final isLast = index == 3;

            return Expanded(
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : isActive
                          ? Colors.white
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted || isActive
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        width: isActive ? 5 : 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: isCompleted
                            ? AppColors.primary
                            : Colors.grey.shade200,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            final isActive = index == step;
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.outline,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPendingReviewsCard(BuildContext context, List<ClientOrder> orders) {
    final order = orders.first;
    final otherCount = orders.length - 1;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.amber.shade50.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade900.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rate_review_rounded,
                  color: Colors.amber.shade800,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calificación Pendiente',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                    if (otherCount > 0)
                      Text(
                        'Tienes ${orders.length} servicios sin calificar',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '¿Cómo estuvo tu servicio en ${order.businessName}?',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ayúdanos a mejorar calificando tu lavado del ${order.serviceName ?? "Servicio"}.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final starVal = index + 1;
                  return GestureDetector(
                    onTap: () {
                      ReviewBottomSheet.show(
                        context,
                        orderId: order.id,
                        businessId: order.businessId,
                        employeeId: order.employee?.id,
                        businessName: order.businessName,
                        initialRating: starVal,
                        onReviewSubmitted: () => widget.onRefresh(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.star_outline_rounded,
                        color: Colors.amber.shade600,
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ReviewBottomSheet.show(
                    context,
                    orderId: order.id,
                    businessId: order.businessId,
                    employeeId: order.employee?.id,
                    businessName: order.businessName,
                    onReviewSubmitted: () => widget.onRefresh(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Calificar',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required ClientOrder order,
    required String washType,
    required String vehicle,
    required String date,
    required bool isEco,
  }) {
    final isCancelled = order.status == 'CANCELADO';
    final isCompleted = order.status == 'COMPLETADO';
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
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                      onReviewSubmitted: () => widget.onRefresh(),
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
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuestPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tus Reservas',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Inicia sesión para ver tu historial de reservas y hacer un seguimiento en tiempo real de tus lavados activos.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Iniciar Sesión',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCountdownText extends StatefulWidget {
  final DateTime createdAt;
  final VoidCallback onExpired;

  const PaymentCountdownText({
    super.key,
    required this.createdAt,
    required this.onExpired,
  });

  @override
  State<PaymentCountdownText> createState() => _PaymentCountdownTextState();
}

class _PaymentCountdownTextState extends State<PaymentCountdownText> {
  Timer? _timer;
  int _remainingMinutes = 30;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _calculateRemainingTime();
      }
    });
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.createdAt);
    final remaining = 30 - difference.inMinutes;
    if (remaining <= 0) {
      _timer?.cancel();
      widget.onExpired();
    } else {
      setState(() {
        _remainingMinutes = remaining;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tiempo restante: $_remainingMinutes ${_remainingMinutes == 1 ? 'minuto' : 'minutos'}',
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.error,
      ),
    );
  }
}
