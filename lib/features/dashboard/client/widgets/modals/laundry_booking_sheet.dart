import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class LaundryBookingSheet {
  static void show({
    required BuildContext context,
    required LaundryItem laundry,
    required List<VehicleItem> myVehicles,
    required Future<List<Map<String, dynamic>>> Function(
      String businessId,
      double price,
    )
    loadServices,
    required Function(double lat, double lng) onOpenMaps,
    required Function(
      VehicleItem? selectedVehicle,
      bool scheduleNow,
      DateTime? scheduledDateTime,
      String serviceName,
      double servicePrice,
      OrderType serviceType,
    )
    onConfirmBooking,
  }) {
    final servicesFuture = loadServices(laundry.id, laundry.price);
    Map<String, dynamic>? selectedService;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: servicesFuture,
              builder: (sheetContext, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      height: 250,
                      child: Center(
                        child: Text(
                          'Error al cargar servicios: ${snapshot.error}',
                          style: GoogleFonts.inter(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }

                final servicesList = snapshot.data ?? [];
                if (selectedService == null && servicesList.isNotEmpty) {
                  selectedService = servicesList.first;
                }

                final currentPrice =
                    selectedService?['precio'] ?? laundry.price;
                final currentName = selectedService?['nombre'] ?? 'Servicio';
                final currentTipo = selectedService?['tipo'] ?? 'LOCAL';

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pull Bar
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  laundry.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  laundry.type,
                                  style: GoogleFonts.inter(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (laundry.isEco)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    color: Colors.green.shade700,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Eco',
                                    style: GoogleFonts.inter(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Mini Info badges Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailBadge(
                              icon: Icons.star_rounded,
                              color: Colors.amber,
                              title: 'Calificación',
                              value: laundry.rating == 0.0
                                  ? 'Nuevo'
                                  : '${laundry.rating.toStringAsFixed(1)} (${laundry.reviewsCount})',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDetailBadge(
                              icon: Icons.access_time_rounded,
                              color: AppColors.primary,
                              title: 'Espera Estimada',
                              value: laundry.waitTime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDetailBadge(
                              icon: Icons.directions_rounded,
                              color: Colors.green,
                              title: 'Distancia',
                              value: laundry.distance,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Dropdown Menu Header
                      Text(
                        'SERVICIOS DISPONIBLES',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dropdown Menu
                      if (servicesList.isEmpty)
                        Text(
                          'No hay servicios registrados en este local.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Map<String, dynamic>>(
                              value: selectedService,
                              isExpanded: true,
                              itemHeight: 64.0,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primary,
                              ),
                              elevation: 8,
                              style: GoogleFonts.inter(
                                color: AppColors.onSurface,
                                fontSize: 14,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              items: servicesList.map((service) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: service,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              service['nombre'],
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.onSurface,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${service['duracionMinutos']} min • ${service['tipo'] == 'LOCAL' ? 'En Local' : 'A Domicilio'}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: AppColors.outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '\$${(service['precio'] as double).toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newService) {
                                if (newService != null) {
                                  setModalState(() {
                                    selectedService = newService;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Horario de Atención
                      Text(
                        'HORARIO DE ATENCIÓN',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            ...() {
                              final daysOfWeek = [
                                '', // index 0 not used
                                'Lunes',
                                'Martes',
                                'Miércoles',
                                'Jueves',
                                'Viernes',
                                'Sábado',
                                'Domingo',
                              ];

                              final sortedHours =
                                  List<Map<String, dynamic>>.from(
                                    laundry.businessHours,
                                  );
                              sortedHours.sort(
                                (a, b) => (a['diaDeLaSemana'] as int).compareTo(
                                  b['diaDeLaSemana'] as int,
                                ),
                              );

                              final currentDay = DateTime.now().weekday;

                              return sortedHours.map((hours) {
                                final int dayIndex =
                                    hours['diaDeLaSemana'] ?? 1;
                                final String dayName = daysOfWeek[dayIndex];
                                final bool esDescanso =
                                    hours['esDiaDescanso'] ?? false;
                                final String apertura =
                                    hours['horaApertura'] ?? '08:00';
                                final String cierre =
                                    hours['horaCierre'] ?? '18:00';
                                final bool isToday = dayIndex == currentDay;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dayName,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isToday
                                              ? AppColors.primary
                                              : AppColors.onSurface,
                                        ),
                                      ),
                                      Text(
                                        esDescanso
                                            ? 'Cerrado'
                                            : '$apertura - $cierre',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: esDescanso
                                              ? Colors.red.shade400
                                              : (isToday
                                                    ? AppColors.primary
                                                    : AppColors
                                                          .onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            }(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (!laundry.isOpen) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _getClosedReason(laundry),
                                  style: GoogleFonts.inter(
                                    color: Colors.red.shade800,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Action buttons to navigate and confirm
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  onOpenMaps(
                                    laundry.location.latitude,
                                    laundry.location.longitude,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  foregroundColor: AppColors.primary,
                                ),
                                icon: const Icon(
                                  Icons.directions_rounded,
                                  size: 20,
                                ),
                                label: Text(
                                  'Cómo llegar',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: selectedService == null
                                    ? null
                                    : () {
                                        Navigator.pop(sheetContext);
                                        _showOrderConfirmDialog(
                                          context: context,
                                          laundry: laundry,
                                          myVehicles: myVehicles,
                                          serviceName: currentName,
                                          servicePrice: currentPrice,
                                          serviceType:
                                              currentTipo == 'DOMICILIO'
                                              ? OrderType.DELIVERY
                                              : OrderType.LOCAL,
                                          onConfirmBooking: onConfirmBooking,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Agendar - \$${currentPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static String _getClosedReason(LaundryItem laundry) {
    if (laundry.isOpen) return '';

    final weekday = DateTime.now().weekday;
    final bh = laundry.businessHours.firstWhere(
      (element) => element['diaDeLaSemana'] == weekday,
      orElse: () => <String, dynamic>{},
    );

    final bool esDescanso = bh['esDiaDescanso'] ?? false;
    if (esDescanso) {
      return 'Hoy es día de descanso para este local.';
    }

    final String? apertura = bh['horaApertura'];
    final String? cierre = bh['horaCierre'];
    if (apertura != null && cierre != null) {
      return 'Fuera del horario de atención ($apertura - $cierre).';
    }

    return 'Este local está temporalmente fuera de servicio o no disponible.';
  }

  static DateTime _getInitialDatePickerDate(LaundryItem laundry) {
    final DateTime now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final DateTime candidate = now.add(Duration(days: i));
      final int weekday = candidate.weekday;
      final bh = laundry.businessHours.firstWhere(
        (element) => element['diaDeLaSemana'] == weekday,
        orElse: () => <String, dynamic>{},
      );
      final bool esDescanso = bh['esDiaDescanso'] ?? false;
      if (!esDescanso) {
        return candidate;
      }
    }
    return now;
  }

  static bool _isValidBusinessDateTime(LaundryItem laundry, DateTime dateTime) {
    final int weekday = dateTime.weekday;
    final bh = laundry.businessHours.firstWhere(
      (element) => element['diaDeLaSemana'] == weekday,
      orElse: () => <String, dynamic>{},
    );
    final bool esDescanso = bh['esDiaDescanso'] ?? false;
    if (esDescanso) return false;

    final String? apertura = bh['horaApertura'];
    final String? cierre = bh['horaCierre'];
    if (apertura == null || cierre == null) return true;

    try {
      final partsOpen = apertura.split(':');
      final partsClose = cierre.split(':');
      if (partsOpen.length < 2 || partsClose.length < 2) return true;
      final openMinutes =
          int.parse(partsOpen[0]) * 60 + int.parse(partsOpen[1]);
      final closeMinutes =
          int.parse(partsClose[0]) * 60 + int.parse(partsClose[1]);
      final targetMinutes = dateTime.hour * 60 + dateTime.minute;

      if (openMinutes == closeMinutes) {
        return true; // 24/7
      }

      if (openMinutes < closeMinutes) {
        // Normal daytime hours (e.g., 08:00 to 18:00)
        return targetMinutes >= openMinutes && targetMinutes <= closeMinutes;
      } else {
        // Overnight hours (e.g., 20:00 to 02:00)
        return targetMinutes >= openMinutes || targetMinutes <= closeMinutes;
      }
    } catch (_) {
      return true;
    }
  }

  static void _showOrderConfirmDialog({
    required BuildContext context,
    required LaundryItem laundry,
    required List<VehicleItem> myVehicles,
    required String serviceName,
    required double servicePrice,
    required OrderType serviceType,
    required Function(
      VehicleItem? selectedVehicle,
      bool scheduleNow,
      DateTime? scheduledDateTime,
      String serviceName,
      double servicePrice,
      OrderType serviceType,
    )
    onConfirmBooking,
  }) {
    VehicleItem? selectedVehicle = myVehicles.isNotEmpty
        ? myVehicles.first
        : null;
    bool scheduleNow = laundry.isOpen;
    DateTime? selectedScheduleDateTime;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final bool isTimeValid =
                scheduleNow ||
                (selectedScheduleDateTime != null &&
                    _isValidBusinessDateTime(
                      laundry,
                      selectedScheduleDateTime!,
                    ));
            final bool canConfirm =
                (scheduleNow && laundry.isOpen) ||
                (!scheduleNow &&
                    selectedScheduleDateTime != null &&
                    isTimeValid);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Confirmar Reserva',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Estás seguro de solicitar un turno en ${laundry.name}?',
                      style: GoogleFonts.inter(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Programación de atención:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: !laundry.isOpen
                                ? null
                                : () {
                                    setDialogState(() {
                                      scheduleNow = true;
                                    });
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: scheduleNow
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: scheduleNow
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Opacity(
                                opacity: laundry.isOpen ? 1.0 : 0.5,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on_rounded,
                                      color: scheduleNow
                                          ? AppColors.primary
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ahora mismo',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: scheduleNow
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              setDialogState(() {
                                scheduleNow = false;
                              });
                              final date = await showDatePicker(
                                context: dialogContext,
                                initialDate:
                                    selectedScheduleDateTime ??
                                    _getInitialDatePickerDate(laundry),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 30),
                                ),
                                selectableDayPredicate: (DateTime day) {
                                  final int weekday = day.weekday;
                                  final bh = laundry.businessHours.firstWhere(
                                    (element) =>
                                        element['diaDeLaSemana'] == weekday,
                                    orElse: () => <String, dynamic>{},
                                  );
                                  final bool esDescanso =
                                      bh['esDiaDescanso'] ?? false;
                                  return !esDescanso;
                                },
                              );
                              if (!dialogContext.mounted) return;
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: dialogContext,
                                  initialTime: selectedScheduleDateTime != null
                                      ? TimeOfDay.fromDateTime(
                                          selectedScheduleDateTime!,
                                        )
                                      : TimeOfDay.now(),
                                );
                                if (!dialogContext.mounted) return;
                                if (time != null) {
                                  setDialogState(() {
                                    selectedScheduleDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !scheduleNow
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: !scheduleNow
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    color: !scheduleNow
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Programar',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: !scheduleNow
                                          ? AppColors.primary
                                          : AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!scheduleNow) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: dialogContext,
                            initialDate:
                                selectedScheduleDateTime ??
                                _getInitialDatePickerDate(laundry),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            selectableDayPredicate: (DateTime day) {
                              final int weekday = day.weekday;
                              final bh = laundry.businessHours.firstWhere(
                                (element) =>
                                    element['diaDeLaSemana'] == weekday,
                                orElse: () => <String, dynamic>{},
                              );
                              final bool esDescanso =
                                  bh['esDiaDescanso'] ?? false;
                              return !esDescanso;
                            },
                          );
                          if (!dialogContext.mounted) return;
                          if (date != null) {
                            final time = await showTimePicker(
                              context: dialogContext,
                              initialTime: selectedScheduleDateTime != null
                                  ? TimeOfDay.fromDateTime(
                                      selectedScheduleDateTime!,
                                    )
                                  : TimeOfDay.now(),
                            );
                            if (!dialogContext.mounted) return;
                            if (time != null) {
                              setDialogState(() {
                                selectedScheduleDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedScheduleDateTime == null
                                      ? 'Seleccionar fecha y hora'
                                      : 'Fecha/Hora: ${selectedScheduleDateTime!.day.toString().padLeft(2, '0')}/${selectedScheduleDateTime!.month.toString().padLeft(2, '0')}/${selectedScheduleDateTime!.year} ${selectedScheduleDateTime!.hour.toString().padLeft(2, '0')}:${selectedScheduleDateTime!.minute.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: selectedScheduleDateTime == null
                                        ? Colors.red.shade700
                                        : AppColors.onSurface,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.edit_calendar_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (selectedScheduleDateTime != null &&
                          !_isValidBusinessDateTime(
                            laundry,
                            selectedScheduleDateTime!,
                          )) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'El local no atiende en el horario seleccionado.',
                                style: GoogleFonts.inter(
                                  color: Colors.red.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Servicio:',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              Expanded(
                                child: Text(
                                  serviceName,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign:
                                      Alignment.centerRight ==
                                          Alignment.centerRight
                                      ? TextAlign.end
                                      : TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Precio:',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              Text(
                                '\$${servicePrice.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vehículo:',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: myVehicles.isEmpty
                                    ? Text(
                                        'Sin vehículo registrado',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.outline,
                                        ),
                                        textAlign: TextAlign.end,
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton<VehicleItem>(
                                          value: selectedVehicle,
                                          isDense: true,
                                          alignment: Alignment.centerRight,
                                          items: myVehicles.map((car) {
                                            return DropdownMenuItem<
                                              VehicleItem
                                            >(
                                              value: car,
                                              child: Text(
                                                '${car.categoryDisplayName} (${car.plate})',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (VehicleItem? val) {
                                            if (val != null) {
                                              setDialogState(() {
                                                selectedVehicle = val;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pago:',
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                              Text(
                                'Efectivo',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: AppColors.outline),
                  ),
                ),
                ElevatedButton(
                  onPressed: canConfirm
                      ? () {
                          Navigator.pop(dialogContext); // Close confirm dialog
                          onConfirmBooking(
                            selectedVehicle,
                            scheduleNow,
                            selectedScheduleDateTime,
                            serviceName,
                            servicePrice,
                            serviceType,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildDetailBadge({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 10, color: AppColors.outline),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
