import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/dataconnect-generated/example.dart';

import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/laundries/repositories/business_repository.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/dashboard/owner/widgets/services_tab.dart';

class OwnerConfiguracionTab extends StatefulWidget {
  final List<UserRole> userRoles;
  final VoidCallback showProfileSheet;
  final TextEditingController nombreController;
  final TextEditingController rucController;
  final TextEditingController telefonoController;
  final TextEditingController descripcionController;
  final double? latitud;
  final double? longitud;
  final void Function(double lat, double lng) onLocationChanged;
  final List<String> diasSemana;
  final List<bool> diasSeleccionados;
  final void Function(int index, bool selected) onDaySelected;
  final TimeOfDay horaApertura;
  final TimeOfDay horaCierre;
  final Future<void> Function(BuildContext context, bool isApertura) selectTime;
  final bool isReservationConfigured;
  final TextEditingController capacidadController;
  final TextEditingController anticipacionController;
  final bool isSaving;
  final Future<void> Function() saveLocalDetails;
  final AuthRepository authRepository;
  final int activeOrdersCount;
  final String? businessId;
  final BusinessRepository businessRepository;
  final String? businessStatus;
  final bool wasApprovedBySuperAdmin;
  final VoidCallback onBusinessStatusChanged;
  final ValueNotifier<List<WashGoService>> servicesNotifier;
  final void Function(String id, bool active, String nombre)
  onToggleServiceActive;
  final void Function(WashGoService service) onEditService;
  final void Function(String id, String nombre) onDeleteService;
  final VoidCallback onAddService;

  const OwnerConfiguracionTab({
    super.key,
    required this.userRoles,
    required this.showProfileSheet,
    required this.nombreController,
    required this.rucController,
    required this.telefonoController,
    required this.descripcionController,
    required this.latitud,
    required this.longitud,
    required this.onLocationChanged,
    required this.diasSemana,
    required this.diasSeleccionados,
    required this.onDaySelected,
    required this.horaApertura,
    required this.horaCierre,
    required this.selectTime,
    required this.isReservationConfigured,
    required this.capacidadController,
    required this.anticipacionController,
    required this.isSaving,
    required this.saveLocalDetails,
    required this.authRepository,
    required this.activeOrdersCount,
    required this.businessId,
    required this.businessRepository,
    required this.businessStatus,
    this.wasApprovedBySuperAdmin = false,
    required this.onBusinessStatusChanged,
    required this.servicesNotifier,
    required this.onToggleServiceActive,
    required this.onEditService,
    required this.onDeleteService,
    required this.onAddService,
  });

  @override
  State<OwnerConfiguracionTab> createState() => _OwnerConfiguracionTabState();
}

