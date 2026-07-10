import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/invoices/repositories/invoice_repository.dart';
import 'package:washgo/features/invoices/utils/csv_exporter.dart';
import 'package:washgo/features/laundries/models/active_employee.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class OwnerBillingTab extends StatefulWidget {
  final String businessId;
  final List<ActiveEmployee> activeEmployees;

  const OwnerBillingTab({
    super.key,
    required this.businessId,
    required this.activeEmployees,
  });

  @override
  State<OwnerBillingTab> createState() => _OwnerBillingTabState();
}

class _OwnerBillingTabState extends State<OwnerBillingTab> {
  final InvoiceRepository _invoiceRepository = FirebaseInvoiceRepository();

  List<InvoiceModel> _filteredInvoices = [];

  // Precomputed Billing Metrics to avoid recalculating in build()
  double _totalBilled = 0.0;
  int _completedCount = 0;
  double _cashTotal = 0.0;
  double _paypalTotal = 0.0;
  double _bankTransferTotal = 0.0;
  double _averageTicket = 0.0;
  List<_EmployeeStat> _sortedStats = [];

  void _updateMetrics() {
    double totalBilled = 0.0;
    int completedCount = 0;
    double cashTotal = 0.0;
    double paypalTotal = 0.0;
    double bankTransferTotal = 0.0;

    for (final inv in _filteredInvoices) {
      totalBilled += inv.total;
      if (inv.invoiceStatus == InvoiceStatus.GENERATED) {
        completedCount++;
      }
      final paymentUpper = inv.paymentMethod.toUpperCase();
      if (paymentUpper == 'CASH' || paymentUpper == 'EFECTIVO') {
        cashTotal += inv.total;
      } else if (paymentUpper == 'PAYPAL') {
        paypalTotal += inv.total;
      } else if (paymentUpper.contains('TRANSFERENCIA')) {
        bankTransferTotal += inv.total;
      }
    }

    double averageTicket = _filteredInvoices.isNotEmpty ? totalBilled / _filteredInvoices.length : 0.0;

    final Map<String, _EmployeeStat> empStats = {};
    for (final inv in _filteredInvoices) {
      final empName = inv.employeeName ?? 'Sin asignar';
      if (!empStats.containsKey(empName)) {
        empStats[empName] = _EmployeeStat(name: empName);
      }
      empStats[empName]!.servicesCount++;
      empStats[empName]!.totalBilled += inv.total;
    }

    final sortedStats = empStats.values.toList()
      ..sort((a, b) => b.totalBilled.compareTo(a.totalBilled));

    _totalBilled = totalBilled;
    _completedCount = completedCount;
    _cashTotal = cashTotal;
    _paypalTotal = paypalTotal;
    _bankTransferTotal = bankTransferTotal;
    _averageTicket = averageTicket;
    _sortedStats = sortedStats;
  }

  bool _isInitialLoading = true;
  String? _errorMessage;

  // Pagination & Scroll States
  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  // Filter States
  String _searchQuery = '';
  String _selectedDateFilter = 'Todas'; // 'Todas', '7dias', '30dias', 'rango'
  DateTimeRange? _selectedDateRange;
  String? _selectedEmployeeName = 'all'; // 'all' or actual employee name
  String _selectedPaymentMethod = 'Todos'; // 'Todos', 'Efectivo', 'PayPal', 'Transferencia'
  String _selectedStatus = 'Todos'; // 'Todos', 'Emitida', 'Pendiente', 'Fallo'

