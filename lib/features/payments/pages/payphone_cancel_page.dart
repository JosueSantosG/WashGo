import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/env/environment.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/services/payphone_service.dart';

class PayphoneCancelPage extends StatefulWidget {
  final String? orderId;

  const PayphoneCancelPage({
    super.key,
    this.orderId,
  });

  @override
  State<PayphoneCancelPage> createState() => _PayphoneCancelPageState();
}

class _PayphoneCancelPageState extends State<PayphoneCancelPage> {
  bool _isCancelling = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null && widget.orderId!.isNotEmpty) {
      _cancelOrder(widget.orderId!);
    }
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

  Future<void> _cancelOrder(String orderId) async {
    setState(() {
      _isCancelling = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado.');
      }
      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw Exception('No se pudo obtener el token de autenticación.');
      }

      await PayphoneService.cancelPendingOrder(
        orderId: orderId,
        idToken: idToken,
        baseUrl: _getFunctionsBaseUrl(),
      );
    } catch (e) {
      debugPrint('Error al cancelar orden pendiente: $e');
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF7ED),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isCancelling
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF6C00),
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.cancel_rounded,
                            color: Color(0xFFFF6C00),
                            size: 44,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _isCancelling ? 'Cancelando Reserva...' : 'Pago Cancelado',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6C00),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _isCancelling
                      ? 'Estamos procesando la cancelación de tu reserva pendiente de pago. Por favor espera.'
                      : 'Has cancelado la transacción en PayPhone. No se ha realizado ningún cobro en tu cuenta y la reserva pendiente de pago ha sido cancelada.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.orderId != null && widget.orderId!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Pedido ID: ${widget.orderId}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Nota: No pudimos actualizar la cancelación en el servidor inmediatamente, pero se cancelará automáticamente en unos minutos.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.error,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 36),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isCancelling ? null : () => context.go('/'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6C00),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Intentar de nuevo',
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
                        onPressed: _isCancelling ? null : () => context.go('/'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          foregroundColor: AppColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ir al Inicio',
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
}
