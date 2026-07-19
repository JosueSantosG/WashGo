import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';
import 'package:washgo/features/orders/repositories/order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';
import 'package:washgo/features/orders/models/washgo_order.dart';
import 'package:washgo/features/orders/models/order_audit_log.dart';
import 'package:washgo/features/laundries/repositories/business_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_business_repository.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';
import 'package:washgo/features/invoices/repositories/invoice_repository.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:washgo/features/dashboard/employee/widgets/tabs/employee_history_tab.dart';
import 'package:washgo/features/dashboard/employee/widgets/tabs/employee_profile_tab.dart';

class EmployeeDashboardPage extends StatefulWidget {
  const EmployeeDashboardPage({super.key});

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;

  final AuthRepository _authRepository = FirebaseAuthRepository();
  final OrderRepository _orderRepository = FirebaseOrderRepository();
  final BusinessRepository _businessRepository = FirebaseBusinessRepository();
  final InvoiceRepository _invoiceRepository = FirebaseInvoiceRepository();

  bool _isAvailable = true;
  String? _businessEmployeeRecordId;
  bool _isLoadingAvailability = false;

  String? _employeeId;
  String? _employeeName;
  String? _employeePhone;
  String? _employeeEmail;
  String? _businessId;
  String? _businessName;
  List<UserRole> _userRoles = [];
  EmployeeStatus? _employeeStatus;

  List<WashGoOrder> _pendingQueue = [];
  List<WashGoOrder> _myActiveOrders = [];
  List<WashGoOrder> _myHistoryOrders = [];
  List<InvoiceModel> _employeeInvoices = [];
  bool _isLoadingInvoices = false;
  String? _invoicesErrorMessage;
  int _currentNavIndex = 0;
  StreamSubscription<List<WashGoOrder>>? _ordersSubscription;
  Timer? _approvalPollingTimer;


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  OrderType? _selectedOrderTypeFilter;
  bool? _selectedScheduleFilter;
  bool _showFiltersPanel = false;

  bool get _hasActiveFilters =>
      _selectedOrderTypeFilter != null || _selectedScheduleFilter != null;
  int get _activeFiltersCount =>
      (_selectedOrderTypeFilter != null ? 1 : 0) +
      (_selectedScheduleFilter != null ? 1 : 0);

  int _pendingLimit = 5;
  int _activeLimit = 5;

  bool _isLoadingHistory = false;
  bool _hasMoreHistory = true;
  int _historyOffset = 0;
  final int _historyPageSize = 10;

  int _invoicesOffset = 0;
  final int _invoicesPageSize = 20;
  bool _hasMoreInvoices = true;
  bool _isLoadingMoreInvoices = false;
  String _invoicesSearchQuery = '';

  String _getOrderDisplayCode(WashGoOrder order) {
    final displayId = order.id.length > 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();
    return '#WASH-$displayId';
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final pad = (int n) => n.toString().padLeft(2, '0');
    return '${pad(local.day)}/${pad(local.month)}/${local.year} ${pad(local.hour)}:${pad(local.minute)}';
  }

