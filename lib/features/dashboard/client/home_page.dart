import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:washgo/features/dashboard/client/models/laundry_item.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';
import 'package:washgo/features/dashboard/client/pages/laundry_booking_page.dart';
import 'package:washgo/features/dashboard/client/widgets/tabs/bookings_tab.dart';
import 'package:washgo/features/dashboard/client/widgets/tabs/profile_tab.dart';
import 'package:washgo/features/invoices/pages/client_invoice_history_page.dart';
import 'package:washgo/features/dashboard/client/widgets/vehicles/vehicle_dialogs.dart';
import 'package:washgo/core/session/booking_intent_manager.dart';
import 'package:washgo/features/payments/pages/proof_status_page.dart';

import 'package:washgo/features/auth/models/washgo_user.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/features/profile/repositories/vehicle_repository.dart';
import 'package:washgo/features/profile/repositories/firebase_vehicle_repository.dart';
import 'package:washgo/features/laundries/repositories/laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_laundry_repository.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/core/utils/observations_parser.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({super.key, this.initialTab = 0});

  // Global static cache to persist user location across page destructions (route switches)
  static LatLng? cachedUserLocation;
  static bool hasLockedInitialLocation = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _isAnimatingToPage = false;
  int _selectedIndex = 0;
  final MapController _mapController = MapController();
  PageController _pageController = PageController(viewportFraction: 0.85);
  AnimationController? _mapAnimationController;

  // Dynamic user location initialized with global cache or Guayaquil center fallback
  LatLng _userLocation =
      HomePage.cachedUserLocation ?? const LatLng(-2.1961601, -79.8862076);
  bool _isFirstLocationLock = !HomePage.hasLockedInitialLocation;
  StreamSubscription<Position>? _positionSubscription;

  final AuthRepository _authRepository = FirebaseAuthRepository();
  final VehicleRepository _vehicleRepository = FirebaseVehicleRepository();
  final LaundryRepository _laundryRepository = FirebaseLaundryRepository();
  final OrderRepository _orderRepository = FirebaseOrderRepository();

  List<LaundryItem> _allLaundries = [];
  List<LaundryItem> _filteredLaundries = [];
  List<LaundryItem> _carouselLaundries = [];
  int? _activeCarouselIndex;
  String _selectedCategory = 'Todos';
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

  // Active user vehicles
  List<VehicleItem> _myVehicles = [];
  bool _loadingVehicles = false;

  // Map category filters
  final List<String> _categories = [
    'Todos',
    'Cerca 📍(<500mt)',
    'Económico 💰(<10.00)',
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    final initialDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    if (!context.mounted) return;
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) return;

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();
    final hour = selectedTime.hour.toString().padLeft(2, '0');
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final rescheduledDateTime = '$day/$month/$year $hour:$minute';

    final newObservations =
        'Programado ($rescheduledDateTime) - Vehículo: ${parsed.vehicleDetails}';

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

  Future<void> _fetchMyVehicles() async {
    if (!mounted) return;
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        _myVehicles = [];
        _loadingVehicles = false;
      });
      return;
    }
    setState(() {
      _loadingVehicles = true;
    });
    try {
      final vehicles = await _vehicleRepository.getMyVehicles();
      if (mounted) {
        setState(() {
          _myVehicles = vehicles;
          if (_myVehicles.isNotEmpty) {
          } else {}
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

  void _confirmDeleteVehicle(VehicleItem vehicle) {
    VehicleDialogs.confirmDeleteVehicle(context, vehicle, _fetchMyVehicles);
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _filteredLaundries = List.from(_allLaundries);
    _initLocationTracking();
    _fetchSavedBusinesses();

    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadCurrentUser();
        _subscribeToClientOrders();
        _fetchMyVehicles();
      } else {
        BookingIntentManager.instance.clearIntent();
        BookingIntentManager.instance.clearPendingPaymentIntent();
        if (mounted) {
          setState(() {
            _showContinueBanner = false;
            _washGoUser = null;
            _userRoles = [];
            _myVehicles = [];
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
      if (_selectedIndex == 1) {
        _fetchClientOrders();
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _ordersSubscription?.cancel();
    _authStateSubscription?.cancel();
    _mapAnimationController?.dispose();
    _mapController.dispose();
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
            _mapController.move(_userLocation, 15.0);
          }
        }
      } catch (e) {
        debugPrint(
          'getLastKnownPosition is not supported or failed on this platform: $e',
        );
      }

      // Initial quick location lock
      try {
        final initialPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        if (mounted) {
          setState(() {
            _userLocation = LatLng(
              initialPosition.latitude,
              initialPosition.longitude,
            );
            HomePage.cachedUserLocation = _userLocation;
          });
          if (_isFirstLocationLock) {
            _isFirstLocationLock = false;
            HomePage.hasLockedInitialLocation = true;
            _mapController.move(_userLocation, 15.0);
          }
          _fetchSavedBusinesses();
        }
      } catch (e) {
        debugPrint('getCurrentPosition failed or timed out: $e');
      }

      // Continuous tracking subscription
      try {
        _positionSubscription =
            Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
              ),
            ).listen((Position position) {
              if (mounted) {
                setState(() {
                  _userLocation = LatLng(position.latitude, position.longitude);
                  HomePage.cachedUserLocation = _userLocation;
                });
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
      final dynamicList = await _laundryRepository.getLaundries(_userLocation);
      setState(() {
        _allLaundries = dynamicList;
        _filterLaundries();
      });
      _checkPendingBookingIntent();
    } catch (e) {
      debugPrint('Error fetching businesses: $e');
    }
  }

  void _checkPendingBookingIntent() {
    // First, check for a pending payment intent (bank transfer)
    if (BookingIntentManager.instance.hasPendingPaymentIntent()) {
      final paymentIntent = BookingIntentManager.instance.getPendingPaymentIntent();
      if (paymentIntent != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProofStatusPage(
              orderId: paymentIntent.orderId,
              proofStatus: 'PENDING',
              amount: paymentIntent.amount,
              serviceName: paymentIntent.serviceName,
              businessName: paymentIntent.businessName,
            ),
          ),
        );
        return;
      }
    }

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lavandería no disponible',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            'La lavandería "${intent.laundryName}" de tu reserva pendiente ya no está disponible.',
            style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
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
        final distMeters = Geolocator.distanceBetween(
          _userLocation.latitude,
          _userLocation.longitude,
          laundry.location.latitude,
          laundry.location.longitude,
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
          location: laundry.location,
          isEco: laundry.isEco,
          isOpen: laundry.isOpen,
          waitTime: laundry.waitTime,
          phone: laundry.phone,
          businessHours: laundry.businessHours,
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

  Future<void> _updateProfile({required String name, required String phone}) async {
    final email = _washGoUser?.email ?? FirebaseAuth.instance.currentUser?.email ?? '';
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
    // Save the ID of the currently selected laundry, if any
    final String? selectedLaundryId =
        (!resetCarousel && _activeCarouselIndex != null && _carouselLaundries.isNotEmpty)
        ? _carouselLaundries[_activeCarouselIndex!].id
        : null;

    setState(() {
      _filteredLaundries = _allLaundries.where((laundry) {
        final matchesSearch =
            laundry.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            laundry.type.toLowerCase().contains(_searchQuery.toLowerCase());

        bool matchesCategory = true;
        final selectedLower = _selectedCategory.toLowerCase();

        if (selectedLower.contains('cerc') || selectedLower.contains('near')) {
          // Filter laundries that are within 500 meters using precalculated distance
          matchesCategory = laundry.distanceInMeters <= 500;
        } else if (selectedLower.contains('econ') ||
            selectedLower.contains('cheap')) {
          // Filter laundries with price less than 10 dollars
          matchesCategory = laundry.price < 10.00;
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

      // Restore active carousel if the selected item is still in the list
      if (selectedLaundryId != null) {
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
    _mapAnimationController?.stop();
    _mapAnimationController?.dispose();

    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _mapAnimationController = controller;

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      if (mounted) {
        _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
        );
      }
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
        if (_mapAnimationController == controller) {
          _mapAnimationController = null;
        }
      }
    });

    controller.forward();
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
          loadingVehicles: _loadingVehicles,
          myVehicles: _myVehicles,
          isRolesLoading: _isRolesLoading,
          userRoles: _userRoles.map((role) => role.name).toList(),
          onAddVehicle: _showAddVehicleDialog,
          onEditVehicle: _showEditVehicleDialog,
          onDeleteVehicle: _confirmDeleteVehicle,
          onUpdateProfile: _updateProfile,
          onDeleteAccount: _deleteAccount,
        );
      default:
        return _buildMapSection();
    }
  }

  // ==========================================
  // 1. MAP SECTION (EXPLORAR)
  // ==========================================
  Widget _buildMapSection() {
    return Stack(
      key: const ValueKey('map_section'),
      children: [
        // Fullscreen OSM map
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _activeCarouselIndex = null;
                  _showFilterPanel = false;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.washgo',
              ),
              MarkerLayer(
                markers: [
                  // Pulsing User Location Marker
                  Marker(
                    point: _userLocation,
                    width: 50.0,
                    height: 50.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Laundry locations
                  ..._filteredLaundries.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isSelected =
                        _activeCarouselIndex != null &&
                        _carouselLaundries.isNotEmpty &&
                        item.id == _carouselLaundries[_activeCarouselIndex!].id;

                    return Marker(
                      point: item.location,
                      width: isSelected ? 56.0 : 44.0,
                      height: isSelected ? 56.0 : 44.0,
                      child: GestureDetector(
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (item.isOpen
                                      ? AppColors.primary
                                      : Colors.grey.shade700)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : (item.isOpen
                                        ? AppColors.primary
                                        : Colors.grey.shade400),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.isEco
                                ? Icons.eco_rounded
                                : Icons.local_car_wash_rounded,
                            color: isSelected
                                ? Colors.white
                                : (!item.isOpen
                                      ? Colors.grey.shade400
                                      : (item.isEco
                                            ? Colors.green.shade600
                                            : AppColors.primary)),
                            size: isSelected ? 28 : 22,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),

        // Invisible overlay to detect clicks outside the filter panel and close it
        if (_showFilterPanel)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showFilterPanel = false;
                });
              },
              child: Container(color: Colors.transparent),
            ),
          ),

        // Floating Search & Filter Bar at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
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
                // Search Input Field & Filter Toggle
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                          onChanged: (val) {
                            _searchQuery = val;
                            _filterLaundries(resetCarousel: true);
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
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.mic_none_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFilterPanel = !_showFilterPanel;
                        });
                      },
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _showFilterPanel
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              color: _showFilterPanel
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filtrar por...',
                              style: GoogleFonts.inter(
                                color: _showFilterPanel
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _showFilterPanel
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10, bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.tune_rounded,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Filtros de búsqueda',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_selectedCategory != 'Todos')
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = 'Todos';
                                        });
                                        _filterLaundries(resetCarousel: true);
                                      },
                                      child: Text(
                                        'Limpiar todos',
                                        style: GoogleFonts.inter(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Categorías',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppColors.outline,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _categories.map((cat) {
                                  final isSelected = _selectedCategory == cat;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = cat;
                                      });
                                      _filterLaundries(resetCarousel: true);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        cat,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
              ],
            ),
          ),
        ),

        // Floating Horizontal Laundry Slider at bottom (only visible when a marker is active)
        _activeCarouselIndex != null
            ? Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Locate Me Floating Action Button
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
                      child: FloatingActionButton(
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

                    // PageView Carousel
                    SizedBox(
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
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'No se encontraron lavanderías',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                  ),
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
                  ],
                ),
              )
            : Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
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
      ],
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
                        // Row: Rating & Wait Time & Distance & Badges
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
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Desde ',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.outline,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '\$${laundry.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

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

  void _showAddVehicleDialog() {
    VehicleDialogs.showAddVehicleDialog(context, _fetchMyVehicles);
  }

  void _showEditVehicleDialog(VehicleItem vehicle) {
    VehicleDialogs.showEditVehicleDialog(context, vehicle, _fetchMyVehicles);
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
