import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/dataconnect-generated/example.dart';

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
  final VoidCallback saveLocalDetails;

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
  });

  @override
  State<OwnerConfiguracionTab> createState() => _OwnerConfiguracionTabState();
}

class _OwnerConfiguracionTabState extends State<OwnerConfiguracionTab> {
  Widget _buildMiLocalTabContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
              helperText: 'Tus clientes te contactarán a este número para más información (mín. 7 dígitos).',
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

          // Geolocation Map Picker integration
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

          // Business Hours Section
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
                  onTap: () => widget.selectTime(context, true),
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
                  onTap: () => widget.selectTime(context, false),
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
              helperText: 'Número máximo de citas o clientes que puedes atender al mismo tiempo (mín. 1).',
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
              helperText: 'Tiempo mínimo requerido antes de la cita para poder reservar (mín. 0).',
              helperMaxLines: 2,
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.timer_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.isSaving ? null : widget.saveLocalDetails,
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
      ),
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
