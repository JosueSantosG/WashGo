import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';
import 'package:washgo/features/dashboard/client/widgets/payment_selection_page.dart';
import 'package:washgo/features/profile/repositories/vehicle_repository.dart';
import 'package:washgo/features/profile/repositories/firebase_vehicle_repository.dart';
import 'package:washgo/features/laundries/repositories/laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_laundry_repository.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/features/dashboard/client/widgets/vehicles/vehicle_dialogs.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/laundries/models/business_reservation_config.dart';
import 'package:washgo/features/laundries/repositories/reservation_config_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_reservation_config_repository.dart';
import 'package:washgo/features/orders/models/order_reservation.dart';
import 'package:washgo/features/orders/repositories/reservation_metadata_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_reservation_metadata_repository.dart';
import 'package:washgo/features/laundries/services/availability_service.dart';





class LaundryBookingPage extends StatefulWidget {
  final LaundryItem laundry;
  final List<LaundryItem> allLaundries;

  const LaundryBookingPage({
    super.key,
    required this.laundry,
    required this.allLaundries,
  });

  @override
  State<LaundryBookingPage> createState() => _LaundryBookingPageState();
}

class _LaundryBookingPageState extends State<LaundryBookingPage> {
  final VehicleRepository _vehicleRepository = FirebaseVehicleRepository();
  final LaundryRepository _laundryRepository = FirebaseLaundryRepository();
  final OrderRepository _orderRepository = FirebaseOrderRepository();
  final ReservationConfigRepository _reservationConfigRepository = FirebaseReservationConfigRepository();
  final ReservationMetadataRepository _reservationMetadataRepository = FirebaseReservationMetadataRepository();

  List<VehicleItem> _myVehicles = [];
  bool _loadingVehicles = true;

  Future<List<Map<String, dynamic>>>? _servicesFuture;
  Map<String, dynamic>? _selectedService;

  VehicleItem? _selectedVehicle;
  bool _scheduleNow = true;
  DateTime? _selectedScheduleDateTime;
  String? _waitTime;

