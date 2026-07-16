import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/dashboard/owner/widgets/services_tab.dart';
import 'package:washgo/features/dashboard/owner/widgets/employees_tab.dart';
import 'package:washgo/features/dashboard/owner/widgets/owner_billing_tab.dart';
import 'package:washgo/features/dashboard/owner/widgets/reviews_tab.dart';
import 'package:washgo/features/dashboard/owner/widgets/tabs/owner_inicio_tab.dart';
import 'package:washgo/features/dashboard/owner/widgets/tabs/owner_configuracion_tab.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/features/laundries/repositories/business_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_business_repository.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/laundries/models/employee_request.dart';
import 'package:washgo/features/laundries/models/active_employee.dart';
import 'package:washgo/features/laundries/models/washgo_business.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:washgo/features/invoices/repositories/invoice_repository.dart';
import 'package:washgo/features/orders/models/washgo_order.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/features/laundries/repositories/reservation_config_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_reservation_config_repository.dart';

class OwnerDashboardPage extends StatefulWidget {
  final int initialTab;
  const OwnerDashboardPage({super.key, this.initialTab = 0});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  final AuthRepository _authRepository = FirebaseAuthRepository();
  final BusinessRepository _businessRepository = FirebaseBusinessRepository();
  final OrderRepository _orderRepository = FirebaseOrderRepository();
  final InvoiceRepository _invoiceRepository = FirebaseInvoiceRepository();

  List<WashGoOrder> _allOrders = [];
  OwnerDashboardStats? _dashboardStats;
  List<WashGoOrder> _activeOrders = [];
  int _todayInvoicesCount = 0;
  int _todayOrdersCount = 0;
  double _weeklyEarnings = 0.0;
  StreamSubscription<List<WashGoOrder>>? _ordersSubscription;
  int _completedServicesCount = 0;
  double _cashEarnings = 0.0;
  double _electronicEarnings = 0.0;

  // Business state
  String? _businessId;
  String? _businessName;
  String? _businessRuc;
  String? _businessCode;
  String? _businessDescription;
  double? _latitud;
  double? _longitud;
  List<WashGoBusiness> _myBusinesses = [];
  WashGoBusiness? _business;

  // Operating Hours state
  TimeOfDay _horaApertura = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _horaCierre = const TimeOfDay(hour: 18, minute: 0);
  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  final List<bool> _diasSeleccionados = [
    true,
    true,
    true,
    true,
    true,
    true,
    false,
  ];

  // User profile state
  String? _userName;
  String? _userEmail;
  String? _userPhoto;
  List<UserRole> _userRoles = [];
  String? _userPhone;
  String? _businessPhone;
  bool _isSavingPhone = false;

  // Controllers for editing
  final _nombreController = TextEditingController();
  final _rucController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _capacidadController = TextEditingController(text: '1');
  final _anticipacionController = TextEditingController(text: '0');

  final ReservationConfigRepository _reservationConfigRepository =
      FirebaseReservationConfigRepository();
  bool _isReservationConfigured = false;

  List<EmployeeRequest> _requests = [];
  List<ActiveEmployee> _activeEmployees = [];
  List<WashGoService> _services = [];
  List<GetUserNotificationsNotifications> _notifications = [];
  late AnimationController _animationController;

