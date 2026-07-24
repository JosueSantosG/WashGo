import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart'
    hide PaymentProofStatus;
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/features/dashboard/client/pages/laundry_booking_page.dart';
import 'package:washgo/features/dashboard/client/widgets/tabs/bookings_tab.dart';
import 'package:washgo/features/dashboard/client/widgets/tabs/profile_tab.dart';
import 'package:washgo/features/invoices/pages/client_invoice_history_page.dart';
import 'package:washgo/core/session/booking_intent_manager.dart';

import 'package:washgo/features/auth/models/washgo_user.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/features/laundries/repositories/laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_business_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_reservation_config_repository.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/features/orders/widgets/reschedule_slots_sheet.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({super.key, this.initialTab = 0});

  // Global static cache to persist user location across page destructions (route switches)
  static LatLng? cachedUserLocation;
  static bool hasLockedInitialLocation = false;
  static List<LaundryItem> cachedLaundries = [];
  static Map<String, gmaps.BitmapDescriptor> cachedMarkerIcons = {};
  static gmaps.BitmapDescriptor? cachedUserDotIcon;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  gmaps.GoogleMapController? _googleMapController;
  bool _isAnimatingToPage = false;
  int _selectedIndex = 0;
  PageController _pageController = PageController(viewportFraction: 0.85);
  AnimationController? _mapAnimationController;

  // Dynamic user location initialized with global cache or Guayaquil center fallback
  LatLng _userLocation =
      HomePage.cachedUserLocation ?? const LatLng(-2.1961601, -79.8862076);
  bool _isFirstLocationLock = !HomePage.hasLockedInitialLocation;
  StreamSubscription<Position>? _positionSubscription;

  final AuthRepository _authRepository = FirebaseAuthRepository();
  final LaundryRepository _laundryRepository = FirebaseLaundryRepository();
  final OrderRepository _orderRepository = FirebaseOrderRepository();

  List<LaundryItem> _allLaundries = List<LaundryItem>.from(HomePage.cachedLaundries);
  List<LaundryItem> _filteredLaundries = List<LaundryItem>.from(HomePage.cachedLaundries);
  List<LaundryItem> _carouselLaundries = [];
  int? _activeCarouselIndex;
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<UserRole> _userRoles = [];
  WashGoUser? _washGoUser;
  bool _isRolesLoading = true;
  List<ClientOrder> _clientOrders = [];
  bool _loadingOrders = false;
  StreamSubscription<List<ClientOrder>>? _ordersSubscription;
  StreamSubscription<User?>? _authStateSubscription;

  bool _showFilterPanel = false;
  final bool _filterEcoOnly = false;
  final bool _filterOpenOnly = false;
  final String _sortBy = 'distance'; // distance, price, rating

  // Continue booking banner state
  bool _showContinueBanner = false;

  // Map category filters
  final List<String> _categories = [
    'Todos',
    'Cerca 📍',
    'Económico 💰',
  ];

  void _subscribeToClientOrders() {
    _ordersSubscription?.cancel();
    if (FirebaseAuth.instance.currentUser == null) {
      if (mounted) {
        setState(() {
          _clientOrders = [];
          _loadingOrders = false;
        });
      }
      return;
    }
    _ordersSubscription = _orderRepository.watchClientOrders().listen(
      (orders) {
        if (mounted) {
          setState(() {
            _clientOrders = orders;
            _loadingOrders = false;
          });
        }
      },
      onError: (error) {
        debugPrint('Error subscribing to client orders: $error');
      },
    );
  }

  Future<void> _fetchClientOrders() async {
    if (!mounted) return;
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        _clientOrders = [];
        _loadingOrders = false;
      });
      return;
    }
    setState(() {
      _loadingOrders = true;
    });
    try {
      final orders = await _orderRepository.getClientOrders();
      if (mounted) {
        setState(() {
          _clientOrders = orders;
          _loadingOrders = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching client orders: $e');
      if (mounted) {
        setState(() {
          _loadingOrders = false;
        });
      }
    }
  }

  Future<void> _cancelOrder(BuildContext context, ClientOrder order) async {
    bool isPaid =
        order.paymentMethod != 'CASH' && order.status != 'PENDIENTE_PAGO';

    if (order.paymentMethod == 'TRANSFERENCIA_BANCARIA') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
      try {
        final proof = await BankTransferRepository().getProofStatus(order.id);
        isPaid = proof != null && proof.status == PaymentProofStatus.APPROVED;
      } catch (e) {
        isPaid = false;
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    if (!context.mounted) return;

    bool shouldProceedWithCancellation = false;

    if (isPaid) {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Aviso Importante',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta reserva ya cuenta con un pago realizado.',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Si cancelas esta reserva, no habrá reembolso de tu dinero.\n\nTe recomendamos reprogramar o cambiar de horario en lugar de cancelar.',
                style: GoogleFonts.inter(),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, 'reschedule'),
                  icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                  label: Text(
                    'Postergar / Cambiar horario',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, 'keep'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: AppColors.outline),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'No, mantener',
                          style: GoogleFonts.inter(color: AppColors.outline),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, 'cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Cancelar de todas formas',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      if (result == 'reschedule') {
        if (!context.mounted) return;
        _rescheduleOrder(context, order);
        return;
      }

      if (result == 'cancel') {
        shouldProceedWithCancellation = true;
      }
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Cancelar Reserva',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            '¿Estás seguro de que deseas cancelar esta reserva? Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No, mantener',
                style: GoogleFonts.inter(color: AppColors.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Sí, cancelar',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        shouldProceedWithCancellation = true;
      }
    }

    if (shouldProceedWithCancellation) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );

      try {
        await _orderRepository.updateOrderStatus(
          orderId: order.id,
          status: OrderStatus.CANCELADO,
          cancellationReason: 'Cancelado por el cliente',
        );
        if (!context.mounted) return;
        Navigator.pop(context);

        await _fetchClientOrders();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reserva cancelada exitosamente.',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al cancelar la reserva: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _rescheduleOrder(BuildContext context, ClientOrder order) async {
    final parsed = ParsedObservations.parse(order.observations);

    // Show loading indicator while fetching configurations
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );

    List<Map<String, dynamic>> businessHours;
    int anticipationMinutes = 0;

    try {
      final businessRepo = FirebaseBusinessRepository();
      final configRepo = FirebaseReservationConfigRepository();

      businessHours = await businessRepo.getBusinessHours(order.businessId);
      final config = await configRepo.getConfig(order.businessId);
      if (config != null) {
        anticipationMinutes = config.tiempoAnticipacionMinutos;
      }

      if (!context.mounted) return;
      Navigator.pop(context); // Pop loading dialog
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Pop loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al obtener horarios del local: $e',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!context.mounted) return;

    final selectedDateTime = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RescheduleSlotsSheet(
        businessHours: businessHours,
        anticipationMinutes: anticipationMinutes,
      ),
    );

    if (selectedDateTime == null) return;

    final day = selectedDateTime.day.toString().padLeft(2, '0');
    final month = selectedDateTime.month.toString().padLeft(2, '0');
    final year = selectedDateTime.year.toString();
    final hour = selectedDateTime.hour.toString().padLeft(2, '0');
    final minute = selectedDateTime.minute.toString().padLeft(2, '0');
    final rescheduledDateTime = '$day/$month/$year $hour:$minute';

    final currentHistory = parsed.rescheduleHistory;
    final List<String> updatedHistory = List.from(currentHistory);
    updatedHistory.add(parsed.dateTime);

    final newObservations =
        'Programado ($rescheduledDateTime) - Vehículo: ${parsed.vehicleDetails} | Historial: ${updatedHistory.join(' -> ')}';

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Postergar Cita',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Desea cambiar la fecha y hora de la cita a:\n\n📅 $day/$month/$year a las ⏰ $hour:$minute?',
          style: GoogleFonts.inter(fontSize: 15, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: AppColors.outline),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Confirmar',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );

      try {
        await _orderRepository.rescheduleOrder(
          orderId: order.id,
          observations: newObservations,
        );
        if (!context.mounted) return;
        Navigator.pop(context);

        await _fetchClientOrders();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cita postergada exitosamente.',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al postergar la cita: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri.parse('whatsapp://send?phone=$formattedPhone');
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        final Uri webUri = Uri.parse('https://wa.me/$formattedPhone');
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {}
  }

  final Map<String, gmaps.BitmapDescriptor> _customMarkerCache =
      Map<String, gmaps.BitmapDescriptor>.from(HomePage.cachedMarkerIcons);
  gmaps.BitmapDescriptor? _userLocationDotIcon = HomePage.cachedUserDotIcon;

  Future<void> _initCustomMarkerIcons() async {
    if (HomePage.cachedUserDotIcon != null && HomePage.cachedMarkerIcons.isNotEmpty) {
      _userLocationDotIcon = HomePage.cachedUserDotIcon;
      _customMarkerCache.addAll(HomePage.cachedMarkerIcons);
      if (mounted) setState(() {});
      return;
    }

    _userLocationDotIcon = await _createUserLocationDotBitmap();
    HomePage.cachedUserDotIcon = _userLocationDotIcon;

    final configs = [
      {'isOpen': true, 'isEco': false, 'isSelected': false},
      {'isOpen': true, 'isEco': true, 'isSelected': false},
      {'isOpen': false, 'isEco': false, 'isSelected': false},
      {'isOpen': false, 'isEco': true, 'isSelected': false},
      {'isOpen': true, 'isEco': false, 'isSelected': true},
      {'isOpen': true, 'isEco': true, 'isSelected': true},
      {'isOpen': false, 'isEco': false, 'isSelected': true},
      {'isOpen': false, 'isEco': true, 'isSelected': true},
    ];

    for (final cfg in configs) {
      final isOpen = cfg['isOpen'] as bool;
      final isEco = cfg['isEco'] as bool;
      final isSelected = cfg['isSelected'] as bool;
      final key = '${isOpen}_${isEco}_$isSelected';

      final descriptor = await _createCustomMarkerBitmap(
        isOpen: isOpen,
        isEco: isEco,
        isSelected: isSelected,
      );
      _customMarkerCache[key] = descriptor;
    }
    HomePage.cachedMarkerIcons = Map.from(_customMarkerCache);
    if (mounted) {
      setState(() {});
    }
  }

  Future<gmaps.BitmapDescriptor> _createUserLocationDotBitmap() async {
    const size = 32;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final double radius = size / 2.0;

    // Translucent aura
    final auraPaint = Paint()
      ..color = const Color(0xFF007BFF).withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius - 1, auraPaint);

    // White ring
    final whiteRingPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius - 7, whiteRingPaint);

    // Inner blue core
    final corePaint = Paint()
      ..color = const Color(0xFF007BFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius - 9, corePaint);

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return gmaps.BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Future<gmaps.BitmapDescriptor> _createCustomMarkerBitmap({
    required bool isOpen,
    required bool isEco,
    required bool isSelected,
  }) async {
    final size = isSelected ? 80 : 60;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final double radius = size / 2.0;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(radius, radius + 2), radius - 4, shadowPaint);

    // Background circle
    final bgPaint = Paint()
      ..color = isSelected
          ? (isOpen ? AppColors.primary : Colors.grey.shade800)
          : (isOpen ? Colors.white : Colors.grey.shade200)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius - 6, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = isSelected
          ? Colors.white
          : (isOpen
                ? (isEco ? const Color(0xFF16A34A) : AppColors.primary)
                : Colors.grey.shade400)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3.5 : 2.2;
    canvas.drawCircle(Offset(radius, radius), radius - 6, borderPaint);

    // Icon (Eco leaf or Car wash icon - perfectly proportioned at 48% of circle diameter)
    final iconData = isEco ? Icons.eco_rounded : Icons.local_car_wash_rounded;
    final double iconSize = size * 0.48;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: isSelected
            ? Colors.white
            : (isOpen
                  ? (isEco ? const Color(0xFF16A34A) : AppColors.primary)
                  : Colors.grey.shade500),
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - (textPainter.width / 2.0),
        radius - (textPainter.height / 2.0),
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return gmaps.BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  gmaps.BitmapDescriptor _getMarkerIcon(LaundryItem item, bool isSelected) {
    final key = '${item.isOpen}_${item.isEco}_$isSelected';
    try {
      if (_customMarkerCache.containsKey(key)) {
        return _customMarkerCache[key]!;
      }
    } catch (_) {}
    return gmaps.BitmapDescriptor.defaultMarkerWithHue(
      isSelected
          ? gmaps.BitmapDescriptor.hueRed
          : (item.isOpen
                ? gmaps.BitmapDescriptor.hueAzure
                : gmaps.BitmapDescriptor.hueOrange),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _filteredLaundries = List.from(_allLaundries);
    _initCustomMarkerIcons();
    _initLocationTracking();
    _fetchSavedBusinesses();

    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) {
      if (user != null) {
        _loadCurrentUser();
        _subscribeToClientOrders();
      } else {
        BookingIntentManager.instance.clearIntent();
        BookingIntentManager.instance.clearPendingPaymentIntent();
        if (mounted) {
          setState(() {
            _showContinueBanner = false;
            _washGoUser = null;
            _userRoles = [];
            _clientOrders = [];
            _isRolesLoading = false;
          });
        }
        _ordersSubscription?.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      setState(() {
        _selectedIndex = widget.initialTab;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _positionSubscription?.cancel();
    _ordersSubscription?.cancel();
    _authStateSubscription?.cancel();
    _mapAnimationController?.dispose();
    _googleMapController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return;
      }

      // Attempt to immediately load last known position to make it instant (isolated try-catch as it's unsupported on web)
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null &&
            HomePage.cachedUserLocation == null &&
            mounted) {
          setState(() {
            _userLocation = LatLng(lastKnown.latitude, lastKnown.longitude);
            HomePage.cachedUserLocation = _userLocation;
          });
          if (_isFirstLocationLock) {
            _isFirstLocationLock = false;
            HomePage.hasLockedInitialLocation = true;
            _animatedMapMove(_userLocation, 15.0);
          }
        }
      } catch (e) {
        debugPrint(
          'getLastKnownPosition is not supported or failed on this platform: $e',
        );
      }

      // Always fetch businesses immediately with available/cached location
      if (mounted) {
        _fetchSavedBusinesses();
      }

      // Initial quick location lock
      try {
        final initialPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        ).timeout(const Duration(seconds: 5));

        if (mounted) {
          final newLoc = LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          );
          setState(() {
            _userLocation = newLoc;
            HomePage.cachedUserLocation = _userLocation;
          });
          _animatedMapMove(_userLocation, 15.0);
          _recalculateDistances();
        }
      } catch (e) {
        debugPrint('getCurrentPosition fallback or waiting stream: $e');
      }

      // Continuous tracking subscription (triggers as soon as user grants Chrome permission)
      try {
        _positionSubscription =
            Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
              ),
            ).listen((Position position) {
              if (mounted) {
                final freshLoc = LatLng(position.latitude, position.longitude);
                final shouldMove = _isFirstLocationLock;
                if (shouldMove) {
                  _isFirstLocationLock = false;
                  HomePage.hasLockedInitialLocation = true;
                }
                setState(() {
                  _userLocation = freshLoc;
                  HomePage.cachedUserLocation = _userLocation;
                });
                if (shouldMove) {
                  _animatedMapMove(freshLoc, 15.0);
                }
                _recalculateDistances();
              }
            });
      } catch (e) {
        debugPrint('getPositionStream failed: $e');
      }
    } catch (e) {
      debugPrint('Error initializing location tracking: $e');
    }
  }

  Future<void> _fetchSavedBusinesses() async {
    try {
      final List<LaundryItem> dynamicList =
          await _laundryRepository.getLaundries(_userLocation);
      HomePage.cachedLaundries = List<LaundryItem>.from(dynamicList);
      if (mounted) {
        setState(() {
          _allLaundries = List<LaundryItem>.from(dynamicList);
          _filterLaundries();
        });
        _checkPendingBookingIntent();
      }
    } catch (e) {
      debugPrint('Error fetching businesses: $e');
    }
  }

  void _checkPendingBookingIntent() {
    final intent = BookingIntentManager.instance.getIntent();
    if (intent == null || !mounted) return;

    // Don't clear here — LaundryBookingPage's _restoreBookingIntentIfNeeded
    // or _autoSelectVehicleFromIntent will consume and clear it from initState

    // Find the matching laundry in our loaded list
    final matchingLaundry = _allLaundries.cast<LaundryItem?>().firstWhere(
      (l) => l!.id == intent.laundryId,
      orElse: () => null,
    );

    if (matchingLaundry == null) {
      // Laundry not found — show banner and dialog
      setState(() {
        _showContinueBanner = true;
      });
      _showLaundryNotFoundDialog(intent);
      return;
    }

    // Auto-navigate to the booking page where _restoreBookingIntentIfNeeded
    // will have already restored the selection from the intent
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaundryBookingPage(
          laundry: matchingLaundry,
          allLaundries: _allLaundries,
        ),
      ),
    );
  }

  void _showLaundryNotFoundDialog(BookingIntent intent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lavandería no disponible',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'La lavandería "${intent.laundryName}" de tu reserva pendiente ya no está disponible.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                BookingIntentManager.instance.clearIntent();
                setState(() {
                  _showContinueBanner = false;
                });
                Navigator.pop(dialogContext);
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
                'Entendido',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _recalculateDistances() {
    setState(() {
      _allLaundries = _allLaundries.map((laundry) {
        final double locLat = (laundry.location as dynamic).latitude as double;
        final double locLng = (laundry.location as dynamic).longitude as double;
        final distMeters = Geolocator.distanceBetween(
          _userLocation.latitude,
          _userLocation.longitude,
          locLat,
          locLng,
        );
        return LaundryItem(
          id: laundry.id,
          name: laundry.name,
          type: laundry.type,
          rating: laundry.rating,
          reviewsCount: laundry.reviewsCount,
          distance: _formatDistance(distMeters),
          distanceInMeters: distMeters,
          price: laundry.price,
          location: LatLng(locLat, locLng),
          isEco: laundry.isEco,
          isOpen: laundry.isOpen,
          waitTime: laundry.waitTime,
          phone: laundry.phone,
          businessHours: List<Map<String, dynamic>>.from(laundry.businessHours),
        );
      }).toList();
      _filterLaundries();
    });
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (mounted) {
        setState(() {
          _washGoUser = user;
          if (user != null) {
            _userRoles = user.roles;
          }
          _isRolesLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isRolesLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile({
    required String name,
    required String phone,
  }) async {
    final email =
        _washGoUser?.email ?? FirebaseAuth.instance.currentUser?.email ?? '';
    final roles = _washGoUser?.roles ?? _userRoles;
    final address = _washGoUser?.direccion;

    await _authRepository.upsertUser(
      nombreCompleto: name,
      email: email,
      roles: roles,
      telefono: phone,
      direccion: address,
    );
    await _loadCurrentUser();
  }

  Future<void> _deleteAccount() async {
    await _authRepository.deleteAccount();
  }

  void _updateCarouselFor(LaundryItem centerItem) {
    final sorted = List<LaundryItem>.from(_filteredLaundries);
    sorted.sort((a, b) {
      final distA = Geolocator.distanceBetween(
        centerItem.location.latitude,
        centerItem.location.longitude,
        a.location.latitude,
        a.location.longitude,
      );
      final distB = Geolocator.distanceBetween(
        centerItem.location.latitude,
        centerItem.location.longitude,
        b.location.latitude,
        b.location.longitude,
      );
      return distA.compareTo(distB);
    });

    _carouselLaundries = sorted.take(5).toList();
    _activeCarouselIndex = 0;
  }

  void _filterLaundries({bool resetCarousel = false}) {
    // Save the ID of the currently selected laundry, if any (only if not resetting carousel selection)
    final String? selectedLaundryId =
        (!resetCarousel &&
            _activeCarouselIndex != null &&
            _carouselLaundries.isNotEmpty)
        ? _carouselLaundries[_activeCarouselIndex!].id
        : null;

    setState(() {
      final query = _searchQuery.trim().toLowerCase();
      _filteredLaundries = _allLaundries.where((laundry) {
        final matchesSearch = query.isEmpty ||
            query.length < 3 ||
            laundry.name.toLowerCase().contains(query) ||
            laundry.type.toLowerCase().contains(query) ||
            laundry.phone.toLowerCase().contains(query);

        bool matchesCategory = true;
        final selectedLower = _selectedCategory.toLowerCase();

        if (selectedLower.contains('cerc') || selectedLower.contains('near')) {
          // Filter laundries within 3000 meters or top closest
          matchesCategory = laundry.distanceInMeters <= 3000;
        } else if (selectedLower.contains('econ') ||
            selectedLower.contains('cheap')) {
          // Filter laundries with price <= 15.00
          matchesCategory = laundry.price <= 15.00;
        }

        final matchesEco = !_filterEcoOnly || laundry.isEco;
        final matchesOpen = !_filterOpenOnly || laundry.isOpen;

        return matchesSearch && matchesCategory && matchesEco && matchesOpen;
      }).toList();

      // Sort matches
      if (_sortBy == 'distance') {
        _filteredLaundries.sort(
          (a, b) => a.distanceInMeters.compareTo(b.distanceInMeters),
        );
      } else if (_sortBy == 'price') {
        _filteredLaundries.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'rating') {
        _filteredLaundries.sort((a, b) => b.rating.compareTo(a.rating));
      }

      // Keep current selection if valid; otherwise clear selection so no local is selected
      if (_filteredLaundries.isNotEmpty && selectedLaundryId != null) {
        final centerItemIndex = _filteredLaundries.indexWhere(
          (laundry) => laundry.id == selectedLaundryId,
        );
        if (centerItemIndex != -1) {
          final centerItem = _filteredLaundries[centerItemIndex];
          _updateCarouselFor(centerItem);
          if (_pageController.hasClients) {
            _isAnimatingToPage = true;
            _pageController.jumpToPage(0);
            _isAnimatingToPage = false;
          }
        } else {
          _activeCarouselIndex = null;
          _carouselLaundries = [];
        }
      } else {
        _activeCarouselIndex = null;
        _carouselLaundries = [];
      }
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    _googleMapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngZoom(
        gmaps.LatLng(destLocation.latitude, destLocation.longitude),
        destZoom,
      ),
    );
  }

  void _animateToLaundry(LaundryItem laundry) {
    _animatedMapMove(laundry.location, 16.0);
  }

  Future<void> _openGoogleMapsRoute(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching navigation URL: $e');
    }
  }

  Widget _buildContinueBanner() {
    final intent = BookingIntentManager.instance.getIntent();
    if (intent == null) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black26,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restore_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Reserva pendiente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'En ${intent.laundryName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _fetchSavedBusinesses();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showContinueBanner = false;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Continue reservation banner
          if (_showContinueBanner && BookingIntentManager.instance.hasIntent())
            _buildContinueBanner(),

          // Dynamic screen transitions
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(user),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody(User? user) {
    switch (_selectedIndex) {
      case 0:
        return _buildMapSection();
      case 1:
        return BookingsTab(
          orders: _clientOrders,
          isLoading: _loadingOrders,
          onRefresh: _fetchClientOrders,
          onShowContactSuccessSnackBar: _showContactSuccessSnackBar,
          onMakePhoneCall: _makePhoneCall,
          onOpenWhatsApp: _openWhatsApp,
          onExplorePressed: () {
            context.go('/explore');
          },
          onCancelOrder: _cancelOrder,
          onRescheduleOrder: _rescheduleOrder,
          getQueuePosition: (businessId, orderId) => _orderRepository
              .getQueuePosition(businessId: businessId, orderId: orderId),
        );
      case 2:
        return const ClientInvoiceHistoryPage();
      case 3:
        return ProfileTab(
          user: user,
          washGoUser: _washGoUser,
          isRolesLoading: _isRolesLoading,
          userRoles: _userRoles.map((role) => role.name).toList(),
          onUpdateProfile: _updateProfile,
          onDeleteAccount: _deleteAccount,
          hasActiveReservations: _clientOrders.any(
            (order) =>
                order.status != 'COMPLETADO' && order.status != 'CANCELADO',
          ),
        );
      default:
        return _buildMapSection();
    }
  }

  Set<gmaps.Marker> _buildGoogleMarkers() {
    final Set<gmaps.Marker> markers = {};

    // User location blue dot marker
    if (_userLocationDotIcon != null) {
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('user_location_dot'),
          position: gmaps.LatLng(
            _userLocation.latitude,
            _userLocation.longitude,
          ),
          icon: _userLocationDotIcon!,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 999,
        ),
      );
    }



    for (final item in _filteredLaundries) {
      final isSelected =
          _activeCarouselIndex != null &&
          _carouselLaundries.isNotEmpty &&
          item.id == _carouselLaundries[_activeCarouselIndex!].id;

      markers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(item.id),
          position: gmaps.LatLng(
            item.location.latitude,
            item.location.longitude,
          ),
          icon: _getMarkerIcon(item, isSelected),
          onTap: () {
            final wasNull = _activeCarouselIndex == null;
            setState(() {
              _updateCarouselFor(item);
              if (wasNull) {
                _pageController.dispose();
                _pageController = PageController(
                  viewportFraction: 0.85,
                  initialPage: 0,
                );
              } else if (_pageController.hasClients) {
                _isAnimatingToPage = true;
                _pageController.jumpToPage(0);
                _isAnimatingToPage = false;
              }
            });
            _animateToLaundry(item);
          },
        ),
      );
    }

    return markers;
  }

  // ==========================================
  // 1. MAP SECTION (EXPLORAR)
  // ==========================================
  Widget _buildMapSection() {
    return Stack(
      key: const ValueKey('map_section'),
      children: [
        // Fullscreen Google Map
        Positioned.fill(
          child: gmaps.GoogleMap(
            initialCameraPosition: gmaps.CameraPosition(
              target: gmaps.LatLng(
                _userLocation.latitude,
                _userLocation.longitude,
              ),
              zoom: 15.0,
            ),
            onMapCreated: (controller) {
              _googleMapController = controller;
              _animatedMapMove(_userLocation, 15.0);
            },
            onTap: (point) {
              setState(() {
                _activeCarouselIndex = null;
                _showFilterPanel = false;
              });
            },
            markers: _buildGoogleMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
        ),

        // Floating Search & Filter Bar at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: PointerInterceptor(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Full-Width Search Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                        final trimmed = val.trim();
                        if (trimmed.isEmpty) {
                          setState(() {
                            _activeCarouselIndex = null;
                            _carouselLaundries = [];
                          });
                          _filterLaundries(resetCarousel: false);
                        } else if (trimmed.length >= 3) {
                          _filterLaundries(resetCarousel: true);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar lavanderías...',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.outline,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.outline,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _activeCarouselIndex = null;
                                    _carouselLaundries = [];
                                  });
                                  _filterLaundries(resetCarousel: true);
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  // Search Results Dropdown List (displays up to 5 matching laundries when 3+ chars entered)
                  if (_searchQuery.trim().length >= 3) ...[
                    const SizedBox(height: 8),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.48,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _filteredLaundries.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    'No se encontraron lavanderías con "$_searchQuery"',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: _filteredLaundries.take(5).length,
                                separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Colors.black12,
                                ),
                                itemBuilder: (context, index) {
                                  final item =
                                      _filteredLaundries.take(5).elementAt(index);
                                  return _buildSearchResultTile(item);
                                },
                              ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Horizontal category filter chips bar (Direct 1-tap filtering)
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final cat = _categories[idx];
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                            _filterLaundries(resetCarousel: true);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),





        // Always-visible Locate Me Floating Action Button (Smooth Animated Position)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          bottom: _activeCarouselIndex != null ? 205 : 90,
          right: 16,
          child: PointerInterceptor(
            child: FloatingActionButton(
              heroTag: 'locate_me_fab',
              onPressed: () {
                _animatedMapMove(_userLocation, 15.0);
              },
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.my_location_rounded, size: 24),
            ),
          ),
        ),

        // Floating Horizontal Laundry Slider at bottom (only visible when a marker is active)
        if (_activeCarouselIndex != null)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180,
              child: _carouselLaundries.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Text(
                          'No se encontraron lavanderías',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _carouselLaundries.length,
                      onPageChanged: (idx) {
                        if (_isAnimatingToPage) return;
                        setState(() {
                          _activeCarouselIndex = idx;
                        });
                        _animateToLaundry(_carouselLaundries[idx]);
                      },
                      itemBuilder: (context, idx) {
                        final item = _carouselLaundries[idx];
                        return _buildLaundryCarouselCard(item);
                      },
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchResultTile(LaundryItem laundry) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaundryBookingPage(
              laundry: laundry,
              allLaundries: _allLaundries,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Left icon avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: laundry.isEco
                    ? Colors.green.shade50
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  laundry.isEco
                      ? Icons.eco_rounded
                      : Icons.local_car_wash_rounded,
                  color: laundry.isEco
                      ? Colors.green.shade700
                      : AppColors.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Middle info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title + Badges
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          laundry.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Open / Closed Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: laundry.isOpen
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          laundry.isOpen ? 'Abierto' : 'Cerrado',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: laundry.isOpen
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Rating badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 11,
                            ),
                            const SizedBox(width: 1),
                            Text(
                              laundry.rating == 0.0
                                  ? 'Nuevo'
                                  : laundry.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: const Color(0xFF8A6D00),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Distance badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          laundry.distance,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Subtitle: Type & Prominent Price Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          laundry.type,
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFA7F3D0),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Desde ',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF047857),
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '\$${laundry.price.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Route icon button (Ir)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _openGoogleMapsRoute(
                      laundry.location.latitude,
                      laundry.location.longitude,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(
                      Icons.directions_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Reservar button (matches Ir button container structure & height)
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.25,
                    ),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaundryBookingPage(
                          laundry: laundry,
                          allLaundries: _allLaundries,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reservar',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaundryCarouselCard(LaundryItem laundry) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaundryBookingPage(
                    laundry: laundry,
                    allLaundries: _allLaundries,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Left side image placeholder / type representation
                  Container(
                    width: 90,
                    height: 110,
                    decoration: BoxDecoration(
                      color: laundry.isEco
                          ? Colors.green.shade50
                          : AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        laundry.isEco
                            ? Icons.eco_rounded
                            : Icons.local_car_wash_rounded,
                        color: laundry.isEco
                            ? Colors.green.shade700
                            : AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Middle / Right side details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Row: Open/Closed Status & Rating & Distance & Badges
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: laundry.isOpen
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                laundry.isOpen ? 'Abierto' : 'Cerrado',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: laundry.isOpen
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    laundry.rating == 0.0
                                        ? 'Nuevo'
                                        : laundry.rating.toStringAsFixed(1),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: const Color(0xFF8A6D00),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.directions_rounded,
                                    color: Colors.green.shade700,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    laundry.distance,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Title
                        Text(
                          laundry.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Subtitle
                        Text(
                          laundry.type,
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // Bottom row: Price, Directions & Book button
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFA7F3D0),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Desde ',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF047857),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '\$${laundry.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF059669),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),

                            // Navigation Button to open Google Maps route
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _openGoogleMapsRoute(
                                      laundry.location.latitude,
                                      laundry.location.longitude,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.directions_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Book Button
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LaundryBookingPage(
                                              laundry: laundry,
                                              allLaundries: _allLaundries,
                                            ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Reservar',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }

  void _showContactSuccessSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/explore');
              break;
            case 1:
              context.go('/reservas');
              break;
            case 2:
              context.go('/facturas');
              break;
            case 3:
              context.go('/perfil');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            activeIcon: Icon(Icons.explore_rounded, color: AppColors.primary),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded),
            activeIcon: Icon(
              Icons.event_note_rounded,
              color: AppColors.primary,
            ),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            activeIcon: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
            ),
            label: 'Facturas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            activeIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
