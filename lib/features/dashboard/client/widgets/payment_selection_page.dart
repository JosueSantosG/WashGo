import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/core/services/paypal_service.dart';
import 'package:washgo/core/services/payphone_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/env/environment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class PaymentSelectionPage extends StatefulWidget {
  final LaundryItem laundry;
  final String serviceName;
  final double servicePrice;
  final OrderType serviceType;
  final String selectedCategory;
  final bool scheduleNow;
  final DateTime? scheduledDateTime;
  final int serviceDuration;
  final Future<String?> Function(PaymentMethod, {String? transactionId, String? phoneNumber}) onPaymentCompleted;

  const PaymentSelectionPage({
    super.key,
    required this.laundry,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceType,
    required this.selectedCategory,
    required this.scheduleNow,
    this.scheduledDateTime,
    required this.onPaymentCompleted,
    required this.serviceDuration,
  });

  @override
  State<PaymentSelectionPage> createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {
  PaymentMethod _selectedMethod = PaymentMethod.PAYPHONE;
  bool _preferPaypalCard = false;
  bool _isProcessing = false;
  bool _payphoneWaiting = false;
  String? _payphoneOrderId;
  String? _payphonePaymentUrl;

  @override
  Widget build(BuildContext context) {
    if (_payphoneWaiting) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEDD5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF6C00),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Esperando tu pago...',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF6C00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hemos abierto la pasarela de pago de PayPhone en tu navegador web. Por favor, completa la transacción allí.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Si el navegador no se abrió o lo cerraste por accidente, puedes presionar "Reabrir enlace" abajo.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  try {
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                      throw Exception('Usuario no autenticado.');
                                    }
                                    final idToken = await user.getIdToken(true);
                                    if (idToken == null) {
                                      throw Exception('No se pudo obtener token de autenticación.');
                                    }
                                    final baseUrl = _getFunctionsBaseUrl();
                                    final orderId = _payphoneOrderId!;

                                    // 1. Try fetching stored transactionId from Firestore bridge
                                    String? transactionId;
                                    try {
                                      transactionId = await PayphoneService.getStoredTransaction(
                                        orderId: orderId,
                                        baseUrl: baseUrl,
                                        idToken: idToken,
                                      );
                                    } catch (_) {
                                      // Fall through to Data Connect check
                                    }

                                    // 2. If in emulator and no transaction found, generate mock
                                    if (transactionId == null && Environment.useEmulators) {
                                      transactionId = 'mock-${DateTime.now().millisecondsSinceEpoch}';
                                    }

                                    // 3. If we have a transactionId, verify with PayPhone first
                                    if (transactionId != null && transactionId.isNotEmpty) {
                                      try {
                                        final verification = await PayphoneService.verifyTransaction(
                                          transactionId: transactionId,
                                          orderId: orderId,
                                          idToken: idToken,
                                          baseUrl: baseUrl,
                                        );
                                        if (verification['verified'] == true) {
                                          if (!context.mounted) return;
                                          await context.push(
                                            '/payphone-callback/success'
                                            '?transactionId=$transactionId'
                                            '&orderId=$orderId',
                                          );
                                          return;
                                        }
                                        // PayPhone says not approved — show message, don't navigate
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'PayPhone no ha confirmado el pago. Estado: ${verification['status'] ?? 'Desconocido'}. Si ya pagaste, espera unos segundos e intenta de nuevo.',
                                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                            ),
                                            backgroundColor: Colors.orange.shade800,
                                          ),
                                        );
                                        return;
                                      } catch (_) {
                                        // If verify endpoint fails (e.g. auth issue), fall through to original behavior
                                        // so the user isn't locked out
                                      }
                                    }

                                    // 4. Fallback: check Data Connect order status
                                    final connector = ExampleConnector.instance;
                                    final orderResult = await connector
                                        .getOrderById(id: orderId)
                                        .execute();
                                    final order = orderResult.data.order;
                                    if (order == null) {
                                      throw Exception('No se encontró el pedido.');
                                    }
                                    if (order.status.stringValue == 'COMPLETADO') {
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '¡Pago verificado y reserva confirmada!',
                                            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.green.shade600,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'El pago aún no ha sido reportado como completado. Completa el pago en el navegador.',
                                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                          ),
                                          backgroundColor: Colors.orange.shade800,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al verificar: $e'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6C00),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Ya pagué – Verificar',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_payphonePaymentUrl != null) {
                              final uri = Uri.parse(_payphonePaymentUrl!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            foregroundColor: const Color(0xFF1E293B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reabrir enlace de pago',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  try {
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      final idToken = await user.getIdToken(true);
                                      if (idToken != null) {
                                        await PayphoneService.cancelPendingOrder(
                                          orderId: _payphoneOrderId!,
                                          idToken: idToken,
                                          baseUrl: _getFunctionsBaseUrl(),
                                        );
                                      }
                                    }
                                    setState(() {
                                      _payphoneWaiting = false;
                                      _payphoneOrderId = null;
                                      _payphonePaymentUrl = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Orden de pago cancelada.',
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al cancelar: $e'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red.shade200),
                            foregroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancelar pago y orden',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final isDelivery = widget.serviceType == OrderType.DELIVERY;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Selección de Pago',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title: Resumen de Servicio
                    Text(
                      'Resumen del servicio',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Resumen Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDelivery
                                      ? const Color(0xFFECFDF5)
                                      : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isDelivery ? 'A Domicilio' : 'En Local',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDelivery
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                              Text(
                                '\$${widget.servicePrice.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.serviceName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.storefront_rounded,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.laundry.name,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.scheduleNow
                                      ? (_selectedMethod == PaymentMethod.CASH
                                          ? 'Cola Dinámica (Ahora mismo) • Tiempo de lavado: ${widget.serviceDuration} min'
                                          : 'Ahora mismo • Tiempo de lavado: ${widget.serviceDuration} min')
                                      : 'Programado: ${widget.scheduledDateTime!.day.toString().padLeft(2, '0')}/${widget.scheduledDateTime!.month.toString().padLeft(2, '0')}/${widget.scheduledDateTime!.year} ${widget.scheduledDateTime!.hour.toString().padLeft(2, '0')}:${widget.scheduledDateTime!.minute.toString().padLeft(2, '0')} • Tiempo de lavado: ${widget.serviceDuration} min',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (widget.selectedCategory.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.directions_car_rounded,
                                  size: 16,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Vehículo: ${widget.selectedCategory}',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section Title: Métodos de Pago
                    Text(
                      'Selecciona tu método de pago',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // PayPal Option Card
                    _buildPaymentOptionCard(
                      isSelected: _selectedMethod == PaymentMethod.PAYPAL && !_preferPaypalCard,
                      title: 'Cuenta PayPal',
                      subtitle: 'Pagar con tu saldo o cuenta de PayPal',
                      icon: Icons.paypal,
                      iconColor: const Color(0xFF003087),
                      bgColor: const Color(0xFFF0F4F9),
                      onTap: () {
                        setState(() {
                          _selectedMethod = PaymentMethod.PAYPAL;
                          _preferPaypalCard = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Card Option Card
                    _buildPaymentOptionCard(
                      isSelected: _selectedMethod == PaymentMethod.PAYPAL && _preferPaypalCard,
                      title: 'Tarjeta de Crédito o Débito',
                      subtitle: 'Paga de forma directa con tarjeta vía PayPal',
                      icon: Icons.credit_card_rounded,
                      iconColor: const Color(0xFF1E293B),
                      bgColor: const Color(0xFFF1F5F9),
                      onTap: () {
                        setState(() {
                          _selectedMethod = PaymentMethod.PAYPAL;
                          _preferPaypalCard = true;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    /*
                    // Cash Option Card
                    _buildPaymentOptionCard(
                      isSelected: _selectedMethod == PaymentMethod.CASH,
                      title: 'Pago en Sitio',
                      subtitle:
                          'Pagar al llegar al local (Espera en fila normal)',
                      icon: Icons.payments_rounded,
                      iconColor: const Color(0xFF10B981),
                      bgColor: const Color(0xFFECFDF5),
                      onTap: () {
                        setState(() {
                          _selectedMethod = PaymentMethod.CASH;
                          _preferPaypalCard = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    */

                    // Bank Transfer Option Card
                    _buildPaymentOptionCard(
                      isSelected: _selectedMethod == PaymentMethod.TRANSFERENCIA_BANCARIA,
                      title: 'Transferencia Bancaria',
                      subtitle: 'Paga mediante transferencia directa',
                      icon: Icons.account_balance_rounded,
                      iconColor: AppColors.primary,
                      bgColor: AppColors.primary.withValues(alpha: 0.08),
                      onTap: () {
                        setState(() {
                          _selectedMethod = PaymentMethod.TRANSFERENCIA_BANCARIA;
                          _preferPaypalCard = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // PayPhone Option Card
                    _buildPaymentOptionCard(
                      isSelected: _selectedMethod == PaymentMethod.PAYPHONE,
                      title: 'PayPhone',
                      subtitle: 'Pago con tarjeta de crédito/débito o saldo PayPhone',
                      icon: Icons.phone_android_rounded,
                      iconColor: const Color(0xFFFF6C00),
                      bgColor: const Color(0xFFFF6C00).withValues(alpha: 0.08),
                      isDisabled: false,
                      onTap: () {
                        setState(() {
                          _selectedMethod = PaymentMethod.PAYPHONE;
                          _preferPaypalCard = false;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    /*
                    // Disclaimer text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFFD97706),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Para servicios a domicilio, requerimos el pago adelantado para confirmar el traslado del especialista y garantizar tu turno.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ),

            // Bottom Sticky Button Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () async {
                          setState(() {
                            _isProcessing = true;
                          });
                          try {
                            if (_selectedMethod == PaymentMethod.PAYPAL) {
                              final paypalService = PaypalService();
                              final paypalResult = await paypalService.startPaymentFlow(
                                context: context,
                                amount: widget.servicePrice,
                                serviceName: widget.serviceName,
                                businessName: widget.laundry.name,
                                preferCard: _preferPaypalCard,
                              );
                              
                              if (!paypalResult.isSuccess) {
                                throw Exception(paypalResult.errorMessage ?? 'Pago con PayPal no completado.');
                              }
                              await widget.onPaymentCompleted(_selectedMethod);
                            } else if (_selectedMethod == PaymentMethod.PAYPHONE) {
                              // 1. Create the order as PENDIENTE_PAGO using the callback
                              final orderId = await widget.onPaymentCompleted(_selectedMethod);
                              if (orderId == null || orderId.isEmpty) {
                                throw Exception('No se pudo crear el pedido.');
                              }
                              
                              // 2. Fetch the ID token for backend API authentication (force refresh to avoid stale tokens)
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                throw Exception('Usuario no autenticado.');
                              }
                              final idToken = await user.getIdToken(true);
                              if (idToken == null) {
                                throw Exception('No se pudo obtener el token de autenticación.');
                              }

                              // 3. Prepare the payment URL from backend
                              final payWithCardUrl = await PayphoneService.preparePayment(
                                orderId: orderId,
                                idToken: idToken,
                                baseUrl: _getFunctionsBaseUrl(),
                              );
                              
                              // 4. Open url in browser (or navigate internally if mock/local redirect)
                              if (payWithCardUrl.contains('/payphone-callback/success') || payWithCardUrl.contains('/payphone-callback/cancel')) {
                                final uri = Uri.parse(payWithCardUrl);
                                final transactionId = uri.queryParameters['id'] ?? uri.queryParameters['transactionId'];
                                final clientTxId = uri.queryParameters['clientTransactionId'] ?? uri.queryParameters['orderId'];
                                final isSuccess = payWithCardUrl.contains('/payphone-callback/success');

                                if (context.mounted) {
                                  if (isSuccess) {
                                    context.push('/payphone-callback/success?id=$transactionId&clientTransactionId=$clientTxId');
                                  } else {
                                    context.push('/payphone-callback/cancel?clientTransactionId=$clientTxId');
                                  }
                                }
                                setState(() {
                                  _isProcessing = false;
                                });
                              } else {
                                final uri = Uri.parse(payWithCardUrl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } else {
                                  throw Exception('No se pudo abrir el enlace de pago: $payWithCardUrl');
                                }

                                // 5. Transition to waiting state
                                setState(() {
                                  _payphoneWaiting = true;
                                  _payphoneOrderId = orderId;
                                  _payphonePaymentUrl = payWithCardUrl;
                                  _isProcessing = false;
                                });
                              }
                            } else {
                              await widget.onPaymentCompleted(_selectedMethod);
                            }
                          } catch (e) {
                            setState(() {
                              _isProcessing = false;
                            });
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al procesar el pago: $e'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMethod == PaymentMethod.PAYPAL
                        ? const Color(0xFF0070BA)
                        : _selectedMethod == PaymentMethod.PAYPHONE
                            ? const Color(0xFFFF6C00)
                            : _selectedMethod == PaymentMethod.TRANSFERENCIA_BANCARIA
                                ? AppColors.primary
                                : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _selectedMethod == PaymentMethod.PAYPAL
                              ? (_preferPaypalCard ? 'Pagar con Tarjeta' : 'Pagar con PayPal')
                              : _selectedMethod == PaymentMethod.PAYPHONE
                                  ? 'Pagar con PayPhone'
                                  : _selectedMethod == PaymentMethod.TRANSFERENCIA_BANCARIA
                                      ? 'Pagar con Transferencia Bancaria'
                                      : 'Confirmar Reserva',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required bool isSelected,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDisabled ? Colors.grey.shade200 : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey.shade500 : const Color(0xFF1E293B),
                        ),
                      ),
                      if (isDisabled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Próximamente',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFC2410C),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDisabled ? Colors.grey.shade400 : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isDisabled)
              Icon(
                Icons.lock_outline_rounded,
                color: Colors.grey.shade300,
                size: 22,
              )
            else
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                size: 22,
              ),
          ],
        ),
      ),
    );
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
}

