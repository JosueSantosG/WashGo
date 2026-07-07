import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/auth/models/super_admin_session.dart';
import 'package:washgo/shared/widgets/custom_text_field.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class SuperAdminLoginPage extends StatefulWidget {
  const SuperAdminLoginPage({super.key});

  @override
  State<SuperAdminLoginPage> createState() => _SuperAdminLoginPageState();
}

class _SuperAdminLoginPageState extends State<SuperAdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController(text: 'root');
  final TextEditingController _passwordController = TextEditingController(text: 'admin');
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, complete todos los campos', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (username == 'root' && password == 'admin') {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: 'root@washgo.com',
            password: 'admin_superadmin',
          );
        } on FirebaseAuthException catch (e) {
          // Si el usuario no existe (ej. en el emulador local), lo creamos
          if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
            try {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: 'root@washgo.com',
                password: 'admin_superadmin',
              );
            } catch (createError) {
              _showSnackBar('Error al configurar la autenticación de SuperAdministrador: $createError', isError: true);
              setState(() => _isLoading = false);
              return;
            }
          } else {
            _showSnackBar('Error de autenticación con Firebase: ${e.message}', isError: true);
            setState(() => _isLoading = false);
            return;
          }
        }

        // Seed the user in PostgreSQL via Data Connect
        try {
          await FirebaseAuthRepository().upsertUser(
            nombreCompleto: 'Super Administrador',
            email: 'root@washgo.com',
            roles: [UserRole.SUPER_ADMIN],
          );
        } catch (dbError) {
          debugPrint('Error al guardar SuperAdministrador en DB: $dbError');
        }

        if (!mounted) return;
        SuperAdminSession.isLoggedIn = true;
        _showSnackBar('¡Bienvenido, SuperAdministrador!', isError: false);
        context.go(AppRoutes.superAdminDashboard);
      } else {
        _showSnackBar('Credenciales maestras incorrectas', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error de conexión o autenticación: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? AppColors.error : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onBackground),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.outlineVariant, width: 1),
              ),
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon & Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.admin_panel_settings,
                          size: 44,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'WashGo',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Header Text
                    Text(
                      'Portal de SuperAdministración',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingrese con las credenciales maestras del sistema',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form Fields
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Usuario',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      isPassword: true,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Acceder al Panel',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Back button alternative
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(
                        'Volver al login de usuarios',
                        style: GoogleFonts.inter(
                          color: AppColors.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