class _OwnerConfiguracionTabState extends State<OwnerConfiguracionTab> {
  Widget _buildMiLocalTabContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: const Icon(Icons.store_rounded, color: AppColors.primary),
        title: Text(
          'Editar información de tu local',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Nombre, teléfono, dirección, horario y ubicación.',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _showEditLocalDialog(context),
      ),
    );
  }

  void _showEditLocalDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: !widget.isSaving,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.store_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Información de tu Local',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: widget.isSaving
                                ? null
                                : () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _buildFormContent(setDialogState),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormContent(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Información de Negocio',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre de la Lavandería',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.store, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.rucController,
          decoration: const InputDecoration(
            labelText: 'RUC / Cédula del Propietario',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.assignment, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.telefonoController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Teléfono del Local',
            helperText:
                'Tus clientes te contactarán a este número para más información (mín. 7 dígitos).',
            helperMaxLines: 2,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.descripcionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Descripción del Local',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: Colors.grey.shade200),
        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubicación en el Mapa',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.latitud == null || widget.longitud == null
                        ? 'Sin ubicación registrada'
                        : 'Lat: ${widget.latitud!.toStringAsFixed(5)}, Lng: ${widget.longitud!.toStringAsFixed(5)}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            LatLng initialCenter = LatLng(
              widget.latitud ?? -2.1961601,
              widget.longitud ?? -79.8862076,
            );
            final result = await context.push<LatLng>(
              AppRoutes.mapPicker,
              extra: initialCenter,
            );
            if (result != null) {
              widget.onLocationChanged(result.latitude, result.longitude);
              setDialogState(() {});
            }
          },
          icon: const Icon(Icons.map, size: 18),
          label: const Text('Editar Ubicación en el Mapa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade50,
            foregroundColor: AppColors.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: Colors.grey.shade200),
        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(
              Icons.access_time_filled_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Horario de Atención',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Selecciona los días que atiende tu local:',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(7, (index) {
            final isSelected = widget.diasSeleccionados[index];
            final label = widget.diasSemana[index].substring(0, 3);
            return GestureDetector(
              onTap: () {
                widget.onDaySelected(index, !isSelected);
                setDialogState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  await widget.selectTime(context, true);
                  setDialogState(() {});
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hora Apertura',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.login_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.horaApertura.format(context),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await widget.selectTime(context, false);
                  setDialogState(() {});
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hora Cierre',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.horaCierre.format(context),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.horaApertura.hour == widget.horaCierre.hour &&
            widget.horaApertura.minute == widget.horaCierre.minute) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Al configurar la misma hora de apertura y cierre, el local se considerará abierto las 24 horas del día.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        Divider(color: Colors.grey.shade200),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(
              Icons.event_seat_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Configuración de Reservas',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (!widget.isReservationConfigured) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber.shade800,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aún no has configurado las reservas para tu local. Los clientes no podrán agendar citas programadas hasta que completes esta configuración.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.capacidadController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Capacidad Simultánea (Reservas)',
            helperText:
                'Número máximo de citas o clientes que puedes atender al mismo tiempo (mín. 1).',
            helperMaxLines: 2,
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.anticipacionController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Tiempo de Anticipación (Minutos)',
            helperText:
                'Tiempo mínimo requerido antes de la cita para poder reservar (mín. 0).',
            helperMaxLines: 2,
            border: OutlineInputBorder(),
            prefixIcon: Icon(
              Icons.hourglass_empty_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: widget.isSaving
              ? null
              : () async {
                  if (widget.nombreController.text.trim().isEmpty ||
                      widget.rucController.text.trim().isEmpty ||
                      widget.telefonoController.text.trim().isEmpty ||
                      widget.capacidadController.text.trim().isEmpty ||
                      widget.anticipacionController.text.trim().isEmpty) {
                    widget.saveLocalDetails();
                    return;
                  }
                  await widget.saveLocalDetails();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: widget.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Guardar Cambios',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  void _showDeactivateLocalDialog(BuildContext context) {
    if (widget.activeOrdersCount > 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.block_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No se puede desactivar el local',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'No puedes desactivar tu local porque tienes ${widget.activeOrdersCount} servicios/reservas activas en curso. Por favor, complétalas o cancélalas primero.',
              style: GoogleFonts.inter(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.power_settings_new_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Desactivar Local',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que deseas desactivar tu local? Esto ocultará el local en el mapa para los clientes y suspenderá las reservas temporalmente. Tus empleados y facturas históricas se conservarán intactos.',
            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await widget.businessRepository.updateBusinessStatus(
                    widget.businessId!,
                    BusinessStatus.PENDING_APPROVAL,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Local desactivado con éxito.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    widget.onBusinessStatusChanged();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al desactivar el local: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showActivateLocalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Activar Local',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Deseas activar tu local para que sea visible en el mapa y comience a recibir reservas de los clientes nuevamente?',
            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await widget.businessRepository.updateBusinessStatus(
                    widget.businessId!,
                    BusinessStatus.APPROVED,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Local activado con éxito.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    widget.onBusinessStatusChanged();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al activar el local: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Activar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    if (widget.activeOrdersCount > 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.block_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No se puede eliminar la cuenta',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'No puedes eliminar tu cuenta porque tienes ${widget.activeOrdersCount} servicios/reservas activas en curso. Por favor, complétalas o cancélalas primero.',
              style: GoogleFonts.inter(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (widget.businessStatus == 'APPROVED') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(Icons.block_rounded, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Desactiva tu local primero',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Para poder eliminar tu cuenta, primero debes desactivar o suspender tu local para garantizar que no permanezca activo en el mapa para los clientes.',
              style: GoogleFonts.inter(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeactivateLocalDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Desactivar Local Ahora'),
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
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Eliminar Cuenta de Dueño',
                      style: GoogleFonts.inter(
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
                      'Esta acción es permanente y eliminará tu información de usuario (nombre, correo y teléfono) de forma irreversible, cerrando tu sesión.\n\n'
                      'Nota: Tu local se encuentra actualmente desactivado. Al confirmar, tu cuenta se eliminará definitivamente.',
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
                            'Entiendo que esta acción es permanente y confirmo la eliminación de mi cuenta.',
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
                    style: GoogleFonts.inter(
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
                              if (e.toString().contains(
                                'requires-recent-login',
                              )) {
                                errorMsg =
                                    'Por motivos de seguridad, debes haber iniciado sesión recientemente para eliminar tu cuenta. Cierra sesión y vuelve a ingresar para intentarlo.';
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
                    disabledBackgroundColor: AppColors.error.withValues(
                      alpha: 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
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
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildServiciosTabContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.local_laundry_service_rounded,
          color: AppColors.primary,
        ),
        title: Text(
          'Configurar servicios de tu local',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Precios, duración y catálogo de lavado o planchado.',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _showServicesDialog(context),
      ),
    );
  }

  void _showServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_laundry_service_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Catálogo de Servicios',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ValueListenableBuilder<List<WashGoService>>(
                    valueListenable: widget.servicesNotifier,
                    builder: (context, services, _) {
                      return SingleChildScrollView(
                        child: ServicesTab(
                          services: services,
                          onToggleActive: widget.onToggleServiceActive,
                          onEditService: widget.onEditService,
                          onDeleteService: widget.onDeleteService,
                          onAddService: widget.onAddService,
                          showHeader: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMiLocalTabContent(),
          const SizedBox(height: 16),
          _buildServiciosTabContent(),
          const SizedBox(height: 32),
          Text(
            'Opciones de Cuenta',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Ver Perfil / Cambiar de Rol',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Roles activos: ${widget.userRoles.map((r) => r.name).join(", ")}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: widget.showProfileSheet,
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                if (!widget.wasApprovedBySuperAdmin)
                  ListTile(
                    leading: const Icon(
                      Icons.hourglass_top_rounded,
                      color: Colors.amber,
                    ),
                    title: Text(
                      'Pendiente de Aprobación por WashGo',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade900,
                      ),
                    ),
                    subtitle: Text(
                      'Tu local está en revisión. WashGo debe aprobar tu solicitud antes de que puedas activarlo.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.amber,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              const Icon(
                                Icons.hourglass_top_rounded,
                                color: Colors.amber,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Aprobación Pendiente',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Tu local fue enviado a revisión por WashGo. Una vez que WashGo lo apruebe, podrás activarlo y gestionar la atención a tus clientes.',
                            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Entendido'),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  ListTile(
                    leading: Icon(
                      widget.businessStatus == 'APPROVED'
                          ? Icons.power_settings_new_rounded
                          : Icons.check_circle_rounded,
                      color: widget.businessStatus == 'APPROVED'
                          ? Colors.orange
                          : Colors.green,
                    ),
                    title: Text(
                      widget.businessStatus == 'APPROVED'
                          ? 'Desactivar Local / Suspender Servicio'
                          : 'Activar Local / Reabrir Servicio',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: widget.businessStatus == 'APPROVED'
                            ? Colors.orange.shade800
                            : Colors.green.shade800,
                      ),
                    ),
                    subtitle: Text(
                      widget.businessStatus == 'APPROVED'
                          ? 'Ocultar temporalmente tu local en el mapa para clientes.'
                          : 'Hacer visible tu local en el mapa y reabrir el servicio.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: widget.businessStatus == 'APPROVED'
                          ? Colors.orange
                          : Colors.green,
                    ),
                    onTap: () {
                      if (widget.businessStatus == 'APPROVED') {
                        _showDeactivateLocalDialog(context);
                      } else {
                        _showActivateLocalDialog(context);
                      }
                    },
                  ),
                Divider(height: 1, color: Colors.grey.shade100),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever_outlined,
                    color: AppColors.error,
                  ),
                  title: Text(
                    'Eliminar Cuenta',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  subtitle: Text(
                    'Eliminar permanentemente tu cuenta personal (PII).',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.error,
                  ),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: Text(
                    'Cerrar Sesión',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  subtitle: Text(
                    'Cerrar la sesión de forma segura.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onTap: () async {
                    final navContext = context;
                    await FirebaseAuth.instance.signOut();
                    if (!navContext.mounted) return;
                    navContext.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