  void _showOrderLogsBottomSheet(WashGoOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return FutureBuilder<List<OrderAuditLog>>(
              future: _orderRepository.getOrderLogs(order.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Error al cargar el historial: ${snapshot.error}',
                        style: GoogleFonts.inter(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final logs = snapshot.data ?? [];
                if (logs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sin historial de cambios',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No se encontraron registros de auditoría para esta orden.',
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Pull handler
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Historial de Cambios',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Orden ${_getOrderDisplayCode(order)}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                            ),
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          String title = '';
                          String subtitle = '';
                          IconData iconData = Icons.info_outline;
                          Color iconColor = Colors.blue;

                          if (log.actionType == 'CREACION') {
                            title = 'Creación de la Reserva';
                            subtitle = 'Reserva inicial establecida para: ${log.newValue}';
                            iconData = Icons.add_circle_outline_rounded;
                            iconColor = Colors.green;
                          } else if (log.actionType == 'REPROGRAMACION') {
                            title = 'Reprogramación de Reserva';
                            subtitle = 'El cliente cambió su reserva a: ${log.newValue}'
                                '\n(Fecha anterior: ${log.previousValue ?? "N/D"})';
                            iconData = Icons.edit_calendar_rounded;
                            iconColor = Colors.amber;
                          } else {
                            title = log.actionType;
                            subtitle = 'Cambio de estado u otra acción';
                            if (log.previousValue != null) {
                              subtitle += '\nAnterior: ${log.previousValue}';
                            }
                            if (log.newValue != null) {
                              subtitle += '\nNuevo: ${log.newValue}';
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: iconColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: iconColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        subtitle,
                                        style: GoogleFonts.inter(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _formatDateTime(log.createdAt),
                                        style: GoogleFonts.inter(
                                          color: Colors.grey.shade500,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadMoreButton({
    required int currentLimit,
    required int totalLength,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.expand_more_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ver más (Mostrando $currentLimit de $totalLength)',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadEmployeeInvoices({
    bool loadMore = false,
    bool refresh = false,
    String? searchQuery,
  }) async {
    if (_employeeId == null) return;

    if (searchQuery != null) {
      _invoicesSearchQuery = searchQuery;
    }

    if (loadMore) {
      if (_isLoadingInvoices || _isLoadingMoreInvoices || !_hasMoreInvoices)
        return;
      if (mounted) {
        setState(() {
          _isLoadingMoreInvoices = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingInvoices = true;
          _invoicesErrorMessage = null;
          if (refresh || searchQuery != null) {
            _invoicesOffset = 0;
            _hasMoreInvoices = true;
            _employeeInvoices = [];
          }
        });
      }
    }

    try {
      final query = _invoicesSearchQuery.trim().isNotEmpty
          ? _invoicesSearchQuery.trim()
          : null;
      final invoices = await _invoiceRepository.getEmployeeInvoices(
        limit: _invoicesPageSize,
        offset: _invoicesOffset,
        searchQuery: query,
      );

      if (mounted) {
        setState(() {
          if (loadMore) {
            _employeeInvoices.addAll(invoices);
          } else {
            _employeeInvoices = invoices;
          }
          _employeeInvoices.sort(
            (a, b) => b.fechaEmision.compareTo(a.fechaEmision),
          );

          _invoicesOffset += invoices.length;
          if (invoices.length < _invoicesPageSize) {
            _hasMoreInvoices = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Error al cargar las facturas del empleado: $e');
      if (mounted) {
        setState(() {
          if (!loadMore) {
            _invoicesErrorMessage =
                'Error al cargar el historial de servicios: $e';
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInvoices = false;
          _isLoadingMoreInvoices = false;
        });
      }
    }
  }

  Future<void> _loadNextHistoryPage({bool refresh = false}) async {
    if (_businessId == null || _employeeId == null) return;
    if (_isLoadingHistory) return;
    if (!refresh && !_hasMoreHistory) return;

    if (mounted) {
      setState(() {
        _isLoadingHistory = true;
        if (refresh) {
          _historyOffset = 0;
          _hasMoreHistory = true;
          _myHistoryOrders = [];
        }
      });
    }

    try {
      final orders = await _orderRepository.getEmployeeHistoryOrdersPaged(
        businessId: _businessId!,
        employeeId: _employeeId!,
        limit: _historyPageSize,
        offset: _historyOffset,
      );

      if (mounted) {
        setState(() {
          _myHistoryOrders.addAll(orders);
          // Ordenar el historial por fecha de reserva de más reciente a más antiguo
          _myHistoryOrders.sort(_compareOrdersByReservationDesc);

          _historyOffset += orders.length;
          if (orders.length < _historyPageSize) {
            _hasMoreHistory = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Error al cargar historial paginado: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  DateTime? _parseOrderDateTime(String dtStr) {
    try {
      final parts = dtStr.trim().split(' ');
      if (parts.length != 2) return null;
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 2) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  int _compareOrdersByReservation(WashGoOrder a, WashGoOrder b) {
    final parsedA = ParsedObservations.parse(a.observations);
    final parsedB = ParsedObservations.parse(b.observations);

    final dtA =
        _parseOrderDateTime(parsedA.dateTime) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final dtB =
        _parseOrderDateTime(parsedB.dateTime) ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final cmp = dtA.compareTo(dtB);
    if (cmp != 0) return cmp;
    return a.id.compareTo(b.id);
  }

  int _compareOrdersByReservationDesc(WashGoOrder a, WashGoOrder b) {
    final parsedA = ParsedObservations.parse(a.observations);
    final parsedB = ParsedObservations.parse(b.observations);

    final dtA =
        _parseOrderDateTime(parsedA.dateTime) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final dtB =
        _parseOrderDateTime(parsedB.dateTime) ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final cmp = dtB.compareTo(dtA);
    if (cmp != 0) return cmp;
    return b.id.compareTo(a.id);
  }

  String _normalizeSearchText(String text) {
    return text.replaceAll(RegExp(r'[#\-\s]'), '').toLowerCase();
  }

  List<WashGoOrder> get _filteredPendingQueue {
    List<WashGoOrder> list = _pendingQueue;

    if (_searchQuery.trim().length >= 3) {
      final cleanQuery = _searchQuery.trim().toLowerCase();
      final normalizedQuery = _normalizeSearchText(_searchQuery);
      list = list.where((order) {
        final code = _getOrderDisplayCode(order);
        final normalizedCode = _normalizeSearchText(code);
        final normalizedId = _normalizeSearchText(order.id);
        final serviceName = (order.serviceName ?? '').toLowerCase();
        final clientName = order.client.nombreCompleto.toLowerCase();
        return normalizedCode.contains(normalizedQuery) ||
            normalizedId.contains(normalizedQuery) ||
            serviceName.contains(cleanQuery) ||
            clientName.contains(cleanQuery);
      }).toList();
    }

    if (_selectedOrderTypeFilter != null) {
      list = list
          .where((order) => order.type == _selectedOrderTypeFilter)
          .toList();
    }

    if (_selectedScheduleFilter != null) {
      list = list.where((order) {
        final parsed = ParsedObservations.parse(order.observations);
        final isNow = parsed.scheduleType == 'Ahora mismo';
        return isNow == _selectedScheduleFilter;
      }).toList();
    }

    return list;
  }

  List<WashGoOrder> get _filteredMyActiveOrders {
    List<WashGoOrder> list = _myActiveOrders;

    if (_searchQuery.trim().length >= 3) {
      final cleanQuery = _searchQuery.trim().toLowerCase();
      final normalizedQuery = _normalizeSearchText(_searchQuery);
      list = list.where((order) {
        final code = _getOrderDisplayCode(order);
        final normalizedCode = _normalizeSearchText(code);
        final normalizedId = _normalizeSearchText(order.id);
        final serviceName = (order.serviceName ?? '').toLowerCase();
        final clientName = order.client.nombreCompleto.toLowerCase();
        return normalizedCode.contains(normalizedQuery) ||
            normalizedId.contains(normalizedQuery) ||
            serviceName.contains(cleanQuery) ||
            clientName.contains(cleanQuery);
      }).toList();
    }

    if (_selectedOrderTypeFilter != null) {
      list = list
          .where((order) => order.type == _selectedOrderTypeFilter)
          .toList();
    }

    if (_selectedScheduleFilter != null) {
      list = list.where((order) {
        final parsed = ParsedObservations.parse(order.observations);
        final isNow = parsed.scheduleType == 'Ahora mismo';
        return isNow == _selectedScheduleFilter;
      }).toList();
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeDashboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _ordersSubscription?.cancel();
    _approvalPollingTimer?.cancel();
    super.dispose();
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: AppColors.primary, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isSelected ? AppColors.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineFiltersPanel() {
    if (!_showFiltersPanel) return const SizedBox.shrink();
    return TapRegion(
      groupId: 'employee_filters',
      onTapOutside: (event) {
        setState(() {
          _showFiltersPanel = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Filtros de Búsqueda',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                if (_hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedOrderTypeFilter = null;
                        _selectedScheduleFilter = null;
                        _pendingLimit = 5;
                        _activeLimit = 5;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Restablecer',
                      style: GoogleFonts.inter(
                        color: Colors.red[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 36,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Servicio:',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildChoiceChip(
                        label: 'Todos',
                        isSelected: _selectedOrderTypeFilter == null,
                        onTap: () {
                          setState(() {
                            _selectedOrderTypeFilter = null;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                      _buildChoiceChip(
                        label: '🏢 En Local',
                        isSelected: _selectedOrderTypeFilter == OrderType.LOCAL,
                        onTap: () {
                          setState(() {
                            _selectedOrderTypeFilter = OrderType.LOCAL;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                      _buildChoiceChip(
                        label: '🚗 A Domicilio',
                        isSelected:
                            _selectedOrderTypeFilter == OrderType.DELIVERY,
                        onTap: () {
                          setState(() {
                            _selectedOrderTypeFilter = OrderType.DELIVERY;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 36,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Horario:',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildChoiceChip(
                        label: 'Todos',
                        isSelected: _selectedScheduleFilter == null,
                        onTap: () {
                          setState(() {
                            _selectedScheduleFilter = null;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                      _buildChoiceChip(
                        label: '⚡ Ahora Mismo',
                        isSelected: _selectedScheduleFilter == true,
                        onTap: () {
                          setState(() {
                            _selectedScheduleFilter = true;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                      _buildChoiceChip(
                        label: '📅 Programado',
                        isSelected: _selectedScheduleFilter == false,
                        onTap: () {
                          setState(() {
                            _selectedScheduleFilter = false;
                            _pendingLimit = 5;
                            _activeLimit = 5;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeDashboard({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final user = await _authRepository.getCurrentUser();

      if (user == null) {
        throw Exception('No se pudo encontrar la información del usuario.');
      }

      if (mounted) {
        setState(() {
          _employeeId = user.uid;
          _employeeName = user.nombreCompleto;
          _employeePhone = user.telefono;
          _employeeEmail = user.email;
          _userRoles = user.roles;
          _employeeStatus = user.employeeStatus;
        });
      }

      final currentBusinessId = user.currentBusinessId;
      final currentBusinessName = user.currentBusinessName;
      if (currentBusinessId == null) {
        if (_employeeStatus == EmployeeStatus.PENDING) {
          _businessId = null;
          _businessName = 'Lavandería';
          if (mounted) {
            setState(() {
              _pendingQueue = [];
              _myActiveOrders = [];
              _myHistoryOrders = [];
              _employeeInvoices = [];
              _invoicesOffset = 0;
              _hasMoreInvoices = true;
              _invoicesSearchQuery = '';
              _isLoading = false;
            });
          }
          return;
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage =
                  'No estás asociado a ninguna lavandería activa. Por favor, asóciate con un código de negocio.';
            });
          }
          return;
        }
      }

      _businessId = currentBusinessId;
      _businessName = currentBusinessName;

      if (_employeeStatus == EmployeeStatus.PENDING) {
        _startApprovalPolling();
        if (mounted) {
          setState(() {
            _pendingQueue = [];
            _myActiveOrders = [];
            _myHistoryOrders = [];
            _employeeInvoices = [];
            _invoicesOffset = 0;
            _hasMoreInvoices = true;
            _invoicesSearchQuery = '';
            _isLoading = false;
          });
        }
      } else {
        _approvalPollingTimer?.cancel();
        _approvalPollingTimer = null;
        _subscribeToOrders();

        await Future.wait([
          _fetchAvailability(),
          _loadNextHistoryPage(refresh: true),
          _loadEmployeeInvoices(refresh: true),
        ]);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error al cargar el panel';
        });
      }
    }
  }

  void _subscribeToOrders() {
    _ordersSubscription?.cancel();
    if (_businessId == null) return;

    _ordersSubscription = _orderRepository
        .watchBusinessOrders(_businessId!)
        .listen(
          (orders) {
            final pending = <WashGoOrder>[];
            final myActive = <WashGoOrder>[];

            for (final order in orders) {
              final status = order.status;
              final isEnCola = status == OrderStatus.EN_COLA;
              final isPendingPago = status == OrderStatus.PENDIENTE_PAGO;
              final orderEmployeeId = order.employee?.id;

              final isTransferenciaConComprobante = isPendingPago &&
                  order.paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA &&
                  order.paymentProofStatus != null;

              if ((isEnCola || isTransferenciaConComprobante) && orderEmployeeId == null) {
                pending.add(order);
              } else if (orderEmployeeId == _employeeId) {
                myActive.add(order);
              }
            }

            pending.sort(_compareOrdersByReservation);
            myActive.sort(_compareOrdersByReservation);

            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _pendingQueue = pending;
                    _myActiveOrders = myActive;
                    _isLoading = false;
                  });
                }
              });
            }
          },
          onError: (error) {
            debugPrint('Error en la suscripción de órdenes: $error');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error al sincronizar pedidos en tiempo real: $error',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        );
  }

  void _startApprovalPolling() {
    _approvalPollingTimer?.cancel();
    _approvalPollingTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final user = await _authRepository.getCurrentUser();
        if (user == null) return;
        final newStatus = user.employeeStatus;
        if (newStatus != EmployeeStatus.PENDING && mounted) {
          _approvalPollingTimer?.cancel();
          _approvalPollingTimer = null;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Has sido aprobado! Ya puedes empezar a recibir reservas.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
            _initializeDashboard();
          }
        }
      } catch (e) {
        debugPrint('Error en polling de aprobación: $e');
      }
    });
  }

  Future<void> _fetchOrders() async {
    if (_businessId == null) return;

    try {
      final orders = await _orderRepository.getBusinessOrders(_businessId!);

      // Separar pedidos
      final pending = <WashGoOrder>[];
      final myActive = <WashGoOrder>[];

      for (final order in orders) {
        final status = order.status;
        final isEnCola = status == OrderStatus.EN_COLA;
        final isPendingPago = status == OrderStatus.PENDIENTE_PAGO;
        final orderEmployeeId = order.employee?.id;

        final isTransferenciaConComprobante = isPendingPago &&
            order.paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA &&
            order.paymentProofStatus != null;

        if ((isEnCola || isTransferenciaConComprobante) && orderEmployeeId == null) {
          pending.add(order);
        } else if (orderEmployeeId == _employeeId) {
          myActive.add(order);
        }
      }

      pending.sort(_compareOrdersByReservation);
      myActive.sort(_compareOrdersByReservation);

      if (mounted) {
        setState(() {
          _pendingQueue = pending;
          _myActiveOrders = myActive;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al refrescar pedidos'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _fetchAvailability() async {
    if (_businessId == null ||
        _employeeId == null ||
        _employeeStatus == EmployeeStatus.PENDING)
      return;
    setState(() {
      _isLoadingAvailability = true;
    });
    try {
      final availability = await _businessRepository.getEmployeeAvailability(
        businessId: _businessId!,
        employeeId: _employeeId!,
      );
      if (availability != null) {
        setState(() {
          _isAvailable = availability.estadoDisponibilidad;
          _businessEmployeeRecordId = availability.id;
        });
      }
    } catch (e) {
      debugPrint('Error fetching employee availability: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAvailability = false;
        });
      }
    }
  }

  Future<void> _toggleAvailability(bool value) async {
    if (_businessEmployeeRecordId == null) return;
    setState(() {
      _isAvailable = value;
      _isLoadingAvailability = true;
    });
    try {
      await _businessRepository.updateEmployeeAvailability(
        recordId: _businessEmployeeRecordId!,
        available: value,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Estado cambiado a: DISPONIBLE'
                  : 'Estado cambiado a: EN RECESO / ALMUERZO',
            ),
            backgroundColor: value ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAvailable = !value; // Revert on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cambiar disponibilidad'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAvailability = false;
        });
      }
    }
  }

  Future<void> _acceptOrder(WashGoOrder order) async {
    if (_employeeId == null) return;

    if (order.status == OrderStatus.PENDIENTE_PAGO) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No puedes aceptar este pedido. Está pendiente de aprobación de pago por WashGo.',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No puedes aceptar pedidos mientras estés en descanso / almuerzo. Cambia tu estado a Disponible primero.',
          ),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Mostrar loader dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
    );

    try {
      // Intentar aceptar atómicamente el pedido
      await _orderRepository.acceptOrder(
        orderId: order.id,
        employeeId: _employeeId!,
      );

      if (!mounted) return;
      Navigator.pop(context); // Quitar dialog de carga

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Pedido aceptado exitosamente! Se ha movido a tu sección de pedidos.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Refrescar pedidos
      _fetchOrders();
      // Ir a la pestaña "Mis Pedidos"
      _tabController.animateTo(1);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Quitar loader

      // Si falla, significa que otro empleado pudo haberlo tomado primero o error de red
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No se pudo aceptar el pedido'),
          content: Text(
            'Es posible que otro empleado haya aceptado este pedido al mismo tiempo o haya ocurrido un error: ${e.toString()}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _fetchOrders();
              },
              child: const Text('Entendido y Actualizar'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateOrderStatus(
    WashGoOrder order,
    OrderStatus newStatus,
  ) async {
    // Mostrar loader dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
    );

    try {
      await _orderRepository.updateOrderStatus(
        orderId: order.id,
        status: newStatus,
      );

      if (!mounted) return;
      Navigator.pop(context);

      String statusMsg = '';
      if (newStatus == OrderStatus.EN_CAMINO) {
        statusMsg = '¡Pedido en camino al domicilio!';
      } else if (newStatus == OrderStatus.EN_SERVICIO) {
        statusMsg = '¡Lavado iniciado!';
      } else if (newStatus == OrderStatus.COMPLETADO) {
        statusMsg = '¡Pedido completado y entregado!';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(statusMsg), backgroundColor: AppColors.primary),
      );

      _fetchOrders();
      if (newStatus == OrderStatus.COMPLETADO ||
          newStatus == OrderStatus.CANCELADO) {
        _loadNextHistoryPage(refresh: true);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cambiar el estado del pedido'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _showCompletionDialog(WashGoOrder order) async {
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Finalizar y Entregar Pedido',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Por favor, ingresa observaciones sobre el servicio prestado (ej. daños previos, productos especiales usados, detalles de entrega):',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Ej. Vehículo entregado impecable, champú biodegradable premium...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Confirmar y Facturar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      // Show loader dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PopScope(
          canPop: false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Generando factura digital...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        final employeeName = _employeeName ?? 'Empleado';
        final employeeId = _employeeId ?? '';
        final businessId = _businessId ?? order.businessId;

        // Fetch client email if phone is available
        String? clientEmail;
        if (order.client.telefono != null &&
            order.client.telefono!.isNotEmpty) {
          try {
            final clientInfo = await _orderRepository.findUserByPhone(
              order.client.telefono!,
            );
            clientEmail = clientInfo?.email;
          } catch (_) {}
        }

        // Call the repo method that generates the invoice, uploads it, updates DB, and updates order status.
        await _invoiceRepository.completeOrderWithInvoice(
          orderId: order.id,
          originalObservations: order.observations ?? '',
          employeeNotes: notesController.text,
          price: order.price,
          serviceName: order.serviceName ?? 'Servicio de Lavado',
          paymentMethod: order.paymentMethod.name,
          businessId: businessId,
          employeeId: employeeId,
          employeeName: employeeName,
          clientName: order.client.nombreCompleto,
          clientEmail: clientEmail,
          clientPhone: order.client.telefono,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loader

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Pedido completado y factura digital generada con éxito!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        _fetchOrders();
        _loadNextHistoryPage(refresh: true);
        _loadEmployeeInvoices(refresh: true);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al finalizar el pedido y generar la factura: $e',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este cliente no tiene teléfono registrado.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo realizar la llamada telefónica.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este cliente no tiene teléfono registrado.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri.parse('whatsapp://send?phone=$formattedPhone');
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        final Uri webUri = Uri.parse('https://wa.me/$formattedPhone');
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudo abrir WhatsApp.'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.LOCAL:
        return 'Local';
      case OrderType.DELIVERY:
        return 'Domicilio / Delivery';
    }
  }

  String _getPaymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.PAYPAL:
        return 'PayPal';
      case PaymentMethod.CASH:
        return 'Efectivo';
      case PaymentMethod.TRANSFERENCIA_BANCARIA:
        return 'Transferencia';
      case PaymentMethod.PAYPHONE:
        return 'PayPhone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _businessName ?? 'WashGo',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Panel del Empleado • ${_employeeName ?? ""}',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        bottom:
            (_currentNavIndex == 0 && _employeeStatus != EmployeeStatus.PENDING)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: TapRegion(
                  groupId: 'employee_filters',
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                  _pendingLimit = 5;
                                  _activeLimit = 5;
                                });
                              },
                              decoration: InputDecoration(
                                hintText:
                                    'Buscar por código, servicio o cliente...',
                                hintStyle: GoogleFonts.inter(
                                  color: AppColors.outline,
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear_rounded,
                                          color: AppColors.outline,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                            _pendingLimit = 5;
                                            _activeLimit = 5;
                                          });
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: SizedBox(
                            height: 52,
                            width: 52,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: _hasActiveFilters
                                          ? AppColors.primary
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: _hasActiveFilters
                                            ? AppColors.primary
                                            : AppColors.outlineVariant
                                                  .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _showFiltersPanel
                                            ? Icons.filter_list_off_rounded
                                            : Icons.filter_list_rounded,
                                        color: _hasActiveFilters
                                            ? Colors.white
                                            : AppColors.primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showFiltersPanel =
                                              !_showFiltersPanel;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                if (_hasActiveFilters)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '$_activeFiltersCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: _buildBody(),
      floatingActionButton:
          (_currentNavIndex == 0 && _employeeStatus != EmployeeStatus.PENDING)
          ? FloatingActionButton.extended(
              onPressed: _showCreateWalkInOrderDialog,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                'Pedido Presencial',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Historial de Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return _buildErrorScreen();
    }

    Widget content;
    switch (_currentNavIndex) {
      case 0:
        content = _buildTareasSection();
        break;
      case 1:
        content = _buildHistoryTab();
        break;
      case 2:
        content = _buildProfileTab();
        break;
      default:
        content = const SizedBox.shrink();
    }

    if (_employeeStatus == EmployeeStatus.PENDING) {
      return Column(
        children: [
          _buildPendingWarningBanner(),
          Expanded(child: content),
        ],
      );
    }

    return content;
  }

  Widget _buildPendingWarningBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade200.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber.shade800,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cuenta Pendiente de Aprobación',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Debe esperar que el dueño le acepte para empezar a recibir las reservas.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.amber.shade900.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTareasSection() {
    if (_employeeStatus == EmployeeStatus.PENDING) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_late_rounded,
                  size: 80,
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sin Tareas Disponibles',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Una vez que el dueño te acepte en la lavandería, podrás visualizar y tomar los pedidos en cola aquí.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildInlineFiltersPanel(),
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.list_alt_rounded),
                    const SizedBox(width: 8),
                    const Text('Pedidos en Cola'),
                    const SizedBox(width: 6),
                    AnimatedOpacity(
                      opacity: _filteredPendingQueue.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_filteredPendingQueue.isEmpty ? 0 : _filteredPendingQueue.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_car_wash_rounded),
                    const SizedBox(width: 8),
                    const Text('Mis Pedidos'),
                    const SizedBox(width: 6),
                    AnimatedOpacity(
                      opacity: _filteredMyActiveOrders.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_filteredMyActiveOrders.isEmpty ? 0 : _filteredMyActiveOrders.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _pendingLimit = 5;
                _activeLimit = 5;
              });
              await Future.wait([_fetchOrders(), _fetchAvailability()]);
            },
            color: AppColors.primary,
            child: TabBarView(
              controller: _tabController,
              children: [_buildPendingQueueTab(), _buildMyOrdersTab()],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return EmployeeHistoryTab(
      employeeStatus: _employeeStatus,
      isLoadingInvoices: _isLoadingInvoices,
      isLoadingMoreInvoices: _isLoadingMoreInvoices,
      hasMoreInvoices: _hasMoreInvoices,
      invoicesErrorMessage: _invoicesErrorMessage,
      employeeInvoices: _employeeInvoices,
      onRefreshInvoices: () => _loadEmployeeInvoices(refresh: true),
      onLoadMoreInvoices: () => _loadEmployeeInvoices(loadMore: true),
      onSearchChanged: (query) => _loadEmployeeInvoices(searchQuery: query),
    );
  }

  Widget _buildProfileTab() {
    return EmployeeProfileTab(
      employeeStatus: _employeeStatus,
      isAvailable: _isAvailable,
      isLoadingAvailability: _isLoadingAvailability,
      employeeName: _employeeName,
      employeePhone: _employeePhone,
      employeeEmail: _employeeEmail,
      userRoles: _userRoles,
      authRepository: _authRepository,
      onToggleAvailability: _toggleAvailability,
      onRefreshDashboard: () => _initializeDashboard(silent: true),
      onProfileUpdated: (name, phone) {
        setState(() {
          _employeeName = name;
          _employeePhone = phone;
        });
      },
    );
  }

  Widget _buildErrorScreen() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: AppColors.warning,
            ),
            const SizedBox(height: 24),
            Text(
              'Aviso Importante',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _initializeDashboard,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                context.go('/onboarding-employee');
              },
              child: const Text('Ir a Onboarding (Ingresar Código)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingQueueTab() {
    final list = _filteredPendingQueue;
    if (list.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isNotEmpty
                      ? Icons.search_off_rounded
                      : Icons.assignment_turned_in_outlined,
                  size: 72,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No se encontraron resultados'
                      : '¡No hay pedidos en cola!',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    _searchQuery.isNotEmpty
                        ? 'Prueba buscando con otro término o código.'
                        : 'Todos los pedidos de los clientes están siendo atendidos. Desliza hacia abajo para refrescar.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final displayCount = list.length > _pendingLimit
        ? _pendingLimit
        : list.length;
    final showLoadMore = list.length > _pendingLimit;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: displayCount + (showLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayCount) {
          return _buildLoadMoreButton(
            currentLimit: _pendingLimit,
            totalLength: list.length,
            onTap: () {
              setState(() {
                _pendingLimit += 5;
              });
            },
          );
        }
        final order = list[index];
        final orderType = order.type;
        final payment = order.paymentMethod;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: orderType == OrderType.DELIVERY
                                ? Colors.purple.withValues(alpha: 0.1)
                                : Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                orderType == OrderType.DELIVERY
                                    ? Icons.directions_bike_rounded
                                    : Icons.store_rounded,
                                size: 14,
                                color: orderType == OrderType.DELIVERY
                                    ? Colors.purple
                                    : Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getOrderTypeLabel(orderType),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: orderType == OrderType.DELIVERY
                                      ? Colors.purple
                                      : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getOrderDisplayCode(order),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),

                      ],
                    ),
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  order.serviceName ?? 'Servicio de Lavado',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Cliente: ${order.client.nombreCompleto}',
                      style: const TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.payment_rounded,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Método: ${_getPaymentMethodLabel(payment)}',
                      style: const TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                if (order.paymentMethod ==
                        PaymentMethod.TRANSFERENCIA_BANCARIA &&
                    order.paymentProofStatus != null) ...[
                  const SizedBox(height: 8),
                  _buildPaymentProofBadge(order.paymentProofStatus!),
                ],
                if (order.observations != null &&
                    order.observations!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final parsed = ParsedObservations.parse(
                        order.observations,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  parsed.scheduleType == 'Ahora mismo'
                                      ? Icons.flash_on_rounded
                                      : Icons.calendar_today_rounded,
                                  color: AppColors.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Reservado: ${parsed.scheduleType}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  parsed.dateTime,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Vehículo: ${parsed.vehicleDetails}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (parsed.rescheduleHistory.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.history_rounded,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          parsed.rescheduleHistory.length > 1
                                              ? 'El usuario reprogramó el servicio. Fechas anteriores:'
                                              : 'El usuario reprogramó el servicio. Fecha anterior:',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber[900] ?? Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    parsed.rescheduleHistory.join(' ➔ '),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                if (order.status == OrderStatus.PENDIENTE_PAGO) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No disponible: Esperando que WashGo apruebe el pago.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () => _acceptOrder(order),
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Aceptar Pedido',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyOrdersTab() {
    final list = _filteredMyActiveOrders;
    if (list.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isNotEmpty
                      ? Icons.search_off_rounded
                      : Icons.local_car_wash_outlined,
                  size: 72,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No se encontraron resultados'
                      : 'Aún no tienes pedidos aceptados',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    _searchQuery.isNotEmpty
                        ? 'Prueba buscando con otro término o código.'
                        : 'Ve a la pestaña "Pedidos en Cola" para aceptar nuevos trabajos disponibles.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final displayCount = list.length > _activeLimit
        ? _activeLimit
        : list.length;
    final showLoadMore = list.length > _activeLimit;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: displayCount + (showLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayCount) {
          return _buildLoadMoreButton(
            currentLimit: _activeLimit,
            totalLength: list.length,
            onTap: () {
              setState(() {
                _activeLimit += 5;
              });
            },
          );
        }
        final order = list[index];
        final orderType = order.type;
        final status = order.status;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.orange.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildStatusBadge(status),
                        const SizedBox(width: 8),
                        Text(
                          _getOrderDisplayCode(order),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),

                      ],
                    ),
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  order.serviceName ?? 'Servicio de Lavado',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        backgroundImage:
                            order.client.fotoPerfil != null &&
                                order.client.fotoPerfil!.isNotEmpty
                            ? CachedNetworkImageProvider(
                                order.client.fotoPerfil!,
                              )
                            : null,
                        child:
                            order.client.fotoPerfil == null ||
                                order.client.fotoPerfil!.isEmpty
                            ? Text(
                                order.client.nombreCompleto
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.client.nombreCompleto,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cliente • ${_getOrderTypeLabel(orderType)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _makeCall(order.client.telefono),
                        icon: const Icon(
                          Icons.phone_rounded,
                          color: Colors.green,
                        ),
                        tooltip: 'Llamar al cliente',
                      ),
                      IconButton(
                        onPressed: () => _openWhatsApp(order.client.telefono),
                        icon: const Icon(
                          Icons.message_rounded,
                          color: Colors.green,
                        ),
                        tooltip: 'WhatsApp al cliente',
                      ),
                    ],
                  ),
                ),
                if (order.paymentMethod ==
                        PaymentMethod.TRANSFERENCIA_BANCARIA &&
                    order.paymentProofStatus != null) ...[
                  const SizedBox(height: 8),
                  _buildPaymentProofBadge(order.paymentProofStatus!),
                ],
                if (order.observations != null &&
                    order.observations!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final parsed = ParsedObservations.parse(
                        order.observations,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  parsed.scheduleType == 'Ahora mismo'
                                      ? Icons.flash_on_rounded
                                      : Icons.calendar_today_rounded,
                                  color: AppColors.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Reservado: ${parsed.scheduleType}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  parsed.dateTime,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Vehículo: ${parsed.vehicleDetails}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (parsed.rescheduleHistory.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.history_rounded,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          parsed.rescheduleHistory.length > 1
                                              ? 'El usuario reprogramó el servicio. Fechas anteriores:'
                                              : 'El usuario reprogramó el servicio. Fecha anterior:',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber[900] ?? Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    parsed.rescheduleHistory.join(' ➔ '),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                _buildActionButtonsForStatus(order, status, orderType),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color = Colors.grey;
    String text = '';

    switch (status) {
      case OrderStatus.PENDIENTE_PAGO:
        color = Colors.amber;
        text = 'Pendiente de Pago';
        break;
      case OrderStatus.EN_COLA:
        color = Colors.blue;
        text = 'En Cola';
        break;
      case OrderStatus.ACEPTADO:
        color = Colors.orange;
        text = 'Aceptado';
        break;
      case OrderStatus.EN_CAMINO:
        color = Colors.purple;
        text = 'En Camino';
        break;
      case OrderStatus.EN_SERVICIO:
        color = Colors.teal;
        text = 'En Servicio';
        break;
      case OrderStatus.COMPLETADO:
        color = Colors.green;
        text = 'Completado';
        break;
      case OrderStatus.CANCELADO:
        color = Colors.red;
        text = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentProofBadge(PaymentProofStatus proofStatus) {
    Color color;
    String label;
    IconData icon;

    switch (proofStatus) {
      case PaymentProofStatus.PENDING:
        color = Colors.amber;
        label = 'Comprobante: Pendiente de revisión';
        icon = Icons.hourglass_empty_rounded;
      case PaymentProofStatus.APPROVED:
        color = Colors.green;
        label = 'Comprobante: Aprobado';
        icon = Icons.check_circle_rounded;
      case PaymentProofStatus.REJECTED:
        color = Colors.red;
        label = 'Comprobante: Rechazado';
        icon = Icons.cancel_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsForStatus(
    WashGoOrder order,
    OrderStatus status,
    OrderType type,
  ) {
    if (status == OrderStatus.ACEPTADO) {
      if (type == OrderType.DELIVERY) {
        return ElevatedButton.icon(
          onPressed: () => _updateOrderStatus(order, OrderStatus.EN_CAMINO),
          icon: const Icon(Icons.directions_bike_rounded, color: Colors.white),
          label: const Text(
            'Iniciar Ruta (En Camino)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        return ElevatedButton.icon(
          onPressed: () => _updateOrderStatus(order, OrderStatus.EN_SERVICIO),
          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          label: const Text(
            'Iniciar Servicio / Lavado',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else if (status == OrderStatus.EN_CAMINO) {
      return ElevatedButton.icon(
        onPressed: () => _updateOrderStatus(order, OrderStatus.EN_SERVICIO),
        icon: const Icon(Icons.home_work_rounded, color: Colors.white),
        label: const Text(
          'Llegué al Domicilio / Iniciar Servicio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (status == OrderStatus.EN_SERVICIO) {
      return ElevatedButton.icon(
        onPressed: () => _showCompletionDialog(order),
        icon: const Icon(Icons.done_all_rounded, color: Colors.white),
        label: const Text(
          'Completar y Entregar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (status == OrderStatus.PENDIENTE_PAGO) {
      final isTransfer =
          order.paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTransfer && order.paymentProofStatus != null) ...[
            _buildPaymentProofBadge(order.paymentProofStatus!),
            const SizedBox(height: 8),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber.shade700,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isTransfer && order.paymentProofStatus != null
                        ? 'Esperando aprobación del comprobante de pago por el superadmin'
                        : 'Esperando confirmación de pago',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _showCreateWalkInOrderDialog() async {
    if (_businessId == null) return;

    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CreateWalkInOrderDialog(
        businessId: _businessId!,
        businessRepository: _businessRepository,
        orderRepository: _orderRepository,
      ),
    );

    if (created == true) {
      if (mounted) {
        _fetchOrders();
      }
    }
  }
}

class _CreateWalkInOrderDialog extends StatefulWidget {
  final String businessId;
  final BusinessRepository businessRepository;
  final OrderRepository orderRepository;

  const _CreateWalkInOrderDialog({
    required this.businessId,
    required this.businessRepository,
    required this.orderRepository,
  });

  @override
  State<_CreateWalkInOrderDialog> createState() =>
      _CreateWalkInOrderDialogState();
}

class _CreateWalkInOrderDialogState extends State<_CreateWalkInOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _notesController = TextEditingController();

  List<WashGoService> _services = [];
  WashGoService? _selectedService;
  String _selectedCategory = 'Pequeño';
  OrderType _orderType = OrderType.LOCAL;
  PaymentMethod _paymentMethod = PaymentMethod.CASH;
  bool _isLoadingServices = true;
  bool _isSubmitting = false;
  String? _serviceError;

  bool _isSearchingPhone = false;
  bool? _clientExists;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _searchClientByPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un número de teléfono primero'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSearchingPhone = true;
      _clientExists = null;
    });

    try {
      final clientInfo = await widget.orderRepository.findUserByPhone(phone);
      if (mounted) {
        setState(() {
          _isSearchingPhone = false;
          if (clientInfo != null) {
            _clientExists = true;
            _nameController.text = clientInfo.nombreCompleto;
          } else {
            _clientExists = false;
            _nameController.clear();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearchingPhone = false;
          _clientExists = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al buscar cliente'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    try {
      final services = await widget.businessRepository.getBusinessServices(
        widget.businessId,
      );
      if (mounted) {
        setState(() {
          _services = services.where((s) => s.activo).toList();
          _isLoadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingServices = false;
          _serviceError = 'Error al cargar servicios';
        });
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona un servicio'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();
      final vehicle = _vehicleController.text.trim();
      final notes = _notesController.text.trim();

      // Buscar si el cliente ya existe por teléfono
      final clientInfo = await widget.orderRepository.findUserByPhone(phone);
      String? clientId = clientInfo?.id;

      if (clientId == null) {
        // Generar un correo único ficticio
        final email = '$phone@washgo.invitado';
        // Crear cliente invitado/presencial
        clientId = await widget.orderRepository.createWalkInUser(
          nombreCompleto: name,
          telefono: phone,
          email: email,
        );
      }

      // Estructurar observaciones
      final dateStr = _formatDateTime(DateTime.now());
      String observations = 'Ahora mismo ($dateStr) - Vehículo: $vehicle';
      if (notes.isNotEmpty) {
        observations += ' - Obs: $notes';
      }

      // Crear la orden
      await widget.orderRepository.createWalkInOrder(
        businessId: widget.businessId,
        clientId: clientId,
        price: _selectedService!.getPriceForCategory(_selectedCategory),
        costo: _selectedService!.getPriceForCategory(_selectedCategory),
        serviceName: _selectedService!.nombre,
        type: _orderType,
        paymentMethod: _paymentMethod,
        observations: observations,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar pedido'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: _isLoadingServices
            ? const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : _serviceError != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(_serviceError!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoadingServices = true;
                        _serviceError = null;
                      });
                      _loadServices();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Registrar Pedido Presencial',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registra un pedido recibido directamente en el local para clientes nuevos o recurrentes.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const Divider(height: 24),

                      // Teléfono
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono / Celular *',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          suffixIcon: _isSearchingPhone
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: 'Buscar cliente',
                                  onPressed: _searchClientByPhone,
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          if (_clientExists != null) {
                            setState(() {
                              _clientExists = null;
                            });
                          }
                        },
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa el teléfono';
                          }
                          if (val.trim().length < 7) {
                            return 'El teléfono debe tener al menos 7 dígitos';
                          }
                          return null;
                        },
                      ),
                      if (_clientExists != null) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _clientExists == true
                                ? 'Cliente encontrado'
                                : 'Cliente no registrado aún',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _clientExists == true
                                  ? const Color(0xFF10B981)
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Nombre completo
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Cliente *',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa el nombre del cliente';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Vehículo
                      TextFormField(
                        controller: _vehicleController,
                        decoration: InputDecoration(
                          labelText: 'Detalles del Vehículo *',
                          hintText: 'Ej. Toyota Corolla Rojo - ABC-123',
                          prefixIcon: const Icon(Icons.directions_car_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa los detalles del vehículo';
                          }
                          return null;
                        },
                      ),
                      // Selector de categoría de vehículo
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Categoría de Vehículo *',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Pequeño',
                            child: Text('Pequeño'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Mediano',
                            child: Text('Mediano'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Grande',
                            child: Text('Grande'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Moto',
                            child: Text('Moto'),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val ?? 'Pequeño';
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Selecciona una categoría';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Selector de servicio
                      DropdownButtonFormField<WashGoService>(
                        initialValue: _selectedService,
                        decoration: InputDecoration(
                          labelText: 'Servicio *',
                          prefixIcon: const Icon(Icons.local_car_wash_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _services.map((service) {
                          return DropdownMenuItem<WashGoService>(
                            value: service,
                            child: Text(
                              '${service.nombre} (\$${service.getPriceForCategory(_selectedCategory).toStringAsFixed(2)})',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedService = val;
                          });
                        },
                        validator: (val) {
                          if (val == null) {
                            return 'Selecciona un servicio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tipo de orden (Local / Domicilio)
                      DropdownButtonFormField<OrderType>(
                        initialValue: _orderType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Entrega *',
                          prefixIcon: const Icon(Icons.store_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<OrderType>(
                            value: OrderType.LOCAL,
                            child: Text('En el Local'),
                          ),
                          DropdownMenuItem<OrderType>(
                            value: OrderType.DELIVERY,
                            child: Text('A Domicilio'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _orderType = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Método de Pago (Efectivo / PayPal)
                      DropdownButtonFormField<PaymentMethod>(
                        initialValue: _paymentMethod,
                        decoration: InputDecoration(
                          labelText: 'Método de Pago *',
                          prefixIcon: const Icon(Icons.payment_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<PaymentMethod>(
                            value: PaymentMethod.CASH,
                            child: Text('Efectivo'),
                          ),
                          DropdownMenuItem<PaymentMethod>(
                            value: PaymentMethod.PAYPAL,
                            child: Text('PayPal'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _paymentMethod = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Notas opcionales
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notas adicionales (Opcional)',
                          hintText: 'Ej. Cuidado con el espejo izquierdo',
                          prefixIcon: const Icon(Icons.notes_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),

                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              minimumSize: const Size(0, 48),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Registrar Pedido',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
