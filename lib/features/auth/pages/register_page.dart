import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/shared/widgets/custom_text_field.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Por favor, completa todos los campos.');
      return;
    }

    // Validar formato de correo electrónico
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Por favor, ingresa un correo electrónico válido.');
      return;
    }

    // Validar contraseña segura
    if (password.length < 8) {
      _showError('La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _showError('La contraseña debe contener al menos una letra mayúscula.');
      return;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _showError('La contraseña debe contener al menos una letra minúscula.');
      return;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _showError('La contraseña debe contener al menos un número.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Las contraseñas no coinciden.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Actualizar el perfil del usuario con el nombre
      await credential.user?.updateDisplayName(name);

      // Guardar información del usuario en Data Connect (el teléfono se registrará en el onboarding)
      final AuthRepository authRepository = FirebaseAuthRepository();
      await authRepository.upsertUser(
        email: email,
        nombreCompleto: name,
        roles: [], // Roles se asignarán en la selección de roles
      );

      _showSuccess('Cuenta creada exitosamente');
      // No necesitamos navegar manualmente, el AuthGate debería detectar el cambio de estado.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        _showError('Ya existe una cuenta con ese correo.');
      } else {
        _showError('Error de autenticación: ${e.message}');
      }
    } catch (e) {
      _showError('Ocurrió un error inesperado: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green.shade600),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Brand
                            Container(
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'WashGo',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Texts
                            Text(
                              'Crea una cuenta',
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Regístrate para empezar a usar WashGo',
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Form
                            CustomTextField(
                              controller: _nameController,
                              label: 'Nombre completo',
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _emailController,
                              label: 'Correo electrónico',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Contraseña',
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirmar contraseña',
                              isPassword: true,
                            ),
                            const SizedBox(height: 32),

                            // Register Button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signUp,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Registrarse'),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),

                        // Login
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes una cuenta?',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Iniciar sesión'),
                            ),
                          ],
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
}

