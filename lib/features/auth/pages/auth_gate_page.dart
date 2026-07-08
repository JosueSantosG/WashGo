import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/core/session/booking_intent_manager.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  List<UserRole> _userRoles = [];
  bool _isPendingOrRejected = false;
  bool _isRejected = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    setState(() {
      _isPendingOrRejected = false;
    });

    try {
      final user = await _authRepository.getCurrentUser();
      
      if (!mounted) return;

      if (user != null) {
        final roles = user.roles;

        setState(() {
          _userRoles = roles;
        });

        if (roles.isEmpty) {
          context.go('/role-selection');
          return;
        }

        // Si ya hay uno guardado en memoria, lo usamos. Si no, y tiene solo uno, se lo asignamos.
        final activeRole = SessionManager.activeRole ?? (roles.length == 1 ? roles.first : null);

        if (activeRole == null) {
          context.go('/select-active-role');
          return;
        }

        // Guardar en sesión
        SessionManager.activeRole = activeRole;
        
        if (activeRole == UserRole.EMPLEADO) {
          final currentStatus = user.employeeStatus;

          switch (currentStatus) {
            case EmployeeStatus.UNASSIGNED:
              if (user.telefono == null || user.telefono!.trim().isEmpty) {
                context.go(AppRoutes.onboardingEmployee);
              } else {
                context.go(AppRoutes.employeeCode);
              }
              break;
            case EmployeeStatus.PENDING:
              context.go(AppRoutes.employeeDashboard);
              break;
            case EmployeeStatus.REJECTED:
              _showStatusScreen(
                'Tu solicitud para unirte a la lavandería fue rechazada. '
                'Si crees que esto es un error, por favor contacta al dueño o intenta asociarte con otro código.',
                isRejected: true,
              );
              break;
            case EmployeeStatus.ACTIVE:
              context.go(AppRoutes.employeeDashboard);
              break;
          }
        } else if (activeRole == UserRole.ADMINISTRADOR) {
          if (user.currentBusinessId == null) {
            context.go('/create-laundry');
          } else {
            context.go('/owner-dashboard');
          }
        } else {
          // El usuario es CLIENTE o SUPER_ADMIN
          _checkPendingBookingIntentOrGoHome();
        }
      } else {
        // El usuario no existe en la base de datos, necesita seleccionar rol
        context.go('/role-selection');
      }
    } catch (e) {
      debugPrint('Error comprobando el usuario: $e');
      if (mounted) {
        context.go('/role-selection');
      }
    }
  }

  void _checkPendingBookingIntentOrGoHome() {
    final intent = BookingIntentManager.instance.getIntent();
    if (intent == null) {
      context.go('/');
      return;
    }

    // Show a dialog asking if the user wants to continue with the pending booking
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.restore_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Reserva pendiente',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            'Tienes una reserva pendiente en "${intent.laundryName}". ¿Deseas continuar donde la dejaste?',
            style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () {
                BookingIntentManager.instance.clearIntent();
                Navigator.pop(dialogContext);
                if (mounted) context.go('/');
              },
              child: const Text(
                'Empezar de nuevo',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Navigate to home — HomePage will detect the intent and auto-navigate
                // to the booking page once laundries are loaded
                if (mounted) context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStatusScreen(String message, {required bool isRejected}) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
        _isPendingOrRejected = true;
        _isRejected = isRejected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPendingOrRejected) {
      final hasClientRole = _userRoles.contains(UserRole.CLIENTE);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.background,
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _isRejected ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRejected ? Icons.cancel_outlined : Icons.hourglass_empty_rounded,
                        size: 80,
                        color: _isRejected ? AppColors.error : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isRejected ? 'Acceso Rechazado' : 'Solicitud Pendiente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _isRejected ? AppColors.error : AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    color: AppColors.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            _statusMessage ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          if (!_isRejected) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withValues(alpha: 0.8)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Esperando aprobación del dueño...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Action buttons
                  if (hasClientRole) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        SessionManager.activeRole = UserRole.CLIENTE;
                        _checkUserStatus();
                      },
                      icon: const Icon(Icons.directions_car_filled_rounded, color: Colors.white),
                      label: const Text(
                        'Ingresar como Cliente',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_userRoles.length > 1) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        context.go('/select-active-role');
                      },
                      icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
                      label: const Text(
                        'Cambiar de Perfil',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextButton.icon(
                    onPressed: () async {
                      final router = GoRouter.of(context);
                      try {
                        await FirebaseAuth.instance.signOut();
                        SessionManager.activeRole = null;
                        router.go('/role-selection');
                      } catch (e) {
                        debugPrint('Error al cerrar sesión: $e');
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                    label: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.error),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