  final TextEditingController _searchController = TextEditingController();
  bool _showAdvancedFilters = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInvoices();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isFetchingMore && _hasMore && !_isInitialLoading) {
        _fetchInvoices(isLoadMore: true);
      }
    }
  }

  Future<void> _fetchInvoices({bool isLoadMore = false}) async {
    if (!mounted) return;

    if (isLoadMore) {
      if (_isFetchingMore || !_hasMore) return;
      setState(() {
        _isFetchingMore = true;
      });
    } else {
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;
        _offset = 0;
        _hasMore = true;
      });
    }

    try {
      // 1. Map employee name to ID
      String? employeeId;
      if (_selectedEmployeeName != null && _selectedEmployeeName != 'all') {
        try {
          final activeEmp = widget.activeEmployees.firstWhere(
            (emp) => emp.employee.nombreCompleto == _selectedEmployeeName,
          );
          employeeId = activeEmp.employee.id;
        } catch (_) {}
      }

      // 2. Map date filter to range
      DateTime? startDate;
      DateTime? endDate;
      final now = DateTime.now();
      if (_selectedDateFilter == '7dias') {
        startDate = now.subtract(const Duration(days: 7));
      } else if (_selectedDateFilter == '30dias') {
        startDate = now.subtract(const Duration(days: 30));
      } else if (_selectedDateFilter == 'rango' && _selectedDateRange != null) {
        startDate = _selectedDateRange!.start;
        endDate = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);
      }

      // 3. Map payment method
      PaymentMethod? paymentMethod;
      if (_selectedPaymentMethod != 'Todos') {
        if (_selectedPaymentMethod == 'Efectivo') {
          paymentMethod = PaymentMethod.CASH;
        } else if (_selectedPaymentMethod == 'Transferencia') {
          paymentMethod = PaymentMethod.TRANSFERENCIA_BANCARIA;
        } else {
          paymentMethod = PaymentMethod.PAYPAL;
        }
      }

      // 4. Map status
      InvoiceStatus? status;
      if (_selectedStatus != 'Todos') {
        if (_selectedStatus == 'Emitida') {
          status = InvoiceStatus.GENERATED;
        } else if (_selectedStatus == 'Pendiente') {
          status = InvoiceStatus.PENDING;
        } else {
          status = InvoiceStatus.FAILED;
        }
      }

      // 5. Query Search
      final searchQuery = _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null;

      final invoices = await _invoiceRepository.getBusinessInvoices(
        widget.businessId,
        limit: _limit,
        offset: _offset,
        employeeId: employeeId,
        startDate: startDate,
        endDate: endDate,
        paymentMethod: paymentMethod,
        status: status,
        searchQuery: searchQuery,
      );

      // Sort newest first
      invoices.sort((a, b) => b.fechaEmision.compareTo(a.fechaEmision));

      if (mounted) {
        setState(() {
          if (isLoadMore) {
            _filteredInvoices.addAll(invoices);
            _isFetchingMore = false;
          } else {
            _filteredInvoices = invoices;
            _isInitialLoading = false;
          }
          _offset += invoices.length;
          _hasMore = invoices.length == _limit;
          _updateMetrics();
        });
      }
    } catch (e) {
      debugPrint('Error fetching business invoices: $e');
      if (mounted) {
        setState(() {
          if (isLoadMore) {
            _isFetchingMore = false;
          } else {
            _errorMessage = 'No pudimos cargar las facturas de tu negocio. Intenta de nuevo.';
            _isInitialLoading = false;
          }
        });
      }
    }
  }

  void _applyFilters() {
    _fetchInvoices(isLoadMore: false);
  }

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String _formatJustDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    return '$day/$month/$year';
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateFilter = 'rango';
        _selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedDateFilter = 'Todas';
      _selectedDateRange = null;
      _selectedEmployeeName = 'all';
      _selectedPaymentMethod = 'Todos';
      _selectedStatus = 'Todos';
      _searchController.clear();
    });
    _applyFilters();
  }

  Future<void> _exportAllToCsv() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparando exportación de CSV...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      String? employeeId;
      if (_selectedEmployeeName != null && _selectedEmployeeName != 'all') {
        try {
          final activeEmp = widget.activeEmployees.firstWhere(
            (emp) => emp.employee.nombreCompleto == _selectedEmployeeName,
          );
          employeeId = activeEmp.employee.id;
        } catch (_) {}
      }

      DateTime? startDate;
      DateTime? endDate;
      final now = DateTime.now();
      if (_selectedDateFilter == '7dias') {
        startDate = now.subtract(const Duration(days: 7));
      } else if (_selectedDateFilter == '30dias') {
        startDate = now.subtract(const Duration(days: 30));
      } else if (_selectedDateFilter == 'rango' && _selectedDateRange != null) {
        startDate = _selectedDateRange!.start;
        endDate = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);
      }

      PaymentMethod? paymentMethod;
      if (_selectedPaymentMethod != 'Todos') {
        if (_selectedPaymentMethod == 'Efectivo') {
          paymentMethod = PaymentMethod.CASH;
        } else if (_selectedPaymentMethod == 'Transferencia') {
          paymentMethod = PaymentMethod.TRANSFERENCIA_BANCARIA;
        } else {
          paymentMethod = PaymentMethod.PAYPAL;
        }
      }

      InvoiceStatus? status;
      if (_selectedStatus != 'Todos') {
        if (_selectedStatus == 'Emitida') {
          status = InvoiceStatus.GENERATED;
        } else if (_selectedStatus == 'Pendiente') {
          status = InvoiceStatus.PENDING;
        } else {
          status = InvoiceStatus.FAILED;
        }
      }

      final searchQuery = _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null;

      final allMatchingInvoices = await _invoiceRepository.getBusinessInvoices(
        widget.businessId,
        limit: null,
        offset: null,
        employeeId: employeeId,
        startDate: startDate,
        endDate: endDate,
        paymentMethod: paymentMethod,
        status: status,
        searchQuery: searchQuery,
      );

      allMatchingInvoices.sort((a, b) => b.fechaEmision.compareTo(a.fechaEmision));

      await CsvExporter.exportInvoicesCsv(allMatchingInvoices);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar CSV: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 60),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchInvoices,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchInvoices,
      color: AppColors.primary,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Filter Header
              _buildFilterHeader(),
              const SizedBox(height: 16),

              // Active Filters indicator
              if (_searchQuery.isNotEmpty ||
                  _selectedDateFilter != 'Todas' ||
                  _selectedEmployeeName != 'all' ||
                  _selectedPaymentMethod != 'Todos' ||
                  _selectedStatus != 'Todos')
                _buildActiveFiltersRow(),

              // Advanced Filters Panel
              if (_showAdvancedFilters) ...[
                const SizedBox(height: 12),
                _buildAdvancedFiltersPanel(),
              ],
              const SizedBox(height: 24),

              // Metrics Grid Section
              _buildMetricsGrid(
                totalBilled: _totalBilled,
                invoiceCount: _filteredInvoices.length,
                completedCount: _completedCount,
                averageTicket: _averageTicket,
                cashTotal: _cashTotal,
                paypalTotal: _paypalTotal,
                bankTransferTotal: _bankTransferTotal,
              ),
              const SizedBox(height: 28),

              // Employee Stats / Leaderboard
              if (_sortedStats.isNotEmpty) ...[
                _buildEmployeeLeaderboard(_sortedStats),
                const SizedBox(height: 28),
              ],

              // Invoices List Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Facturas (${_filteredInvoices.length})',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_filteredInvoices.isNotEmpty)
                    TextButton.icon(
                      onPressed: _exportAllToCsv,
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Exportar CSV'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Invoice List
              if (_filteredInvoices.isEmpty)
                _buildEmptyState()
              else ...[
                _buildInvoicesList(),
                if (_isFetchingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                  if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                    _applyFilters();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por factura, cliente o servicio...',
                  hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                  _applyFilters();
                },
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                _showAdvancedFilters ? Icons.filter_alt_off_rounded : Icons.filter_alt_rounded,
                color: _showAdvancedFilters ? AppColors.primary : AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _showAdvancedFilters = !_showAdvancedFilters;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Filtros activos: ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (_searchQuery.isNotEmpty)
                    _buildActiveFilterChip('Búsqueda: "$_searchQuery"'),
                  if (_selectedDateFilter != 'Todas')
                    _buildActiveFilterChip(
                      _selectedDateFilter == 'rango' && _selectedDateRange != null
                          ? '${_formatJustDate(_selectedDateRange!.start)} - ${_formatJustDate(_selectedDateRange!.end)}'
                          : _selectedDateFilter == '7dias'
                              ? 'Últimos 7 días'
                              : 'Últimos 30 días',
                    ),
                  if (_selectedEmployeeName != 'all')
                    _buildActiveFilterChip('Empleado: $_selectedEmployeeName'),
                  if (_selectedPaymentMethod != 'Todos')
                    _buildActiveFilterChip('Pago: $_selectedPaymentMethod'),
                  if (_selectedStatus != 'Todos')
                    _buildActiveFilterChip('Estado: $_selectedStatus'),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Limpiar',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAdvancedFiltersPanel() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Date Range selector & Employee dropdown
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rango de Fechas',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDateFilter,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          fillColor: Colors.grey[50],
                          filled: true,
                        ),
                        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
                        items: const [
                          DropdownMenuItem(value: 'Todas', child: Text('Todas las fechas')),
                          DropdownMenuItem(value: '7dias', child: Text('Últimos 7 días')),
                          DropdownMenuItem(value: '30dias', child: Text('Últimos 30 días')),
                          DropdownMenuItem(value: 'rango', child: Text('Rango personalizado...')),
                        ],
                        onChanged: (val) {
                          if (val == 'rango') {
                            _selectCustomDateRange();
                          } else {
                            setState(() {
                              _selectedDateFilter = val ?? 'Todas';
                            });
                            _applyFilters();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Empleado',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedEmployeeName,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          fillColor: Colors.grey[50],
                          filled: true,
                        ),
                        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('Todos')),
                          ...widget.activeEmployees.map((emp) {
                            return DropdownMenuItem(
                              value: emp.employee.nombreCompleto,
                              child: Text(emp.employee.nombreCompleto),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedEmployeeName = val;
                          });
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Payment Method chips
            Text(
              'Método de Pago',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Todos', 'Efectivo', 'PayPal', 'Transferencia'].map((method) {
                final isSelected = _selectedPaymentMethod == method;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(method),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                        _applyFilters();
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.grey[100],
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide.none,
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Row 3: Invoice Status chips
            Text(
              'Estado de Factura',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Todos', 'Emitida', 'Pendiente', 'Fallo de PDF'].map((status) {
                final isSelected = _selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                        _applyFilters();
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.grey[100],
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide.none,
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid({
    required double totalBilled,
    required int invoiceCount,
    required int completedCount,
    required double averageTicket,
    required double cashTotal,
    required double paypalTotal,
    required double bankTransferTotal,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int crossAxisCount = 2;
        double childAspectRatio = 1.4;

        if (width >= 1000) {
          crossAxisCount = 4;
          childAspectRatio = 1.8;
        } else if (width >= 720) {
          crossAxisCount = 4;
          childAspectRatio = 1.3;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 1.4;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          children: [
            _buildMetricCard(
              title: 'Total Facturado',
              value: '\$${totalBilled.toStringAsFixed(2)}',
              icon: Icons.monetization_on_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
            ),
            _buildMetricCard(
              title: 'Ticket Promedio',
              value: '\$${averageTicket.toStringAsFixed(2)}',
              icon: Icons.analytics_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
            ),
            _buildMetricCard(
              title: 'Facturas Emitidas',
              value: '$invoiceCount',
              subtitle: '$completedCount completadas',
              icon: Icons.receipt_long_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
            ),
            _buildMetricCard(
              title: 'Métodos de Pago',
              value: 'Efe: \$${cashTotal.toStringAsFixed(0)}',
              subtitle: 'PP: \$${paypalTotal.toStringAsFixed(0)} • Transf: \$${bankTransferTotal.toStringAsFixed(0)}',
              icon: Icons.account_balance_wallet_rounded,
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background soft circular design
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              icon,
              size: 100,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, color: textColor.withValues(alpha: 0.9), size: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: textColor.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeLeaderboard(List<_EmployeeStat> stats) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: AppColors.warning, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Rendimiento por Empleado',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Top Facturación',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              separatorBuilder: (context, index) => const Divider(height: 16, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final emp = stats[index];
                
                // Podium icons
                String medal = '';
                if (index == 0) medal = '🥇';
                if (index == 1) medal = '🥈';
                if (index == 2) medal = '🥉';

                return Row(
                  children: [
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: medal.isNotEmpty
                          ? Text(medal, style: const TextStyle(fontSize: 20))
                          : Text(
                              '${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${emp.servicesCount} servicios · Prom: \$${emp.averageTicket.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${emp.totalBilled.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded, color: Colors.grey[300], size: 64),
          const SizedBox(height: 16),
          Text(
            'No se encontraron facturas',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba a cambiar los filtros o a limpiar la búsqueda actual.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _clearAllFilters,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Limpiar todos los filtros'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredInvoices.length,
      itemBuilder: (context, index) {
        final invoice = _filteredInvoices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () async {
              final result = await context.push<InvoiceModel?>(AppRoutes.ownerBillingDetail, extra: invoice);
              if (result != null && mounted) {
                _fetchInvoices();
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Card(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey[100]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoice.numeroUnico,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(invoice.fechaEmision),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusBadge(invoice.invoiceStatus),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCardDetailRow(Icons.person_rounded, 'Cliente: ${invoice.clientName ?? 'Consumidor Final'}'),
                              const SizedBox(height: 6),
                              _buildCardDetailRow(Icons.engineering_rounded, 'Emp: ${invoice.employeeName ?? 'Sin asignar'}'),
                              const SizedBox(height: 6),
                              _buildCardDetailRow(Icons.local_laundry_service_rounded, 'Servicio: ${invoice.serviceName}'),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (invoice.paymentMethod.toUpperCase() == 'PAYPAL')
                                    ? Colors.blue.withValues(alpha: 0.1)
                                    : invoice.paymentMethod.toUpperCase().contains('TRANSFERENCIA')
                                        ? Colors.purple.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                invoice.paymentMethod.toUpperCase() == 'PAYPAL'
                                    ? 'PayPal'
                                    : invoice.paymentMethod.toUpperCase().contains('TRANSFERENCIA')
                                        ? 'Transferencia'
                                        : 'Efectivo',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: (invoice.paymentMethod.toUpperCase() == 'PAYPAL')
                                      ? Colors.blue[700]
                                      : invoice.paymentMethod.toUpperCase().contains('TRANSFERENCIA')
                                          ? Colors.purple[700]
                                          : Colors.green[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${invoice.total.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color;
    Color bgColor;
    String label;

    switch (status) {
      case InvoiceStatus.GENERATED:
        color = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        label = 'Emitida';
        break;
      case InvoiceStatus.PENDING:
        color = AppColors.warning;
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        label = 'Pendiente';
        break;
      case InvoiceStatus.FAILED:
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        label = 'Fallo PDF';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmployeeStat {
  final String name;
  int servicesCount = 0;
  double totalBilled = 0.0;

  _EmployeeStat({required this.name});

  double get averageTicket => servicesCount > 0 ? totalBilled / servicesCount : 0.0;
}