  int get _unreadCount => _notifications.where((n) => !n.leida).length;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadDashboardData();
  }

  @override
  void didUpdateWidget(covariant OwnerDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      setState(() {
        _selectedIndex = widget.initialTab;
      });
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    _animationController.dispose();
    _nombreController.dispose();
    _rucController.dispose();
    _descripcionController.dispose();
    _telefonoController.dispose();
    _ownerPhoneController.dispose();
    _capacidadController.dispose();
    _anticipacionController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTimeOfDay(dynamic timeVal) {
    if (timeVal == null) return null;
    try {
      final timeStr = timeVal.toString().trim();
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hourPart = parts[0].trim();
        final minutePart = parts[1].trim();
        final hourMatch = RegExp(r'\d+').firstMatch(hourPart);
        final minuteMatch = RegExp(r'\d+').firstMatch(minutePart);
        if (hourMatch != null && minuteMatch != null) {
          int hour = int.parse(hourMatch.group(0)!);
          int minute = int.parse(minuteMatch.group(0)!);
          final upperTime = timeStr.toUpperCase();
          if (upperTime.contains('PM') && hour < 12) {
            hour += 12;
          } else if (upperTime.contains('AM') && hour == 12) {
            hour = 0;
          }
          if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
      }
    } catch (e) {
      debugPrint('Error parsing time: $timeVal, error: $e');
    }
    return null;
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        _userName = user.nombreCompleto;
        _userEmail = user.email;
        _userPhoto = user.fotoPerfil;
        _userRoles = user.roles;
        _userPhone = user.telefono;
        _ownerPhoneController.text = _userPhone ?? '';
      }

      // Fetch the owner's businesses list first
      List<WashGoBusiness> myBusinesses = [];
      try {
        myBusinesses = await _businessRepository.getMyBusinesses();
      } catch (e) {
        debugPrint('Error fetching my businesses: $e');
      }

      setState(() {
        _myBusinesses = myBusinesses;
      });

      String? businessId = user?.currentBusinessId;
      if (businessId == null && myBusinesses.isNotEmpty) {
        businessId = myBusinesses.first.id;
        try {
          await _businessRepository.switchCurrentBusiness(businessId);
        } catch (e) {
          debugPrint('Error switching current business: $e');
        }
      }

      if (user == null || businessId == null) {
        setState(() {
          _errorMessage =
              'No tienes ningún negocio asociado.\nPor favor crea uno primero.';
          _isLoading = false;
        });
        return;
      }

      WashGoBusiness? business;
      try {
        business = await _businessRepository.getBusiness(businessId);
      } catch (e) {
        debugPrint('Error fetching business detail: $e');
      }

      if (business == null) {
        setState(() {
          _errorMessage =
              'No se encontraron detalles del negocio.\nPor favor contacte al soporte.';
          _isLoading = false;
        });
        return;
      }

      _business = business;
      _businessId = business.id;
      _businessName = business.nombre;
      _businessRuc = business.ruc;
      _businessCode = business.businessCode;
      _businessDescription = business.descripcion;
      _latitud = business.latitud;
      _longitud = business.longitud;

      // Populate text controllers
      _nombreController.text = _businessName ?? '';
      _rucController.text = _businessRuc ?? '';
      _descripcionController.text = _businessDescription ?? '';
      _businessPhone = business.telefono;
      _telefonoController.text = _businessPhone ?? '';

      List<EmployeeRequest> requests = [];
      try {
        requests = await _businessRepository.getPendingEmployeeRequests(
          _businessId!,
        );
      } catch (e) {
        debugPrint('Error fetching pending employee requests: $e');
      }

      List<ActiveEmployee> employees = [];
      try {
        employees = await _businessRepository.getActiveEmployees(_businessId!);
      } catch (e) {
        debugPrint('Error fetching active employees: $e');
      }

      List<WashGoService> services = [];
      try {
        services = await _businessRepository.getBusinessServices(_businessId!);
      } catch (e) {
        debugPrint('Error fetching business services: $e');
      }

      List<Map<String, dynamic>> businessHours = [];
      try {
        businessHours = await _businessRepository.getBusinessHours(
          _businessId!,
        );
      } catch (e) {
        debugPrint('Error fetching business hours: $e');
      }

      if (businessHours.isNotEmpty) {
        try {
          final activeDay = businessHours.firstWhere(
            (bh) => bh['esDiaDescanso'] == false,
            orElse: () => businessHours.first,
          );

          final parsedApertura = _parseTimeOfDay(activeDay['horaApertura']);
          if (parsedApertura != null) {
            _horaApertura = parsedApertura;
          }

          final parsedCierre = _parseTimeOfDay(activeDay['horaCierre']);
          if (parsedCierre != null) {
            _horaCierre = parsedCierre;
          }

          for (int i = 0; i < 7; i++) {
            _diasSeleccionados[i] = false;
          }
          for (final bh in businessHours) {
            final int? dia = bh['diaDeLaSemana'] as int?;
            final bool? esDescanso = bh['esDiaDescanso'] as bool?;
            if (dia != null && dia >= 1 && dia <= 7 && esDescanso != null) {
              _diasSeleccionados[dia - 1] = !esDescanso;
            }
          }
        } catch (e) {
          debugPrint('Error processing business hours: $e');
        }
      }

      setState(() {
        _requests = requests;
        _activeEmployees = employees;
        _services = services;
      });

      // Fetch invoices for billing stats (today's completed orders + weekly earnings)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final mondayOffset = now.weekday - 1;
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: mondayOffset));
      final startOfMonth = DateTime(now.year, now.month, 1);
      final queryStartDate = startOfWeek.isBefore(startOfMonth)
          ? startOfWeek
          : startOfMonth;

      List<dynamic> invoices = [];
      try {
        invoices = await _invoiceRepository.getBusinessInvoices(
          _businessId!,
          startDate: queryStartDate,
        );
      } catch (e) {
        debugPrint('Error fetching business invoices: $e');
      }

      double weeklyEarnings = 0.0;
      double cashEarnings = 0.0;
      double electronicEarnings = 0.0;
      int todayInvoicesCount = 0;
      int completedServicesCount = 0;

      for (final invoice in invoices) {
        if (invoice.invoiceStatus == InvoiceStatus.GENERATED) {
          completedServicesCount++;
          final paymentMethod = invoice.paymentMethod.toUpperCase();
          if (paymentMethod == 'CASH' || paymentMethod == 'EFECTIVO') {
            cashEarnings += invoice.total;
          } else {
            electronicEarnings += invoice.total;
          }
        }
        final invoiceDate = DateTime(
          invoice.fechaEmision.year,
          invoice.fechaEmision.month,
          invoice.fechaEmision.day,
        );
        if (invoice.invoiceStatus == InvoiceStatus.GENERATED &&
            invoiceDate.isAtSameMomentAs(today)) {
          todayInvoicesCount++;
        }

        if (invoice.invoiceStatus == InvoiceStatus.GENERATED &&
            invoice.fechaEmision.isAfter(
              startOfWeek.subtract(const Duration(seconds: 1)),
            ) &&
            invoice.fechaEmision.isBefore(
              now.add(const Duration(seconds: 1)),
            )) {
          weeklyEarnings += invoice.total;
        }
      }

      _todayInvoicesCount = todayInvoicesCount;
      _weeklyEarnings = weeklyEarnings;
      _completedServicesCount = completedServicesCount;
      _cashEarnings = cashEarnings;
      _electronicEarnings = electronicEarnings;

      try {
        // Cancel previous stream
        _ordersSubscription?.cancel();
        // Watch active business orders
        _ordersSubscription = _orderRepository
            .watchBusinessOrders(_businessId!)
            .listen((orders) {
              if (mounted) {
                setState(() {
                  _allOrders = orders;
                  _dashboardStats = OwnerDashboardStats.calculate(orders);
                  _activeOrders = orders
                      .where(
                        (o) =>
                            o.status == OrderStatus.PENDIENTE_PAGO ||
                            o.status == OrderStatus.EN_COLA ||
                            o.status == OrderStatus.ACEPTADO ||
                            o.status == OrderStatus.EN_CAMINO ||
                            o.status == OrderStatus.EN_SERVICIO,
                      )
                      .toList();

                  final todayActiveCount = _activeOrders
                      .where(_isOrderToday)
                      .length;
                  _todayOrdersCount = _todayInvoicesCount + todayActiveCount;
                });
              }
            });
      } catch (e) {
        debugPrint('Error watching business orders: $e');
      }

      try {
        final resConfig = await _reservationConfigRepository.getConfig(
          _businessId!,
        );
        if (mounted) {
          setState(() {
            if (resConfig != null) {
              _capacidadController.text = resConfig.capacidadSimultanea
                  .toString();
              _anticipacionController.text = resConfig.tiempoAnticipacionMinutos
                  .toString();
              _isReservationConfigured = resConfig.isConfigured;
            } else {
              _capacidadController.text = '1';
              _anticipacionController.text = '0';
              _isReservationConfigured = false;
            }
          });
        }
      } catch (e) {
        debugPrint('Error loading reservation config: $e');
      }

      _animationController.forward(from: 0.0);
      try {
        await _loadNotifications();
      } catch (e) {
        debugPrint('Error loading notifications: $e');
      }
    } catch (e, stackTrace) {
      debugPrint('ERROR LOADING DASHBOARD: $e');
      debugPrint(stackTrace.toString());
      setState(() {
        _errorMessage = 'Error al cargar el panel: $e\n$stackTrace';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        final result = await ExampleConnector.instance
            .getUserNotifications(userId: user.uid)
            .execute();
        if (mounted) {
          setState(() {
            _notifications = result.data.notifications;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> _markAsRead(String id) async {
    // Optimistic UI update
    setState(() {
      _notifications = _notifications.map((n) {
        if (n.id == id) {
          return GetUserNotificationsNotifications(
            id: n.id,
            titulo: n.titulo,
            mensaje: n.mensaje,
            leida: true,
            fechaCreacion: n.fechaCreacion,
          );
        }
        return n;
      }).toList();
    });

    try {
      await ExampleConnector.instance.markNotificationAsRead(id: id).execute();
    } catch (e) {
      debugPrint('Error marking notification $id as read: $e');
      _loadNotifications();
    }
  }

  Future<void> _markAllAsRead() async {
    final unread = _notifications.where((n) => !n.leida).toList();
    if (unread.isEmpty) return;

    setState(() {
      _notifications = _notifications.map((n) {
        return GetUserNotificationsNotifications(
          id: n.id,
          titulo: n.titulo,
          mensaje: n.mensaje,
          leida: true,
          fechaCreacion: n.fechaCreacion,
        );
      }).toList();
    });

    try {
      await Future.wait(
        unread.map(
          (n) => ExampleConnector.instance
              .markNotificationAsRead(id: n.id)
              .execute(),
        ),
      );
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      _loadNotifications();
    }
  }

  String _formatDateTime(DateTime dt) {
    final localDt = dt.toLocal();
    final day = localDt.day.toString().padLeft(2, '0');
    final month = localDt.month.toString().padLeft(2, '0');
    final year = localDt.year;
    final hour = localDt.hour.toString().padLeft(2, '0');
    final minute = localDt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _saveLocalDetails() async {
    if (_nombreController.text.trim().isEmpty ||
        _rucController.text.trim().isEmpty ||
        _telefonoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre, RUC y teléfono son requeridos.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final businessPhoneVal = _telefonoController.text.trim();
    final cleanBusinessPhone = businessPhoneVal.replaceAll(
      RegExp(r'\s+|-|\+'),
      '',
    );
    if (cleanBusinessPhone.length < 7 ||
        int.tryParse(cleanBusinessPhone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa un número de teléfono de local válido (mínimo 7 dígitos).',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_diasSeleccionados.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos un día de atención.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final capacidadText = _capacidadController.text.trim();
    final anticipacionText = _anticipacionController.text.trim();

    if (capacidadText.isEmpty || anticipacionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La capacidad simultánea y tiempo de anticipación son requeridos.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int? capacidad = int.tryParse(capacidadText);
    final int? anticipacion = int.tryParse(anticipacionText);

    if (capacidad == null || capacidad < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La capacidad simultánea debe ser un número entero mayor o igual a 1.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (anticipacion == null || anticipacion < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El tiempo de anticipación debe ser un número entero mayor o igual a 0.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _businessRepository.updateBusiness(
        id: _businessId!,
        nombre: _nombreController.text.trim(),
        ruc: _rucController.text.trim(),
        descripcion: _descripcionController.text.trim().isNotEmpty
            ? _descripcionController.text.trim()
            : null,
        telefono: _telefonoController.text.trim(),
        latitud: _latitud,
        longitud: _longitud,
      );

      final String aperturaStr =
          '${_horaApertura.hour.toString().padLeft(2, '0')}:${_horaApertura.minute.toString().padLeft(2, '0')}';
      final String cierreStr =
          '${_horaCierre.hour.toString().padLeft(2, '0')}:${_horaCierre.minute.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> hoursList = [];
      for (int i = 1; i <= 7; i++) {
        final bool esDescanso = !_diasSeleccionados[i - 1];
        hoursList.add({
          'diaDeLaSemana': i,
          'esDiaDescanso': esDescanso,
          'horaApertura': esDescanso ? null : aperturaStr,
          'horaCierre': esDescanso ? null : cierreStr,
        });
      }

      await _businessRepository.updateBusinessHours(_businessId!, hoursList);

      await _reservationConfigRepository.saveConfig(
        businessId: _businessId!,
        capacidadSimultanea: capacidad,
        tiempoAnticipacionMinutos: anticipacion,
      );

      setState(() {
        _businessName = _nombreController.text.trim();
        _businessRuc = _rucController.text.trim();
        _businessDescription = _descripcionController.text.trim();
        _businessPhone = _telefonoController.text.trim();
        _isReservationConfigured = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Datos y horario del local actualizados correctamente.'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar datos: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isApertura) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isApertura ? _horaApertura : _horaCierre,
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
    if (picked != null) {
      setState(() {
        if (isApertura) {
          _horaApertura = picked;
        } else {
          _horaCierre = picked;
        }
      });
    }
  }

  Future<void> _handleApprove(EmployeeRequest request) async {
    try {
      await _businessRepository.approveEmployeeRequest(
        requestId: request.id,
        employeeId: request.user.id,
        businessId: _businessId!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${request.user.nombreCompleto} aprobado'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aprobar: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(EmployeeRequest request) async {
    try {
      await _businessRepository.rejectEmployeeRequest(
        requestId: request.id,
        employeeId: request.user.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solicitud rechazada'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                if (_business?.status == 'PENDING_APPROVAL')
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tu local está pendiente de aprobación. Todavía los clientes no pueden verlo.\n\nSe te enviará una notificación cuando haya sido aprobado.',
                                  style: GoogleFonts.inter(
                                    color: Colors.orange.shade800,
                                    fontSize: 13,
                                  ),
                                ),
                                if (_business?.businessCode != null &&
                                    _business!.businessCode.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Divider(color: Colors.orange.shade200),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Mientras tanto puedes compartir este código con tus empleados para que puedan registrarse y vincularse a este local.',
                                    style: GoogleFonts.inter(
                                      color: Colors.orange.shade800,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: _business!.businessCode,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Código "${_business!.businessCode}" copiado al portapapeles',
                                          ),
                                          backgroundColor: AppColors.primary,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.orange.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _business!.businessCode,
                                            style: GoogleFonts.spaceMono(
                                              color: Colors.orange.shade900,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.copy_rounded,
                                            size: 16,
                                            color: Colors.orange.shade700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: _buildSelectedTabContent()),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/owner-dashboard');
                  break;
                case 1:
                  context.go('/owner-dashboard/services');
                  break;
                case 2:
                  context.go('/owner-dashboard/employees');
                  break;
                case 3:
                  context.go('/owner-dashboard/billing');
                  break;
                case 4:
                  context.go('/owner-dashboard/reviews');
                  break;
                case 5:
                  context.go('/owner-dashboard/config');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(
                  Icons.dashboard_rounded,
                  color: AppColors.primary,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_laundry_service_rounded),
                activeIcon: Icon(
                  Icons.local_laundry_service_rounded,
                  color: AppColors.primary,
                ),
                label: 'Servicios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded),
                activeIcon: Icon(
                  Icons.people_alt_rounded,
                  color: AppColors.primary,
                ),
                label: 'Empleados',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                activeIcon: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                ),
                label: 'Facturación',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_rounded),
                activeIcon: Icon(Icons.star_rounded, color: AppColors.primary),
                label: 'Reseñas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                activeIcon: Icon(
                  Icons.settings_rounded,
                  color: AppColors.primary,
                ),
                label: 'Configuración',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    String title = 'Dashboard Dueño';
    String subtitle =
        'Resumen de operaciones hoy y monitor de lavado en tiempo real.';

    if (_selectedIndex == 1) {
      title = 'Servicios';
      subtitle =
          'Configura el catálogo de servicios de lavado, precios y duraciones.';
    } else if (_selectedIndex == 2) {
      title = 'Empleados';
      subtitle =
          'Administra el personal, aprueba solicitudes y comparte el código de acceso.';
    } else if (_selectedIndex == 3) {
      title = 'Facturación';
      subtitle = 'Consulta y administra las facturas de tu negocio.';
    } else if (_selectedIndex == 4) {
      title = 'Reseñas';
      subtitle =
          'Consulta la reputación del local y las opiniones de los clientes.';
    } else if (_selectedIndex == 5) {
      title = 'Configuración';
      subtitle =
          'Edita la información de tu negocio, coordenadas GPS y cuenta de usuario.';
    }

    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
              onPressed: _showNotificationsSheet,
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$_unreadCount',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: _showProfileSheet,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: _userPhoto != null
                    ? CachedNetworkImageProvider(_userPhoto!)
                    : null,
                child: _userPhoto == null
                    ? Text(
                        (_userName != null && _userName!.isNotEmpty)
                            ? _userName![0].toUpperCase()
                            : 'A',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0056D2), // Primary
                Color(0xFF003B95), // Darker Primary
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                    top: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_businessName != null) ...[
                        GestureDetector(
                          onTap: _showBusinessSwitcher,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.storefront_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _businessName!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  // Pull handler & Header
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notificaciones',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (_unreadCount > 0)
                          TextButton.icon(
                            icon: const Icon(Icons.done_all_rounded, size: 18),
                            label: Text(
                              'Marcar todo',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () async {
                              await _markAllAsRead();
                              setSheetState(() {});
                              setState(() {}); // Update the main page badge too
                            },
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 24),

                  // Notifications List
                  Expanded(
                    child: _notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tienes notificaciones',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Te avisaremos cuando pase algo importante',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: _notifications.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];

                              // Categorize by approval/rejection or general
                              final titleLower = notification.titulo
                                  .toLowerCase();
                              final messageLower = notification.mensaje
                                  .toLowerCase();

                              Color cardBg = Colors.white;
                              Color iconColor = AppColors.primary;
                              IconData iconData = Icons.notifications_rounded;
                              Color borderSideColor = Colors.transparent;

                              if (titleLower.contains('aproba') ||
                                  messageLower.contains('aproba') ||
                                  titleLower.contains('acepta') ||
                                  messageLower.contains('acepta')) {
                                cardBg = const Color(0xFFECFDF5); // Emerald-50
                                iconColor = AppColors.success;
                                iconData = Icons.check_circle_rounded;
                                borderSideColor = AppColors.success.withValues(
                                  alpha: 0.15,
                                );
                              } else if (titleLower.contains('recha') ||
                                  messageLower.contains('recha') ||
                                  titleLower.contains('cancela') ||
                                  messageLower.contains('cancela')) {
                                cardBg = const Color(0xFFFEF2F2); // Red-50
                                iconColor = AppColors.error;
                                iconData = Icons.cancel_rounded;
                                borderSideColor = AppColors.error.withValues(
                                  alpha: 0.15,
                                );
                              } else if (!notification.leida) {
                                cardBg = const Color(0xFFF0F9FF); // Sky-50
                                iconColor = AppColors.primary;
                                iconData = Icons.info_rounded;
                                borderSideColor = AppColors.primary.withValues(
                                  alpha: 0.15,
                                );
                              }

                              return InkWell(
                                onTap: () async {
                                  if (!notification.leida) {
                                    await _markAsRead(notification.id);
                                    setSheetState(() {});
                                    setState(
                                      () {},
                                    ); // Update the main badge too
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          borderSideColor != Colors.transparent
                                          ? borderSideColor
                                          : Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.02,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Unread indicator dot
                                        if (!notification.leida)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 6,
                                              right: 8,
                                            ),
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.error,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        else
                                          const SizedBox(width: 16),

                                        // Category icon
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: iconColor.withValues(
                                              alpha: 0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            iconData,
                                            color: iconColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Notification content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      notification.titulo,
                                                      style: GoogleFonts.inter(
                                                        fontWeight:
                                                            notification.leida
                                                            ? FontWeight.w600
                                                            : FontWeight.bold,
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _formatDateTime(
                                                      notification.fechaCreacion
                                                          .toDateTime(),
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                notification.mensaje,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color:
                                                      AppColors.textSecondary,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 12.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bottom sheet handle
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
                    const SizedBox(height: 24),

                    // Profile Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: _userPhoto != null
                              ? CachedNetworkImageProvider(_userPhoto!)
                              : null,
                          child: _userPhoto == null
                              ? Text(
                                  (_userName != null && _userName!.isNotEmpty)
                                      ? _userName![0].toUpperCase()
                                      : 'A',
                                  style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName ?? 'Usuario Administrador',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userEmail ?? 'correo@washgo.com',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Badge / Role indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.admin_panel_settings_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'DUEÑO / ADMINISTRADOR',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.outlineVariant),
                    const SizedBox(height: 16),

                    // Business Information Widget
                    if (_businessName != null) ...[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              _showBusinessSwitcher(isFromProfile: true),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.02,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.storefront_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _businessName!,
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.onSurface,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.swap_horiz_rounded,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'RUC: $_businessRuc',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_businessCode != null)
                                  IconButton(
                                    tooltip: 'Copiar código de negocio',
                                    icon: const Icon(
                                      Icons.copy_all_rounded,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: _businessCode ?? '',
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Código de negocio $_businessCode copiado al portapapeles.',
                                          ),
                                          backgroundColor: AppColors.primary,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Personal Phone Information
                    _buildOptionSectionTitle('Información Personal'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teléfono Personal',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ownerPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: 'Ingresa tu teléfono personal',
                                    border: InputBorder.none,
                                    isDense: true,
                                    prefixIcon: Icon(
                                      Icons.phone_android_rounded,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 20,
                                    ),
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _isSavingPhone
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                      onPressed: () async {
                                        final phone = _ownerPhoneController.text
                                            .trim();
                                        if (phone.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'El teléfono personal es obligatorio.',
                                              ),
                                              backgroundColor: AppColors.error,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          return;
                                        }
                                        final cleanVal = phone.replaceAll(
                                          RegExp(r'\s+|-|\+'),
                                          '',
                                        );
                                        if (cleanVal.length < 7 ||
                                            int.tryParse(cleanVal) == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Ingresa un número de teléfono personal válido (mínimo 7 dígitos).',
                                              ),
                                              backgroundColor: AppColors.error,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          return;
                                        }
                                        setSheetState(
                                          () => _isSavingPhone = true,
                                        );
                                        try {
                                          await _authRepository.updateUserPhone(
                                            phone,
                                          );
                                          setState(() {
                                            _userPhone = phone;
                                          });
                                          setSheetState(() {
                                            _isSavingPhone = false;
                                          });
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Teléfono personal actualizado.',
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade600,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          setSheetState(
                                            () => _isSavingPhone = false,
                                          );
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error al actualizar: $e',
                                                ),
                                                backgroundColor:
                                                    AppColors.error,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role selector (if has other roles)
                    if (_userRoles.length > 1) ...[
                      _buildOptionSectionTitle('Otros Roles Disponibles'),
                      const SizedBox(height: 8),
                      ..._userRoles
                          .where((role) => role != UserRole.ADMINISTRADOR)
                          .map((role) {
                            final String roleName;
                            final IconData roleIcon;
                            final String roleDescription;

                            switch (role) {
                              case UserRole.CLIENTE:
                                roleName = 'Cliente';
                                roleIcon = Icons.directions_car_filled_rounded;
                                roleDescription =
                                    'Solicita lavado para tus vehículos';
                                break;
                              case UserRole.EMPLEADO:
                                roleName = 'Empleado';
                                roleIcon = Icons.badge_rounded;
                                roleDescription =
                                    'Registra lavados y atiende pedidos';
                                break;
                              default:
                                roleName = role.name;
                                roleIcon = Icons.person_outline_rounded;
                                roleDescription =
                                    'Cambiar a perfil de ${role.name.toLowerCase()}';
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                    ); // Close bottom sheet
                                    SessionManager.activeRole = role;
                                    context.go('/auth-gate');
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.outlineVariant,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.08,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            roleIcon,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Cambiar a $roleName',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.onSurface,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                roleDescription,
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: AppColors
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: AppColors.outline,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 16),
                    ],

                    // Sign Out & Settings Actions
                    _buildOptionSectionTitle('Configuración de cuenta'),
                    const SizedBox(height: 8),

                    // Change role if they have more roles
                    if (_userRoles.length > 1)
                      _buildActionTile(
                        icon: Icons.swap_horiz_rounded,
                        title: 'Cambiar de Perfil / Rol',
                        subtitle: 'Elige entre tus roles disponibles',
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/select-active-role');
                        },
                      ),

                    _buildActionTile(
                      icon: Icons.logout_rounded,
                      title: 'Cerrar Sesión',
                      subtitle: 'Salir de tu cuenta de WashGo',
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      onTap: () async {
                        Navigator.pop(context);
                        final router = GoRouter.of(context);
                        await FirebaseAuth.instance.signOut();
                        SessionManager.activeRole = null;
                        router.go('/login');
                      },
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

  void _showBusinessSwitcher({bool isFromProfile = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 12.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom sheet handle
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
              const SizedBox(height: 24),

              Text(
                'Mis Locales / Sucursales',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecciona el local que deseas administrar.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _myBusinesses.length,
                  itemBuilder: (context, index) {
                    final b = _myBusinesses[index];
                    final isActive = b.id == _businessId;

                    Color statusColor = Colors.orange;
                    String statusText = 'Pendiente';
                    if (b.status == 'APPROVED') {
                      statusColor = Colors.green;
                      statusText = 'Aprobado';
                    } else if (b.status == 'REJECTED') {
                      statusColor = Colors.red;
                      statusText = 'Rechazado';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Material(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.04)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () async {
                            if (isActive) {
                              Navigator.pop(context);
                              return;
                            }

                            Navigator.pop(context); // Close switcher sheet
                            if (isFromProfile) {
                              Navigator.pop(context); // Close profile sheet
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await _businessRepository.switchCurrentBusiness(
                                b.id,
                              );
                              await _loadDashboardData();

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Se cambió al local "${b.nombre}".',
                                  ),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al cambiar de local: $e',
                                  ),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isActive
                                    ? AppColors.primary.withValues(alpha: 0.5)
                                    : AppColors.outlineVariant,
                                width: isActive ? 1.5 : 1.0,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.primary.withValues(
                                            alpha: 0.08,
                                          )
                                        : AppColors.surfaceContainerLow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: isActive
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b.nombre,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            'RUC: ${b.ruc}',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: statusColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isActive)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  )
                                else
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppColors.outline,
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
              const SizedBox(height: 12),
              const Divider(color: AppColors.outlineVariant),
              const SizedBox(height: 8),

              // Button to register another business
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context); // Close switcher sheet
                    if (isFromProfile) {
                      Navigator.pop(context); // Close profile sheet
                    }
                    final result = await context.push(AppRoutes.createLaundry);
                    if (result == true) {
                      _loadDashboardData();
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Registrar otro local',
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.outline,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.outline,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business_center_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadDashboardData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildInicioTab();
      case 1:
        return _buildServiciosTab();
      case 2:
        return _buildEmpleadosTab();
      case 3:
        return OwnerBillingTab(
          businessId: _businessId ?? '',
          activeEmployees: _activeEmployees,
        );
      case 4:
        return ReviewsTab(
          businessId: _businessId ?? '',
          animationController: _animationController,
        );
      case 5:
        return _buildConfiguracionTab();
      default:
        return _buildInicioTab();
    }
  }

  // ================= TAB 0: INICIO =================
  Widget _buildInicioTab() {
    return FadeTransition(
      opacity: _animationController,
      child: OwnerInicioTab(
        isReservationConfigured: _isReservationConfigured,
        allOrders: _allOrders,
        business: _business,
        requests: _requests,
        todayOrdersCount: _todayOrdersCount,
        weeklyEarnings: _weeklyEarnings,
        completedServicesCount: _completedServicesCount,
        cashEarnings: _cashEarnings,
        electronicEarnings: _electronicEarnings,
        dashboardStats:
            _dashboardStats ?? OwnerDashboardStats.calculate(_allOrders),
      ),
    );
  }

  bool _isOrderToday(WashGoOrder order) {
    try {
      final parsed = ParsedObservations.parse(order.observations);
      if (parsed.scheduleType == 'Ahora mismo') {
        return true;
      }
      final dateStr = parsed.dateTime.split(' ')[0]; // "dd/MM/yyyy"
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final now = DateTime.now();
        return day == now.day && month == now.month && year == now.year;
      }
    } catch (_) {}
    return false;
  }

  // ================= TAB 5: CONFIGURACION =================
  Widget _buildConfiguracionTab() {
    return FadeTransition(
      opacity: _animationController,
      child: OwnerConfiguracionTab(
        userRoles: _userRoles,
        showProfileSheet: _showProfileSheet,
        nombreController: _nombreController,
        rucController: _rucController,
        telefonoController: _telefonoController,
        descripcionController: _descripcionController,
        latitud: _latitud,
        longitud: _longitud,
        onLocationChanged: (lat, lng) {
          setState(() {
            _latitud = lat;
            _longitud = lng;
          });
        },
        diasSemana: _diasSemana,
        diasSeleccionados: _diasSeleccionados,
        onDaySelected: (index, selected) {
          setState(() {
            _diasSeleccionados[index] = selected;
          });
        },
        horaApertura: _horaApertura,
        horaCierre: _horaCierre,
        selectTime: _selectTime,
        isReservationConfigured: _isReservationConfigured,
        capacidadController: _capacidadController,
        anticipacionController: _anticipacionController,
        isSaving: _isSaving,
        saveLocalDetails: _saveLocalDetails,
      ),
    );
  }

  // ================= TAB 2: SERVICIOS =================
  Future<void> _createService({
    required String nombre,
    required String? descripcion,
    required double precioPequeno,
    required double precioMediano,
    required double precioGrande,
    required double precioMoto,
    required int duracionMinutos,
    required ServiceType tipo,
  }) async {
    try {
      await _businessRepository.createService(
        businessId: _businessId!,
        nombre: nombre,
        descripcion: descripcion,
        precioPequeno: precioPequeno,
        precioMediano: precioMediano,
        precioGrande: precioGrande,
        precioMoto: precioMoto,
        duracionMinutos: duracionMinutos,
        tipo: tipo,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Servicio "$nombre" creado correctamente.'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear servicio: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _updateService({
    required String id,
    required String nombre,
    required String? descripcion,
    required double precioPequeno,
    required double precioMediano,
    required double precioGrande,
    required double precioMoto,
    required int duracionMinutos,
    required ServiceType tipo,
    required bool isPriceChanged,
  }) async {
    try {
      if (isPriceChanged) {
        await _businessRepository.updateService(
          id: id,
          nombre: nombre,
          descripcion: descripcion,
          precioPequeno: precioPequeno,
          precioMediano: precioMediano,
          precioGrande: precioGrande,
          precioMoto: precioMoto,
          duracionMinutos: duracionMinutos,
          tipo: tipo,
        );
      } else {
        await _businessRepository.updateServiceDetails(
          id: id,
          nombre: nombre,
          descripcion: descripcion,
          duracionMinutos: duracionMinutos,
          tipo: tipo,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Servicio "$nombre" actualizado correctamente.'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar servicio: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteService(String id, String nombre) async {
    try {
      await _businessRepository.deleteService(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Servicio "$nombre" eliminado.'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar servicio: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _toggleServiceActive(
    String id,
    bool active,
    String nombre,
  ) async {
    try {
      await _businessRepository.toggleServiceActive(id, active);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              active
                  ? 'Servicio "$nombre" habilitado.'
                  : 'Servicio "$nombre" deshabilitado.',
            ),
            backgroundColor: active
                ? Colors.green.shade600
                : Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar estado del servicio: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showServiceDialog({WashGoService? service}) {
    final isEdit = service != null;
    final nombreController = TextEditingController(text: service?.nombre);
    final descripcionController = TextEditingController(
      text: service?.descripcion,
    );
    final precioPequenoController = TextEditingController(
      text:
          service?.precioOwnerPequeno.toString() ??
          (service?.precioPequeno.toString() ?? ''),
    );
    final precioMedianoController = TextEditingController(
      text:
          service?.precioOwnerMediano.toString() ??
          (service?.precioMediano.toString() ?? ''),
    );
    final precioGrandeController = TextEditingController(
      text:
          service?.precioOwnerGrande.toString() ??
          (service?.precioGrande.toString() ?? ''),
    );
    final precioMotoController = TextEditingController(
      text:
          service?.precioOwnerMoto.toString() ??
          (service?.precioMoto.toString() ?? ''),
    );
    final duracionController = TextEditingController(
      text: service?.duracionMinutos.toString(),
    );
    ServiceType selectedTipo = service != null
        ? service.tipo
        : ServiceType.LOCAL;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isEdit ? 'Editar Servicio' : 'Agregar Servicio',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Servicio',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descripcionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Precios por Categoría',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: precioPequenoController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Pequeño (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.directions_car_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: precioMedianoController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Mediano (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: precioGrandeController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Grande (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.airport_shuttle_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: precioMotoController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Moto (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.two_wheeler_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: duracionController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Duración (Min)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.timer_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<ServiceType>(
                            initialValue: selectedTipo,
                            decoration: const InputDecoration(
                              labelText: 'Tipo de Servicio',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home_work_outlined),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: ServiceType.LOCAL,
                                child: Text('En Local'),
                              ),
                              if (selectedTipo == ServiceType.DOMICILIO)
                                const DropdownMenuItem(
                                  value: ServiceType.DOMICILIO,
                                  child: Text('A Domicilio'),
                                ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedTipo = val;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nombre = nombreController.text.trim();
                    final descripcion = descripcionController.text.trim();
                    final precioPequeno =
                        double.tryParse(precioPequenoController.text.trim()) ??
                        0.0;
                    final precioMediano =
                        double.tryParse(precioMedianoController.text.trim()) ??
                        0.0;
                    final precioGrande =
                        double.tryParse(precioGrandeController.text.trim()) ??
                        0.0;
                    final precioMoto =
                        double.tryParse(precioMotoController.text.trim()) ??
                        0.0;
                    final duracion =
                        int.tryParse(duracionController.text.trim()) ?? 0;

                    if (nombre.isEmpty ||
                        precioPequeno <= 0 ||
                        precioMediano <= 0 ||
                        precioGrande <= 0 ||
                        precioMoto <= 0 ||
                        duracion <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor completa todos los campos con valores válidos.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).pop();

                    if (isEdit) {
                      // Check if it's an approved business and price actually changed
                      final isApprovedBusiness =
                          _business?.status == 'APPROVED';
                      final isPriceChanged =
                          service.precioOwnerPequeno != precioPequeno ||
                          service.precioOwnerMediano != precioMediano ||
                          service.precioOwnerGrande != precioGrande ||
                          service.precioOwnerMoto != precioMoto;

                      if (isApprovedBusiness && isPriceChanged) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 8),
                                const Text('¿Deseas suspender y solicitar?'),
                              ],
                            ),
                            content: const Text(
                              '⚠️ El servicio será suspendido temporalmente\n\n'
                              'Al cambiar el precio, este servicio dejará de aparecer para '
                              'los clientes hasta que el administrador de WashGo apruebe '
                              'el nuevo precio.\n\n'
                              '¿Deseas continuar y enviar la solicitud de cambio?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  _updateService(
                                    id: service.id,
                                    nombre: nombre,
                                    descripcion: descripcion.isNotEmpty
                                        ? descripcion
                                        : null,
                                    precioPequeno: precioPequeno,
                                    precioMediano: precioMediano,
                                    precioGrande: precioGrande,
                                    precioMoto: precioMoto,
                                    duracionMinutos: duracion,
                                    tipo: selectedTipo,
                                    isPriceChanged: true,
                                  );
                                },
                                child: const Text('Sí, suspender y solicitar'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        _updateService(
                          id: service.id,
                          nombre: nombre,
                          descripcion: descripcion.isNotEmpty
                              ? descripcion
                              : null,
                          precioPequeno: precioPequeno,
                          precioMediano: precioMediano,
                          precioGrande: precioGrande,
                          precioMoto: precioMoto,
                          duracionMinutos: duracion,
                          tipo: selectedTipo,
                          isPriceChanged: isPriceChanged,
                        );
                      }
                    } else {
                      _createService(
                        nombre: nombre,
                        descripcion: descripcion.isNotEmpty
                            ? descripcion
                            : null,
                        precioPequeno: precioPequeno,
                        precioMediano: precioMediano,
                        precioGrande: precioGrande,
                        precioMoto: precioMoto,
                        duracionMinutos: duracion,
                        tipo: selectedTipo,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isEdit ? 'Guardar' : 'Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildServiciosTab() {
    return ServicesTab(
      services: _services,
      animationController: _animationController,
      onToggleActive: _toggleServiceActive,
      onEditService: (service) => _showServiceDialog(service: service),
      onDeleteService: _deleteService,
      onAddService: () => _showServiceDialog(),
    );
  }

  // ================= TAB 2: EMPLEADOS =================
  Widget _buildEmpleadosTab() {
    return EmployeesTab(
      businessCode: _businessCode,
      requests: _requests,
      activeEmployees: _activeEmployees,
      animationController: _animationController,
      onRejectRequest: _handleReject,
      onApproveRequest: _handleApprove,
      onEmployeeAction: (rel) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gestión de empleado en desarrollo.')),
        );
      },
    );
  }
}

// (Removed end of file definition of _ServiceStat since it is moved to owner_inicio_tab.dart)