  BusinessReservationConfig? _reservationConfig;
  bool _loadingReservationConfig = true;
  List<OrderReservation> _activeReservations = [];

  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _loadServicesForBusiness(widget.laundry.id, widget.laundry.price);
    _fetchMyVehicles();
    _loadWaitTime();
    _loadReservationData();
    _scheduleNow = _isValidBusinessDateTime(widget.laundry, DateTime.now());
  }

  Future<void> _loadWaitTime() async {
    try {
      final waitTime = await _laundryRepository.getBusinessWaitTime(widget.laundry.id);
      if (mounted) {
        setState(() {
          _waitTime = waitTime;
        });
      }
    } catch (e) {
      debugPrint('Error loading wait time: $e');
      if (mounted) {
        setState(() {
          _waitTime = '5 min';
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadServicesForBusiness(
    String businessId,
    double basePrice,
  ) async {
    return _laundryRepository.getBusinessServices(businessId, basePrice);
  }

  Future<void> _fetchMyVehicles() async {
    try {
      final vehicles = await _vehicleRepository.getMyVehicles();
      if (mounted) {
        setState(() {
          _myVehicles = vehicles;
          if (_myVehicles.isNotEmpty) {
            _selectedVehicle = _myVehicles.first;
          } else {
            _selectedVehicle = null;
          }
          _loadingVehicles = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
      if (mounted) {
        setState(() {
          _loadingVehicles = false;
        });
      }
    }
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
        return targetMinutes >= openMinutes && targetMinutes <= closeMinutes;
      } else {
        return targetMinutes >= openMinutes || targetMinutes <= closeMinutes;
      }
    } catch (_) {
      return true;
    }
  }

  static DateTime _getInitialDatePickerDate(LaundryItem laundry) {
    DateTime candidate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final bh = laundry.businessHours.firstWhere(
        (element) => element['diaDeLaSemana'] == candidate.weekday,
        orElse: () => <String, dynamic>{},
      );
      final bool esDescanso = bh['esDiaDescanso'] ?? false;
      if (!esDescanso) {
        final String? apertura = bh['horaApertura'];
        if (apertura != null) {
          try {
            final parts = apertura.split(':');
            if (parts.length >= 2) {
              return DateTime(
                candidate.year,
                candidate.month,
                candidate.day,
                int.parse(parts[0]),
                int.parse(parts[1]),
              );
            }
          } catch (_) {}
        }
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return DateTime.now();
  }

  void _showOrderCreatedSuccess(String orderId) {
    final displayId = orderId.length > 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId.toUpperCase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '¡Reserva creada con éxito! N° de Orden: $displayId. Sigue el estado en la sección de Reservas.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    context.go('/reservas');
  }

  String _getVehicleCategory() {
    if (_selectedVehicle != null) {
      return _selectedVehicle!.type;
    }
    return 'Sedan';
  }

  double _getServicePriceForCategory(Map<String, dynamic> service, String category) {
    final cat = category.trim().toLowerCase();
    double? price;

    double? readPositivePrice(String key) {
      final rawValue = service[key];
      if (rawValue is num) {
        final value = rawValue.toDouble();
        if (value > 0) {
          return value;
        }
      }
      return null;
    }

    if (cat == 'hatchback') {
      price = readPositivePrice('precioPequeno');
    } else if (cat == 'sedan') {
      price = readPositivePrice('precioMediano');
    } else if (cat == 'suv') {
      price = readPositivePrice('precioGrande');
    } else if (cat == 'moto') {
      price = readPositivePrice('precioMoto');
    }

    price ??= readPositivePrice('precioBase');
    price ??= readPositivePrice('precio');
    price ??= readPositivePrice('costo');

    if (price == null || price == 0.0) {
      price = 0.0;
    }
    return price;
  }



  @override
  Widget build(BuildContext context) {
    final laundry = widget.laundry;
    final bool currentlyOpen = _isValidBusinessDateTime(laundry, DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          laundry.name,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error al cargar servicios: ${snapshot.error}',
                  style: GoogleFonts.inter(color: AppColors.error),
                ),
              ),
            );
          }

          final servicesList = snapshot.data ?? [];
          if (_selectedService == null && servicesList.isNotEmpty) {
            _selectedService = servicesList.first;
          }

          final currentPrice = _selectedService != null
              ? _getServicePriceForCategory(_selectedService!, _getVehicleCategory())
              : laundry.price;
              final currentCosto = currentPrice;
          final currentName = _selectedService?['nombre'] ?? 'Servicio';
          final currentTipo = _selectedService?['tipo'] ?? 'LOCAL';

          final bool isScheduleValid = _scheduleNow ||
              (_selectedTimeSlot != null &&
                  _isValidBusinessDateTime(laundry, _selectedTimeSlot!));

          final bool canConfirm = _selectedService != null &&
              _selectedVehicle != null &&
              ((_scheduleNow && currentlyOpen) || (!_scheduleNow && isScheduleValid));

          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Visual
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: laundry.isEco
                                        ? Colors.green.shade50
                                        : AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.local_laundry_service_rounded,
                                    color: laundry.isEco
                                        ? Colors.green.shade700
                                        : AppColors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        laundry.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            laundry.type,
                                            style: GoogleFonts.inter(
                                              color: AppColors.textSecondary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              color: AppColors.textSecondary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Text(
                                            currentlyOpen ? 'Abierto' : 'Cerrado',
                                            style: GoogleFonts.inter(
                                              color: currentlyOpen ? Colors.green.shade700 : Colors.red.shade700,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (laundry.isEco) ...[
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: const BoxDecoration(
                                                color: AppColors.textSecondary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.eco_rounded, color: Colors.green, size: 14),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Eco',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.green.shade700,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _buildDetailBadge(
                                  icon: Icons.star_rounded,
                                  color: Colors.amber,
                                  title: 'CALIFICACIÓN',
                                  value: widget.laundry.rating == 0.0
                                      ? 'Nuevo'
                                      : '${widget.laundry.rating.toStringAsFixed(1)} (${widget.laundry.reviewsCount})',
                                ),
                                const SizedBox(width: 12),
                                _buildDetailBadge(
                                  icon: Icons.access_time_filled_rounded,
                                  color: AppColors.primary,
                                  title: 'ESPERA ESTIMADA',
                                  value: _waitTime ?? 'Cargando...',
                                ),
                                const SizedBox(width: 12),
                                _buildDetailBadge(
                                  icon: Icons.directions_car_filled_rounded,
                                  color: AppColors.info,
                                  title: 'DISTANCIA',
                                  value: widget.laundry.distance,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24),

                      // Closed Warning Alert (if applicable)
                      if (!currentlyOpen) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Local Cerrado en este momento',
                                        style: GoogleFonts.inter(
                                          color: Colors.red.shade900,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Puedes programar tu turno para más tarde o para otro día laborable en la sección de programación de abajo.',
                                        style: GoogleFonts.inter(
                                          color: Colors.red.shade800,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Horario de Atención
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text(
                              'HORARIO DE ATENCIÓN',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: laundry.businessHours.isEmpty
                                    ? Text(
                                        'Horario no configurado por el local.',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    : Column(
                                        children: List.generate(7, (index) {
                                          final weekday = index + 1;
                                          const diasSemana = {
                                            1: 'Lunes',
                                            2: 'Martes',
                                            3: 'Miércoles',
                                            4: 'Jueves',
                                            5: 'Viernes',
                                            6: 'Sábado',
                                            7: 'Domingo',
                                          };
                                          final dayName = diasSemana[weekday] ?? '';

                                          final bh = laundry.businessHours.firstWhere(
                                            (element) => element['diaDeLaSemana'] == weekday,
                                            orElse: () => <String, dynamic>{},
                                          );

                                          final bool esDescanso = bh['esDiaDescanso'] ?? true;
                                          final String? apertura = bh['horaApertura'];
                                          final String? cierre = bh['horaCierre'];
                                          final isToday = DateTime.now().weekday == weekday;

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  dayName,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                                    color: isToday ? AppColors.primary : AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  esDescanso
                                                      ? 'Descanso / Cerrado'
                                                      : (apertura != null && cierre != null && apertura == cierre)
                                                          ? '24 Horas'
                                                          : '${apertura ?? "08:00"} - ${cierre ?? "18:00"}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                                    color: esDescanso
                                                        ? Colors.red.shade600
                                                        : (isToday ? AppColors.primary : AppColors.textSecondary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 32, thickness: 1, indent: 24, endIndent: 24),

                      // Selecciona tu Vehículo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'SELECCIONA TU VEHÍCULO',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _loadingVehicles
                                ? const Center(child: CircularProgressIndicator())
                                : _myVehicles.isEmpty
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.red.shade100, width: 1.5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Necesitas registrar un vehículo para poder agendar tu turno.',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.red.shade800,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                VehicleDialogs.showAddVehicleDialog(
                                                  context,
                                                  _fetchMyVehicles,
                                                );
                                              },
                                              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                              label: Text(
                                                'Añadir Vehículo',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<VehicleItem>(
                                                value: _selectedVehicle,
                                                isExpanded: true,
                                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                                borderRadius: BorderRadius.circular(16),
                                                style: GoogleFonts.inter(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 14,
                                                ),
                                                items: _myVehicles.map((car) {
                                                  return DropdownMenuItem<VehicleItem>(
                                                    value: car,
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.directions_car_rounded, color: AppColors.textSecondary, size: 20),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                          '${car.brandModel} (${car.plate})',
                                                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (VehicleItem? val) {
                                                  if (val != null) {
                                                    setState(() {
                                                      _selectedVehicle = val;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.info_outline_rounded,
                                                  size: 14,
                                                  color: AppColors.primary,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    'El precio se ajusta de acuerdo a tu vehículo (${_getVehicleCategory()})',
                                                    style: GoogleFonts.inter(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ),

                      const Divider(height: 32, thickness: 1, indent: 24, endIndent: 24),

                      // Servicios Disponibles
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'SERVICIOS DISPONIBLES',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (servicesList.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'este local aun no tiene servicios',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      else
                        Container(
                          constraints: const BoxConstraints(maxHeight: 320),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(12),
                              itemCount: servicesList.length,
                              itemBuilder: (context, index) {
                                final service = servicesList[index];
                                final isSelected = _selectedService == service;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedService = service;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : Colors.grey.shade200,
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? AppColors.primary.withValues(alpha: 0.08)
                                              : Colors.black.withValues(alpha: 0.02),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryLight
                                                : Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            service['tipo'] == 'DOMICILIO'
                                                ? Icons.delivery_dining_rounded
                                                : Icons.local_car_wash_rounded,
                                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                service['nombre'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${service['duracionMinutos']} min • ${service['tipo'] == 'LOCAL' ? 'En Local' : 'A Domicilio'}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '\$${_getServicePriceForCategory(service, _selectedVehicle?.type ?? 'Sedan').toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              _showServiceDetailsSheet(service);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.info_outline_rounded,
                                                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      const Divider(height: 32, thickness: 1, indent: 24, endIndent: 24),

                      // Programación
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'PROGRAMACIÓN DE ATENCIÓN',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _loadingReservationConfig
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : (_reservationConfig == null || !_reservationConfig!.isConfigured)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.amber.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, color: Colors.amber.shade800, size: 24),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Este establecimiento no permite programar citas anticipadas en este momento. Las reservas son solo para atención inmediata.',
                                            style: GoogleFonts.inter(
                                              color: Colors.amber.shade900,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: currentlyOpen
                                                  ? () {
                                                      setState(() {
                                                         _scheduleNow = true;
                                                         _selectedTimeSlot = null;
                                                         _selectedScheduleDateTime = null;
                                                       });
                                                    }
                                                  : null,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                decoration: BoxDecoration(
                                                  color: _scheduleNow && currentlyOpen
                                                      ? AppColors.primary.withValues(alpha: 0.08)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: !currentlyOpen
                                                        ? Colors.grey.shade200
                                                        : (_scheduleNow
                                                            ? AppColors.primary
                                                            : Colors.grey.shade300),
                                                    width: _scheduleNow && currentlyOpen ? 2 : 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.02),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.flash_on_rounded,
                                                      color: !currentlyOpen
                                                          ? Colors.grey.shade300
                                                          : (_scheduleNow ? AppColors.primary : Colors.grey),
                                                      size: 24,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      'Ahora mismo',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                        color: !currentlyOpen
                                                            ? Colors.grey.shade400
                                                            : (_scheduleNow
                                                                ? AppColors.primary
                                                                : AppColors.textSecondary),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                   _scheduleNow = false;
                                                   _selectedDate = DateTime.now();
                                                   _selectedTimeSlot = null;
                                                   _selectedScheduleDateTime = null;
                                                 });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                decoration: BoxDecoration(
                                                  color: !_scheduleNow
                                                      ? AppColors.primary.withValues(alpha: 0.08)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: !_scheduleNow ? AppColors.primary : Colors.grey.shade300,
                                                    width: !_scheduleNow ? 2 : 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.02),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today_rounded,
                                                      color: !_scheduleNow ? AppColors.primary : Colors.grey,
                                                      size: 24,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      'Programar',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                        color: !_scheduleNow ? AppColors.primary : AppColors.textSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!_scheduleNow) ...[
                                      const SizedBox(height: 16),
                                      _buildDaysSelector(),
                                      const SizedBox(height: 16),
                                      _buildSlotsGrid(_generateSlotsForSelectedDate()),
                                    ],
                                  ],
                                ),


                    ],
                  ),
                ),
              ),

              // Botón inferior sticky con Resumen
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'TOTAL',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${currentPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: canConfirm
                                  ? () => _navigateToPayment(
                                        currentName: currentName,
                                        currentPrice: currentPrice,
                                        currentCosto: currentCosto,
                                        currentTipo: currentTipo,
                                      )
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey.shade200,
                                disabledForegroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Agendar turno',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _loadReservationData() async {
    try {
      final config = await _reservationConfigRepository.getConfig(widget.laundry.id);
      final reservations = await _reservationMetadataRepository.getActiveReservations(widget.laundry.id);
      if (mounted) {
        setState(() {
          _reservationConfig = config;
          _activeReservations = reservations;
          _loadingReservationConfig = false;
          
          if (config == null || !config.isConfigured) {
            _scheduleNow = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading reservation data: $e');
      if (mounted) {
        setState(() {
          _loadingReservationConfig = false;
        });
      }
    }
  }

  List<DateTime> _generateSlotsForSelectedDate() {
    if (_reservationConfig == null) return [];
    return AvailabilityService.generateSlots(
      date: _selectedDate,
      businessHours: widget.laundry.businessHours.cast<Map<String, dynamic>>(),
      anticipationMinutes: _reservationConfig!.tiempoAnticipacionMinutos,
    );
  }

  bool _isSlotAvailable(DateTime slot) {
    if (_reservationConfig == null) return false;
    final duration = _selectedService != null
        ? (_selectedService!['duracionMinutos'] as num?)?.toInt() ?? 30
        : 30;
    return AvailabilityService.isSlotAvailable(
      slot: slot,
      durationMinutes: duration,
      capacity: _reservationConfig!.capacidadSimultanea,
      activeReservations: _activeReservations,
    );
  }

  Widget _buildDaysSelector() {
    final today = DateTime.now();
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = today.add(Duration(days: index));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          final dayName = index == 0
              ? 'Hoy'
              : index == 1
                  ? 'Mañana'
                  : _getDayName(date.weekday);
          final dayNumber = date.day.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                  _selectedTimeSlot = null;
                  _selectedScheduleDateTime = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayNumber,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    const names = {
      1: 'Lun',
      2: 'Mar',
      3: 'Mié',
      4: 'Jue',
      5: 'Vie',
      6: 'Sáb',
      7: 'Dom',
    };
    return names[weekday] ?? '';
  }

  Widget _buildSlotsGrid(List<DateTime> slots) {
    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'No hay horarios disponibles para esta fecha.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: slots.map((slot) {
          final isAvailable = _isSlotAvailable(slot);
          final isSelected = _selectedTimeSlot != null &&
              _selectedTimeSlot!.year == slot.year &&
              _selectedTimeSlot!.month == slot.month &&
              _selectedTimeSlot!.day == slot.day &&
              _selectedTimeSlot!.hour == slot.hour &&
              _selectedTimeSlot!.minute == slot.minute;

          final timeStr = '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}';

          return GestureDetector(
            onTap: isAvailable
                ? () {
                    setState(() {
                      _selectedTimeSlot = slot;
                      _selectedScheduleDateTime = slot;
                    });
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : isAvailable
                        ? Colors.white
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : isAvailable
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: Text(
                timeStr,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  decoration: isAvailable ? null : TextDecoration.lineThrough,
                  color: isSelected
                      ? Colors.white
                      : isAvailable
                          ? AppColors.primary
                          : Colors.grey.shade400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAlternativeSlotsDialog(List<DateTime> suggestions) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Horario no disponible',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'El horario que elegiste se ha llenado. Te sugerimos las siguientes alternativas disponibles:',
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (suggestions.isEmpty)
                Text(
                  'No hay horarios alternativos disponibles en los próximos días.',
                  style: GoogleFonts.inter(fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                )
              else
                ...suggestions.map((suggestion) {
                  final dateStr = '${suggestion.day.toString().padLeft(2, '0')}/${suggestion.month.toString().padLeft(2, '0')}';
                  final timeStr = '${suggestion.hour.toString().padLeft(2, '0')}:${suggestion.minute.toString().padLeft(2, '0')}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedScheduleDateTime = suggestion;
                          _selectedTimeSlot = suggestion;
                          _selectedDate = DateTime(suggestion.year, suggestion.month, suggestion.day);
                        });
                        Navigator.pop(dialogContext);
                        _navigateToPayment(
                          currentName: _selectedService?['nombre'] ?? 'Servicio',
                          currentPrice: _getServicePriceForCategory(
                            _selectedService ?? {},
                            _selectedVehicle?.type ?? 'Sedan',
                          ),
                          currentCosto: _getServicePriceForCategory(
                            _selectedService ?? {},
                            _selectedVehicle?.type ?? 'Sedan',
                          ),
                          currentTipo: _selectedService?['tipo'] ?? 'LOCAL',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$dateStr a las $timeStr',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showServiceDetailsSheet(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isSelected = _selectedService == service;
        final name = service['nombre'] ?? '';
        final price = _getServicePriceForCategory(service, _selectedVehicle?.type ?? 'Sedan');
        final duration = service['duracionMinutos'] ?? 0;
        final type = service['tipo'] ?? 'LOCAL';
        final description = service['descripcion'] ?? 'Sin descripción disponible.';

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pull handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        type == 'DOMICILIO'
                            ? Icons.delivery_dining_rounded
                            : Icons.local_car_wash_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            type == 'LOCAL' ? 'Servicio en Local' : 'Servicio a Domicilio',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Price and Duration Info Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRECIO',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DURACIÓN',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$duration min',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'DESCRIPCIÓN',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Action Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedService = service;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.green.shade600 : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isSelected ? 'Servicio Seleccionado' : 'Seleccionar Servicio',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPayment({
    required String currentName,
    required double currentPrice,
    required double currentCosto,
    required String currentTipo,
  }) async {
    final OrderType serviceType = currentTipo == 'DOMICILIO' ? OrderType.DELIVERY : OrderType.LOCAL;

    if (!_scheduleNow) {
      if (_selectedScheduleDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, selecciona un horario para tu reserva.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final activeReservations = await _reservationMetadataRepository.getActiveReservations(widget.laundry.id);
        
        if (mounted) {
          Navigator.pop(context);
        }

        final duration = _selectedService != null
            ? (_selectedService!['duracionMinutos'] as num?)?.toInt() ?? 30
            : 30;
        final capacity = _reservationConfig?.capacidadSimultanea ?? 1;

        final isAvailable = AvailabilityService.isSlotAvailable(
          slot: _selectedScheduleDateTime!,
          durationMinutes: duration,
          capacity: capacity,
          activeReservations: activeReservations,
        );

        if (!isAvailable) {
          final suggestions = AvailabilityService.getSuggestions(
            requested: _selectedScheduleDateTime!,
            durationMinutes: duration,
            capacity: capacity,
            activeReservations: activeReservations,
            businessHours: widget.laundry.businessHours.cast<Map<String, dynamic>>(),
            anticipationMinutes: _reservationConfig?.tiempoAnticipacionMinutos ?? 0,
          );

          if (mounted) {
            _showAlternativeSlotsDialog(suggestions);
          }
          return;
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al verificar disponibilidad: $e')),
          );
        }
        return;
      }
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => PaymentSelectionPage(
          laundry: widget.laundry,
          serviceName: currentName,
          servicePrice: currentPrice,
          serviceType: serviceType,
          selectedVehicle: _selectedVehicle,
          scheduleNow: _scheduleNow,
          scheduledDateTime: _selectedScheduleDateTime,
          serviceDuration: _selectedService != null
              ? (_selectedService!['duracionMinutos'] as num?)?.toInt() ?? 30
              : 30,
          onPaymentCompleted: (paymentMethod) async {
            String businessId = widget.laundry.id;
            if (businessId.startsWith('fallback_')) {
              LaundryItem? realBiz;
              for (final b in widget.allLaundries) {
                if (!b.id.startsWith('fallback_')) {
                  realBiz = b;
                  break;
                }
              }
              if (realBiz != null) {
                businessId = realBiz.id;
              } else {
                const defaultBizId = '00000000-0000-0000-0000-000000000001';
                try {
                  await _laundryRepository.createFallbackBusiness(
                    defaultBizId,
                    widget.laundry.name,
                  );
                } catch (_) {}
                businessId = defaultBizId;
              }
            }

            final now = DateTime.now();
            final actualScheduleNow = _scheduleNow;
            final dateToUse = actualScheduleNow ? now : _selectedScheduleDateTime!;
            final day = dateToUse.day.toString().padLeft(2, '0');
            final month = dateToUse.month.toString().padLeft(2, '0');
            final year = dateToUse.year;
            final hour = dateToUse.hour.toString().padLeft(2, '0');
            final minute = dateToUse.minute.toString().padLeft(2, '0');
            final dateStr = '$day/$month/$year $hour:$minute';

            final schedulePrefix = actualScheduleNow ? 'Ahora mismo ($dateStr)' : 'Programado ($dateStr)';

            String obs = '$schedulePrefix - Vehículo: ';
            if (_selectedVehicle != null) {
              obs += _selectedVehicle!.brandModel;
              if (_selectedVehicle!.plate.isNotEmpty) {
                obs += ' - Placa: ${_selectedVehicle!.plate}';
              }
            } else {
              obs += 'Toyota Corolla';
            }

            final result = await _orderRepository.createOrder(
              businessId: businessId,
              price: currentPrice,
              costo: currentCosto,
              serviceName: currentName,
              type: serviceType,
              paymentMethod: paymentMethod,
              observations: obs,
            );

            if (!actualScheduleNow) {
              final duration = _selectedService != null
                  ? (_selectedService!['duracionMinutos'] as num?)?.toInt() ?? 30
                  : 30;

              final reservation = OrderReservation(
                orderId: result,
                businessId: businessId,
                scheduledAt: _selectedScheduleDateTime!,
                serviceDurationMinutos: duration,
                serviceId: _selectedService?['id'] ?? '',
                createdAt: DateTime.now(),
              );

              try {
                await _reservationMetadataRepository.createReservation(reservation);
              } catch (e) {
                debugPrint('Error saving reservation metadata: $e');
              }
            }

            if (!routeContext.mounted) return;

            Navigator.pop(routeContext);

            if (mounted) {
              Navigator.pop(context);
            }

            final orderId = result;
            _showOrderCreatedSuccess(orderId);
          },
        ),
      ),
    );
  }

  Widget _buildDetailBadge({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
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
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

