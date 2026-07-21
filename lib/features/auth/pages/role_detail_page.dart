import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/auth/models/registration_draft.dart';

class RoleDetailPage extends StatefulWidget {
  final UserRole role;

  const RoleDetailPage({
    super.key,
    required this.role,
  });

  @override
  State<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends State<RoleDetailPage> {
  bool _isLoading = false;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD32F2F),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF388E3C),
      ),
    );
  }

  String get _roleName {
    switch (widget.role) {
      case UserRole.CLIENTE:
        return 'Cliente';
      case UserRole.EMPLEADO:
        return 'Empleado';
      case UserRole.ADMINISTRADOR:
        return 'Dueño de Lavandería';
      case UserRole.SUPER_ADMIN:
        return 'Super Administrador';
    }
  }

  IconData get _roleIcon {
    switch (widget.role) {
      case UserRole.CLIENTE:
        return Icons.directions_car_rounded;
      case UserRole.EMPLEADO:
        return Icons.local_car_wash_rounded;
      case UserRole.ADMINISTRADOR:
        return Icons.storefront_rounded;
      case UserRole.SUPER_ADMIN:
        return Icons.admin_panel_settings_rounded;
    }
  }

  List<String> get _permissions {
    switch (widget.role) {
      case UserRole.CLIENTE:
        return [
          'Buscar y explorar autolavados cercanos.',
          'Reservar turnos para el lavado de tu vehículo.',
          'Pagar en línea de forma segura o en el local.',
          'Calificar y dejar comentarios sobre los servicios recibidos.',
          'Ver tu historial de lavados y facturas.',
        ];
      case UserRole.EMPLEADO:
        return [
          'Ver la lista de turnos asignados por tu empleador.',
          'Marcar servicios como en progreso o finalizados.',
          'Acceder a tu panel personalizado de trabajo.',
          'Recibir notificaciones en tiempo real sobre nuevos lavados asignados.',
        ];
      case UserRole.ADMINISTRADOR:
        return [
          'Crear y configurar uno o más locales de autolavado.',
          'Gestionar servicios, precios y horarios de atención.',
          'Invitar y gestionar a tus empleados.',
          'Ver reportes financieros, estadísticas y ganancias en tiempo real.',
          'Aprobar o rechazar pagos y gestionar facturación del negocio.',
        ];
      case UserRole.SUPER_ADMIN:
        return [
          'Acceso total a la administración global del sistema.',
        ];
    }
  }


  String get _onboardingDescription {
    switch (widget.role) {
      case UserRole.CLIENTE:
        return 'Al elegir este rol, irás al Paso 3 para ingresar tu número de teléfono de contacto y completar tu perfil.';
      case UserRole.EMPLEADO:
        return 'Al elegir este rol, deberás ingresar el código de invitación de 5 dígitos de tu empleador para vincularte a su local.';
      case UserRole.ADMINISTRADOR:
        return 'Al elegir este rol, tu cuenta de Administrador será creada inmediatamente y procederás a la configuración de los datos de tu primer local.';
      case UserRole.SUPER_ADMIN:
        return 'Rol administrativo global.';
    }
  }

  Future<void> _handleConfirm() async {
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      _isLoading = true;
    });

    try {
      if (user != null) {
        // User is already logged in (e.g. via social login)
        await _saveUserRole(widget.role);
        if (mounted) {
          _navigateToNext(widget.role);
        }
      } else {
        // Registering flow
        RegistrationDraft.role = widget.role;

        if (widget.role == UserRole.ADMINISTRADOR) {
          final email = RegistrationDraft.email;
          final password = RegistrationDraft.password;
          final name = RegistrationDraft.name;

          if (email.isEmpty || password.isEmpty || name.isEmpty) {
            throw Exception('Faltan datos de registro del paso anterior.');
          }

          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          await credential.user?.updateDisplayName(name);

          final AuthRepository authRepository = FirebaseAuthRepository();
          await authRepository.upsertUser(
            email: email,
            nombreCompleto: name,
            roles: [UserRole.ADMINISTRADOR, UserRole.CLIENTE],
          );

          RegistrationDraft.clear();
          SessionManager.activeRole = UserRole.ADMINISTRADOR;

          _showSuccess('Cuenta de Administrador creada exitosamente');

          if (mounted) {
            context.go(AppRoutes.ownerDashboard);
          }
        } else {
          // Client or Employee: proceed to onboarding steps without creating account yet
          _navigateToNext(widget.role);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        _showError('Ya existe una cuenta con ese correo.');
      } else {
        _showError('Error de autenticación: ${e.message}');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToNext(UserRole role) {
    if (role == UserRole.CLIENTE) {
      context.go('/onboarding-cliente');
    } else if (role == UserRole.EMPLEADO) {
      context.go('/onboarding-employee');
    } else if (role == UserRole.ADMINISTRADOR) {
      context.go(AppRoutes.ownerDashboard);
    }
  }

  Future<void> _saveUserRole(UserRole role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final AuthRepository authRepository = FirebaseAuthRepository();
      final existingUser = await authRepository.getCurrentUser();
      List<UserRole> existingRoles = [];
      if (existingUser != null) {
        existingRoles = existingUser.roles;
      }

      if (!existingRoles.contains(role)) {
        existingRoles.add(role);
      }

      if (role == UserRole.EMPLEADO || role == UserRole.ADMINISTRADOR) {
        if (!existingRoles.contains(UserRole.CLIENTE)) {
          existingRoles.add(UserRole.CLIENTE);
        }
      }

      await authRepository.upsertUser(
        email: user.email!,
        nombreCompleto: user.displayName ?? 'Usuario',
        roles: existingRoles,
      );

      SessionManager.activeRole = role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF151C27)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detalles del Rol',
          style: GoogleFonts.inter(
            color: const Color(0xFF151C27),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Role Icon & Name Header
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF1FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2),
                                    width: 4,
                                  ),
                                ),
                                child: Icon(
                                  _roleIcon,
                                  color: AppColors.primary,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _roleName,
                                style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF151C27),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Paso 2 de 3',
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
                        const SizedBox(height: 32),

                        // Section: Lo que puedes hacer
                        _SectionCard(
                          title: 'Lo que podrás hacer:',
                          titleColor: const Color(0xFF2E7D32),
                          backgroundColor: const Color(0xFFF1F8E9),
                          items: _permissions,
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 16),


                        // Info Card about Onboarding step
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E4EB)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF0288D1),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Siguiente paso:',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF151C27),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _onboardingDescription,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: const Color(0xFF424654),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Fixed Bottom Button Area
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirmar y Continuar',
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const _SectionCard({
    required this.title,
    required this.titleColor,
    required this.backgroundColor,
    required this.items,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E4EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF424654),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
