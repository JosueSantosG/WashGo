import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';

class EmployeeProfileTab extends StatefulWidget {
  final EmployeeStatus? employeeStatus;
  final bool isAvailable;
  final bool isLoadingAvailability;
  final String? employeeName;
  final String? employeePhone;
  final String? employeeEmail;
  final List<UserRole> userRoles;
  final AuthRepository authRepository;
  final Future<void> Function(bool) onToggleAvailability;
  final Future<void> Function() onRefreshDashboard;
  final void Function(String name, String phone) onProfileUpdated;

  const EmployeeProfileTab({
    super.key,
    required this.employeeStatus,
    required this.isAvailable,
    required this.isLoadingAvailability,
    required this.employeeName,
    required this.employeePhone,
    required this.employeeEmail,
    required this.userRoles,
    required this.authRepository,
    required this.onToggleAvailability,
    required this.onRefreshDashboard,
    required this.onProfileUpdated,
  });

  @override
  State<EmployeeProfileTab> createState() => _EmployeeProfileTabState();
}

class _EmployeeProfileTabState extends State<EmployeeProfileTab> {
  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: widget.employeeName);
    final phoneController = TextEditingController(text: widget.employeePhone);
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

                              await widget.authRepository.upsertUser(
                                nombreCompleto: newName,
                                email: widget.employeeEmail ?? '',
                                roles: widget.userRoles,
                                telefono: newPhone,
                              );

                              widget.onProfileUpdated(newName, newPhone);

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

  Widget _buildPersonalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Información Personal',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              tooltip: 'Editar Perfil',
              onPressed: _showEditProfileDialog,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  'Nombre Completo',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                subtitle: Text(
                  widget.employeeName ?? 'No disponible',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  'Correo Electrónico',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                subtitle: Text(
                  widget.employeeEmail ?? 'No disponible',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  'Teléfono',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                subtitle: Text(
                  (widget.employeePhone != null && widget.employeePhone!.isNotEmpty)
                      ? widget.employeePhone!
                      : 'No especificado',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: (widget.employeePhone != null && widget.employeePhone!.isNotEmpty)
                        ? AppColors.onSurface
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legal y Cumplimiento',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                title: Text(
                  'Términos y Condiciones',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showTermsDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                title: Text(
                  'Política de Privacidad y GDPR',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPrivacyPolicyDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
                title: Text(
                  'Eliminar Cuenta',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          ),
        ),
      ],
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
                    'Bienvenido a WashGo. Al utilizar nuestra aplicación, aceptas cumplir con los siguientes términos y condiciones. Por favor, léelos atentamente.\n\n'
                    '1. Descripción del Servicio\n'
                    'WashGo facilita la reserva y gestión de servicios de lavado de vehículos a domicilio o en establecimientos asociados.\n\n'
                    '2. Registro de Usuario\n'
                    'Para utilizar el servicio, debes registrarte proporcionando información verídica, incluyendo tu nombre, correo electrónico y número de teléfono. Eres responsable de mantener la seguridad de tu cuenta.\n\n'
                    '3. Cancelaciones y Reembolsos\n'
                    'Las cancelaciones de servicios están sujetas a políticas específicas que pueden conllevar cargos según el tiempo de anticipación con el que se realicen.\n\n'
                    '4. Responsabilidad\n'
                    'WashGo no se responsabiliza por daños indirectos que no sean directamente atribuibles a negligencia grave de la plataforma o sus afiliados autorizados.',
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
                    'En WashGo, nos comprometemos a proteger tu privacidad y datos personales.\n\n'
                    '1. Datos que recopilamos\n'
                    'Recopilamos información de registro (nombre, correo, teléfono), información del vehículo (placa, marca, modelo) y datos de ubicación para facilitar el servicio de lavado.\n\n'
                    '2. Uso de la información\n'
                    'Utilizamos tus datos para procesar tus reservas, comunicarnos contigo sobre tus servicios y mejorar nuestra plataforma.\n\n'
                    '3. Derechos GDPR / ARCO\n'
                    'De acuerdo con las normativas locales e internacionales de protección de datos (como el GDPR), tienes derecho a Acceder, Rectificar, Cancelar y Oponerse (derechos ARCO) al tratamiento de tus datos personales. Puedes solicitar la eliminación completa de tu cuenta y datos asociados en cualquier momento desde la sección de configuración de la app.\n\n'
                    '4. Conservación de datos\n'
                    'Si decides eliminar tu cuenta, todos tus datos personales serán purgados de forma permanente de nuestras bases de datos activas dentro de los plazos establecidos por la ley.',
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
                            await widget.authRepository.deleteAccount();
                            SessionManager.activeRole = null;
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cuenta eliminada con éxito.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              context.go('/login');
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


  Widget _buildAccountSettingsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajustes de Cuenta',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              if (widget.userRoles.contains(UserRole.CLIENTE)) ...[
                ListTile(
                  leading: const Icon(Icons.directions_car_filled_rounded, color: AppColors.primary),
                  title: const Text('Cambiar a modo Cliente'),
                  subtitle: const Text('Ir al panel de reservas de cliente'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    SessionManager.activeRole = UserRole.CLIENTE;
                    context.go('/auth-gate');
                  },
                ),
                const Divider(height: 1),
              ],
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
                subtitle: const Text('Salir de la cuenta actual'),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                onTap: () async {
                  final router = GoRouter.of(context);
                  await FirebaseAuth.instance.signOut();
                  SessionManager.activeRole = null;
                  router.go('/login');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityToggleCard() {
    final isPending = widget.employeeStatus == EmployeeStatus.PENDING;
    final statusColor = isPending
        ? Colors.grey
        : (widget.isAvailable ? Colors.green : Colors.orange);
    final statusText = isPending
        ? 'Esperando Aprobación'
        : (widget.isAvailable ? 'Disponible' : 'En Receso / Almuerzo');
    final statusDesc = isPending
        ? 'Tu cuenta debe ser aceptada por el dueño para poder activarte.'
        : (widget.isAvailable
            ? 'Activo para recibir y aceptar pedidos en cola.'
            : 'En descanso. Puedes ver pedidos en cola pero no aceptarlos.');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPending
                    ? Icons.hourglass_empty_rounded
                    : (widget.isAvailable ? Icons.check_circle_rounded : Icons.lunch_dining_rounded),
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusDesc,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isLoadingAvailability)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Switch.adaptive(
                value: isPending ? false : widget.isAvailable,
                activeThumbColor: Colors.green,
                activeTrackColor: Colors.green.withValues(alpha: 0.3),
                inactiveThumbColor: Colors.orange,
                inactiveTrackColor: Colors.orange.withValues(alpha: 0.3),
                onChanged: isPending ? null : widget.onToggleAvailability,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefreshDashboard,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Employee Header
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    (widget.employeeName != null && widget.employeeName!.isNotEmpty)
                        ? widget.employeeName!.substring(0, 1).toUpperCase()
                        : 'E',
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.employeeName ?? 'Empleado',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Availability Card (Disponibilidad)
          Text(
            'Disponibilidad',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          _buildAvailabilityToggleCard(),
          const SizedBox(height: 24),

          // Información Personal
          _buildPersonalInfoCard(),
          const SizedBox(height: 24),



          // Legal y Cumplimiento
          _buildLegalCard(),
          const SizedBox(height: 24),

          // Ajustes de Cuenta
          _buildAccountSettingsCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
