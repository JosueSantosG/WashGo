import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/shared/widgets/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/core/session/booking_intent_manager.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/pages/proof_status_page.dart';
import 'package:washgo/features/auth/models/registration_draft.dart';

class ClientOnboardingPage extends StatefulWidget {
  const ClientOnboardingPage({super.key});

  @override
  State<ClientOnboardingPage> createState() => _ClientOnboardingPageState();
}

class _ClientOnboardingPageState extends State<ClientOnboardingPage> {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _photoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _nameController.text = user.displayName!;
      }
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        _photoUrl = user.photoURL;
      }
    } else {
      if (RegistrationDraft.name.isNotEmpty) {
        _nameController.text = RegistrationDraft.name;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _finalizar() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu nombre completo.')),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu teléfono de contacto.')),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El teléfono de contacto debe tener exactamente 10 dígitos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        final email = RegistrationDraft.email;
        final password = RegistrationDraft.password;
        if (email.isEmpty || password.isEmpty) {
          throw Exception('Faltan datos de registro del paso anterior.');
        }

        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        user = credential.user;

        if (user != null) {
          await user.updateDisplayName(name);
          if (_photoUrl != null) {
            await user.updateProfile(photoURL: _photoUrl);
          }

          await _authRepository.upsertUser(
            email: email,
            nombreCompleto: name,
            roles: [UserRole.CLIENTE],
            telefono: phone,
            fotoPerfil: _photoUrl,
          );

          RegistrationDraft.clear();
          SessionManager.activeRole = UserRole.CLIENTE;
        }
      } else {
        await user.updateDisplayName(name);
        if (_photoUrl != null) {
          await user.updateProfile(photoURL: _photoUrl);
        }

        final currentUserData = await _authRepository.getCurrentUser();
        final List<UserRole> roles = currentUserData?.roles ?? [UserRole.CLIENTE];

        if (user.email != null) {
          await _authRepository.upsertUser(
            email: user.email!,
            nombreCompleto: name,
            roles: roles,
            telefono: phone,
            fotoPerfil: _photoUrl,
          );
        }
      }

      if (mounted) {
        _showContinueReservationDialog();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: $e');
      String errorMessage = 'Error al crear la cuenta.';
      if (e.code == 'weak-password') {
        errorMessage = 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Ya existe una cuenta con ese correo.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      debugPrint('Error guardando los datos: $e');
      if (mounted) {
        final errorString = e.toString();
        String friendlyMessage = 'Algo salió mal. Por favor, intenta de nuevo.';
        if (errorString.contains('Network reconnected') || 
            errorString.contains('cannot be safely retried') ||
            errorString.contains('connection') ||
            errorString.contains('SocketException') ||
            errorString.contains('403')) {
          friendlyMessage = 'Hubo un problema de conexión temporal. Por favor, presiona "Finalizar" de nuevo.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyMessage),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showContinueReservationDialog() {
    if (!mounted) return;

    // Check for pending payment intent (bank transfer) first
    if (BookingIntentManager.instance.hasPendingPaymentIntent()) {
      final paymentIntent = BookingIntentManager.instance.getPendingPaymentIntent();
      if (paymentIntent != null) {
        _showPendingPaymentDialog(paymentIntent);
        return;
      }
    }

    if (!BookingIntentManager.instance.hasIntent()) {
      context.go(AppRoutes.home);
      return;
    }

    final intent = BookingIntentManager.instance.getIntent();
    final laundryName = intent?.laundryName ?? '';

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
              const Expanded(
                child: Text(
                  'Reserva pendiente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            laundryName.isNotEmpty
                ? 'Tienes una reserva pendiente en $laundryName. ¿Deseas continuar con ella?'
                : 'Tienes una reserva pendiente. ¿Deseas continuar con ella?',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                BookingIntentManager.instance.clearIntent();
                context.go(AppRoutes.home);
              },
              child: const Text(
                'Ir al mapa',
                style: TextStyle(color: AppColors.outline, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _showPendingPaymentDialog(PendingPaymentIntent intent) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.payment_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pago pendiente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            'Tienes un pago por transferencia bancaria pendiente en "${intent.businessName}" por \$${intent.amount.toStringAsFixed(2)}. ¿Deseas revisar el estado?',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                BookingIntentManager.instance.clearPendingPaymentIntent();
                Navigator.pop(dialogContext);
                if (mounted) context.go(AppRoutes.home);
              },
              child: const Text(
                'Descartar',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProofStatusPage(
                        orderId: intent.orderId,
                        proofStatus: 'PENDING',
                        amount: intent.amount,
                        serviceName: intent.serviceName,
                        businessName: intent.businessName,
                      ),
                    ),
                  );
                }
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
                'Revisar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSignOut() async {
    final user = FirebaseAuth.instance.currentUser;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user != null ? '¿Cerrar Sesión?' : '¿Cancelar Registro?'),
        content: Text(user != null 
            ? '¿Estás seguro de que deseas cerrar sesión? Si sales ahora, se cerrará tu sesión actual y volverás a la pantalla de ingreso.'
            : '¿Estás seguro de que deseas cancelar el registro? Se perderán los datos ingresados y volverás a la pantalla de ingreso.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(user != null ? 'Cerrar Sesión' : 'Aceptar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        if (user != null) {
          await FirebaseAuth.instance.signOut();
          SessionManager.activeRole = null;
        } else {
          RegistrationDraft.clear();
        }
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        debugPrint('Error al cerrar sesión/cancelar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () {
            context.go(AppRoutes.roleSelection);
          },
        ),
        title: const Text(
          'WashGo',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.onSurface),
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stepper
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Paso 3 de 3',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: AppColors.outlineVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Headline
                const Text(
                  'Cuéntanos sobre ti',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Personaliza tu perfil para que nuestros especialistas puedan identificarte fácilmente.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),

                // Profile Photo
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.outlineVariant,
                        backgroundImage: _photoUrl != null
                            ? CachedNetworkImageProvider(_photoUrl!)
                            : null,
                        child: _photoUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.onSurfaceVariant,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Foto de perfil',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                      ),
                      if (_photoUrl != null) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Sincronizada desde Google',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Form Fields
                CustomTextField(
                  label: 'Nombre completo',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Teléfono de contacto',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.call_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),

                const SizedBox(height: 48),

                // Action Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _finalizar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Finalizar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Al finalizar, aceptas nuestros '),
                      TextSpan(
                        text: 'Términos de Servicio',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/terms'),
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Política de Privacidad',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/privacy'),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
