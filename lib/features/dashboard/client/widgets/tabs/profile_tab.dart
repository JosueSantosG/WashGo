import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/auth/models/washgo_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTab extends StatelessWidget {
  final User? user;
  final WashGoUser? washGoUser;
  final bool isRolesLoading;
  final List<String> userRoles;
  final Future<void> Function({required String name, required String phone}) onUpdateProfile;
  final Future<void> Function() onDeleteAccount;
  final bool hasActiveReservations;

  const ProfileTab({
    super.key,
    required this.user,
    required this.washGoUser,
    required this.isRolesLoading,
    required this.userRoles,
    required this.onUpdateProfile,
    required this.onDeleteAccount,
    required this.hasActiveReservations,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Mi Perfil',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: _buildGuestPlaceholder(context),
      );
    }
    return SafeArea(
      key: const ValueKey('profile_section'),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header info
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: (washGoUser?.fotoPerfil != null && washGoUser!.fotoPerfil!.isNotEmpty)
                    ? CachedNetworkImageProvider(washGoUser!.fotoPerfil!)
                    : (user?.photoURL != null ? CachedNetworkImageProvider(user!.photoURL!) : null),
                child: (washGoUser?.fotoPerfil == null || washGoUser!.fotoPerfil!.isEmpty) && user?.photoURL == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      washGoUser?.nombreCompleto ?? user?.displayName ?? 'Usuario de WashGo',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      washGoUser?.email ?? user?.email ?? 'cliente@washgo.com',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section: Personal Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INFORMACIÓN PERSONAL',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.outline,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                onPressed: () => _showEditProfileDialog(context),
                tooltip: 'Editar Perfil',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  title: Text(
                    'Nombre Completo',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.outline,
                    ),
                  ),
                  subtitle: Text(
                    washGoUser?.nombreCompleto ?? user?.displayName ?? 'No disponible',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                  title: Text(
                    'Teléfono',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.outline,
                    ),
                  ),
                  subtitle: Text(
                    (washGoUser?.telefono != null && washGoUser!.telefono!.isNotEmpty)
                        ? washGoUser!.telefono!
                        : 'No especificado',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),


          // Role Switch options
          if (!isRolesLoading && userRoles.length > 1) ...[
            Text(
              'OPCIONES DE PERFIL',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.outline,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                onTap: () {
                  context.go('/select-active-role');
                },
                leading: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Cambiar de Rol / Panel',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  'Tienes múltiples roles en tu cuenta.',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Section: Legal & Compliance
          Text(
            'LEGAL Y CUMPLIMIENTO',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.outline,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: Text(
                    'Términos y Condiciones',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showTermsDialog(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: Text(
                    'Política de Privacidad y GDPR',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showPrivacyPolicyDialog(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
                  title: Text(
                    'Eliminar Cuenta',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sign out card
          Container(
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              onTap: () async {
                SessionManager.activeRole = null;
                await FirebaseAuth.instance.signOut();
                if (!kIsWeb) {
                  try {
                    await GoogleSignIn().disconnect();
                  } catch (_) {}
                  await GoogleSignIn().signOut();
                }
              },
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text(
                'Cerrar Sesión',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final nameController = TextEditingController(text: washGoUser?.nombreCompleto ?? user?.displayName ?? '');
    final phoneController = TextEditingController(text: washGoUser?.telefono ?? '');
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Editar Perfil',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre Completo',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Número de Teléfono',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa tu teléfono';
                          }
                          final trimmed = value.trim();
                          if (trimmed.length < 7) {
                            return 'El número es muy corto';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.outfit(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setDialogState(() {
                              isSaving = true;
                            });

                            try {
                              final newName = nameController.text.trim();
                              final newPhone = phoneController.text.trim();

                              await onUpdateProfile(
                                name: newName,
                                phone: newPhone,
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Perfil actualizado correctamente.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              setDialogState(() {
                                isSaving = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al actualizar: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Guardar',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.description_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Términos y Condiciones',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Términos y Condiciones de Uso de WashGo\n\n'
                    'Al utilizar nuestra aplicación, aceptas cumplir con los siguientes términos y condiciones:\n\n'
                    '1. Descripción del Servicio: WashGo es una plataforma tecnológica que actúa como intermediario facilitador de reservas, pagos y gestión de flujos de trabajo de lavado de vehículos.\n\n'
                    '2. Registro y Cuentas: Eres responsable de mantener la seguridad y confidencialidad de tus credenciales de acceso.\n\n'
                    '3. Cancelaciones y Reembolsos: Las cancelaciones de servicios están sujetas a políticas y tiempos de anticipación del local asociado.\n\n'
                    '4. Responsabilidad: WashGo no se responsabiliza por la calidad del lavado realizado por los negocios asociados ni por altercados entre usuarios en los establecimientos.\n\n'
                    '5. Eliminación de Cuenta: Si decides eliminar tu cuenta, tus accesos se cancelarán inmediatamente. Para dueños de locales, esto implica la desactivación definitiva de sus locales y desvinculación de empleados. Los históricos de órdenes y transacciones financieras se mantendrán de forma estrictamente anonimizada para fines legales y de auditoría fiscal.\n\n'
                    '6. Regulación para Empleados: Los empleados pueden postularse y pertenecer a múltiples locales asociados independientes. El empleado es responsable de seleccionar la sucursal activa correcta antes de registrar asistencia o iniciar jornada.\n\n'
                    '7. Fallas en Procesamiento de Pagos y Mensajes de Error: Ante fallas de red, la plataforma mostrará mensajes de error simplificados. Si tu pago digital mediante PayPhone o PayPal fue debitado de tu cuenta pero la aplicación arrojó un error, el cliente debe utilizar la opción "Ya pagué – Verificar" o contactar al soporte de WashGo presentando su comprobante de pago digital para la acreditación manual de la orden.',
                    style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Entendido',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Política de Privacidad',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Política de Privacidad de WashGo\n\n'
                    'En WashGo, nos comprometemos a proteger tu privacidad y datos personales:\n\n'
                    '1. Datos Recopilados: Información de registro (nombre, correo, teléfono), datos del vehículo, ubicación en tiempo real (con consentimiento), archivos/cámara (para comprobantes de transferencia) e historial de pagos y transacciones.\n\n'
                    '2. Uso de la Información: Conectar a clientes con locales de lavado, validar transacciones de pago/saldos, y brindar soporte técnico.\n\n'
                    '3. Compartición de Datos: Se comparten datos únicamente con las partes involucradas en una reserva, proveedores esenciales (Firebase, PayPal, PayPhone), y con los propietarios en el caso de los empleados (quienes verán registros de actividad laboral e información básica de contacto únicamente en esa sucursal).\n\n'
                    '4. Eliminación de Cuenta y Anonimización: Puedes solicitar la eliminación de tu cuenta desde la app o vía soporte@washgo.app. Se purgarán tus credenciales de Firebase Auth de forma permanente y se anonimizará tu perfil (reemplazando tus datos por "Usuario Eliminado"). Los registros de transacciones y órdenes históricas permanecerán guardados para cumplimiento contable de manera estrictamente anonimizada.',
                    style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Entendido',
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    if (hasActiveReservations) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reservas Activas',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'No puedes eliminar tu cuenta porque tienes reservas activas en curso.\n\n'
              'Por favor, espera a que tus reservas se completen o cancélalas para poder continuar.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.outfit(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    bool isConfirmed = false;
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Eliminar Cuenta',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Esta acción es irreversible y permanente de acuerdo con tus derechos GDPR/ARCO.\n\n'
                      'Al proceder, ocurrirá lo siguiente:\n'
                      '• Se eliminará permanentemente tu usuario de nuestros servidores.\n'
                      '• Perderás el acceso a tu historial de reservas y facturas.\n'
                      '• Tu cuenta de autenticación será completamente eliminada.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: isConfirmed,
                            activeColor: AppColors.error,
                            onChanged: isDeleting
                                ? null
                                : (value) {
                                    setDialogState(() {
                                      isConfirmed = value ?? false;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Entiendo que esta acción es permanente y confirmo la purga de mis datos.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.outfit(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (!isConfirmed || isDeleting)
                      ? null
                      : () async {
                          setDialogState(() {
                            isDeleting = true;
                          });
                          try {
                            await onDeleteAccount();
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cuenta eliminada con éxito.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            setDialogState(() {
                              isDeleting = false;
                            });
                            if (context.mounted) {
                              String errorMsg = 'Error al eliminar cuenta: $e';
                              if (e.toString().contains('requires-recent-login')) {
                                errorMsg = 'Por motivos de seguridad, debes haber iniciado sesión recientemente para eliminar tu cuenta. Cierra sesión y vuelve a ingresar para intentarlo.';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMsg),
                                  backgroundColor: AppColors.error,
                                  duration: const Duration(seconds: 6),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.error.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Eliminar',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
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
                Icons.person_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tu Perfil',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Inicia sesión para actualizar tu información y acceder a configuraciones avanzadas.',
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
