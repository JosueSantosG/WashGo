import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/invoices/repositories/invoice_repository.dart';
import 'package:washgo/features/invoices/utils/invoice_cache_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';


class ClientInvoiceHistoryPage extends StatefulWidget {
  const ClientInvoiceHistoryPage({super.key});

  @override
  State<ClientInvoiceHistoryPage> createState() => _ClientInvoiceHistoryPageState();
}

class _ClientInvoiceHistoryPageState extends State<ClientInvoiceHistoryPage> {
  final InvoiceRepository _invoiceRepository = FirebaseInvoiceRepository();
  final ScrollController _scrollController = ScrollController();
  
  List<InvoiceModel> _filteredInvoices = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Pagination state
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  // Filters state
  String _searchQuery = '';
  String _selectedPaymentMethod = 'Todos'; // 'Todos', 'Efectivo', 'PayPal'
  String _selectedDateFilter = 'Todas'; // 'Todas', '7dias', '30dias', 'rango'
  DateTimeRange? _selectedDateRange;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (FirebaseAuth.instance.currentUser != null) {
      _fetchInvoices();
    } else {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isFetchingMore && !_isLoading) {
        setState(() {
          _isFetchingMore = true;
        });
        _fetchInvoices();
      }
    }
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = val;
          _offset = 0;
          _hasMore = true;
          _isLoading = true;
          _filteredInvoices = [];
        });
        _fetchInvoices();
      }
    });
  }

  void _onDropdownChanged() {
    _debounceTimer?.cancel();
    setState(() {
      _offset = 0;
      _hasMore = true;
      _isLoading = true;
      _filteredInvoices = [];
    });
    _fetchInvoices();
  }

  Future<void> _handleRefresh() async {
    _debounceTimer?.cancel();
    setState(() {
      _offset = 0;
      _hasMore = true;
      _isLoading = true;
      _filteredInvoices = [];
    });
    await _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    if (!mounted) return;

    try {
      DateTime? startDate;
      DateTime? endDate;
      final now = DateTime.now();

      if (_selectedDateFilter == '7dias') {
        startDate = now.subtract(const Duration(days: 7));
      } else if (_selectedDateFilter == '30dias') {
        startDate = now.subtract(const Duration(days: 30));
      } else if (_selectedDateFilter == 'rango' && _selectedDateRange != null) {
        startDate = _selectedDateRange!.start;
        endDate = DateTime(
          _selectedDateRange!.end.year,
          _selectedDateRange!.end.month,
          _selectedDateRange!.end.day,
          23,
          59,
          59,
        );
      }

      PaymentMethod? paymentMethod;
      if (_selectedPaymentMethod != 'Todos') {
        paymentMethod = _selectedPaymentMethod == 'Efectivo'
            ? PaymentMethod.CASH
            : PaymentMethod.PAYPAL;
      }

      final String? query = _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null;

      final invoices = await _invoiceRepository.getClientInvoices(
        limit: _limit,
        offset: _offset,
        startDate: startDate,
        endDate: endDate,
        paymentMethod: paymentMethod,
        searchQuery: query,
      );

      if (mounted) {
        setState(() {
          if (_offset == 0) {
            _filteredInvoices = invoices;
          } else {
            _filteredInvoices.addAll(invoices);
          }
          _isLoading = false;
          _isFetchingMore = false;
          _errorMessage = null;

          if (invoices.length < _limit) {
            _hasMore = false;
          } else {
            _hasMore = true;
            _offset += _limit;
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching client invoices: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFetchingMore = false;
          if (_offset == 0) {
            _errorMessage = 'No pudimos cargar tus facturas. Por favor, intenta de nuevo.';
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al cargar más facturas.')),
            );
          }
        });
      }
    }
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
      _onDropdownChanged();
    }
  }

  void _showInvoiceDetailsSheet(InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isGenerating = false;
        String? sheetError;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentInvoice = _filteredInvoices.firstWhere(
              (inv) => inv.id == invoice.id,
              orElse: () => invoice,
            );

            Future<void> handleGenerate({required bool share, required bool print}) async {
              setSheetState(() {
                isGenerating = true;
                sheetError = null;
              });
              try {
                final updatedInvoice = await _invoiceRepository.regenerateInvoicePdf(currentInvoice);
                
                if (mounted) {
                  setState(() {
                    final idxFiltered = _filteredInvoices.indexWhere((inv) => inv.id == currentInvoice.id);
                    if (idxFiltered != -1) {
                      _filteredInvoices[idxFiltered] = updatedInvoice;
                    }
                  });
                }

                if (updatedInvoice.pdfUrl != null && updatedInvoice.pdfUrl!.isNotEmpty) {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                  final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();

                  if (share) {
                    await InvoiceCacheManager.shareInvoice(
                      updatedInvoice.orderId,
                      updatedInvoice.pdfUrl!,
                      invoiceId: updatedInvoice.id,
                      baseUrl: baseUrl,
                      idToken: idToken,
                      subject: 'Factura ${updatedInvoice.numeroUnico}',
                    );
                  } else if (print) {
                    await InvoiceCacheManager.printOrViewInvoice(
                      updatedInvoice.orderId,
                      updatedInvoice.pdfUrl!,
                      invoiceId: updatedInvoice.id,
                      baseUrl: baseUrl,
                      idToken: idToken,
                    );
                  }
                } else {
                  throw Exception('El enlace del PDF no se generó correctamente.');
                }
              } catch (e) {
                debugPrint('Error generating PDF: $e');
                if (mounted) {
                  setSheetState(() {
                    isGenerating = false;
                    sheetError = 'Error al generar la factura. Inténtalo de nuevo.';
                  });
                }
              }
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pull Bar indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentInvoice.businessName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentInvoice.numeroUnico,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(currentInvoice.invoiceStatus),
                    ],
                  ),
                  const Divider(height: 32),
                  
                  // Detail rows
                  _buildDetailRow('Servicio', currentInvoice.serviceName),
                  _buildDetailRow('Fecha de Emisión', _formatDate(currentInvoice.fechaEmision)),
                  _buildDetailRow('Método de Pago', currentInvoice.paymentMethod),
                  _buildDetailRow('Empleado Asignado', currentInvoice.employeeName ?? 'Sin asignar'),
                  
                  if (currentInvoice.clientName != null && currentInvoice.clientName!.trim().isNotEmpty) ...[
                    _buildDetailRow('Cliente', currentInvoice.clientName!),
                    if (currentInvoice.clientEmail != null) _buildDetailRow('Email Cliente', currentInvoice.clientEmail!),
                    if (currentInvoice.clientPhone != null) _buildDetailRow('Teléfono Cliente', currentInvoice.clientPhone!),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monto Total',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          '\$${currentInvoice.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons or Loader
                  if (isGenerating)
                    Column(
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Generando factura electrónica...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    Row(
                      children: [
                        if (currentInvoice.pdfUrl != null && currentInvoice.pdfUrl!.isNotEmpty) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                                final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                                final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                                await InvoiceCacheManager.shareInvoice(
                                  currentInvoice.orderId,
                                  currentInvoice.pdfUrl!,
                                  invoiceId: currentInvoice.id,
                                  baseUrl: baseUrl,
                                  idToken: idToken,
                                  subject: 'Factura ${currentInvoice.numeroUnico}',
                                );
                              },
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Compartir'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: AppColors.primary),
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                                final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                                final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                                await InvoiceCacheManager.printOrViewInvoice(
                                  currentInvoice.orderId,
                                  currentInvoice.pdfUrl!,
                                  invoiceId: currentInvoice.id,
                                  baseUrl: baseUrl,
                                  idToken: idToken,
                                );
                              },
                              icon: const Icon(Icons.print_rounded),
                              label: const Text('Ver / Imprimir'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => handleGenerate(share: true, print: false),
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Generar y Compartir'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: AppColors.primary),
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => handleGenerate(share: false, print: true),
                              icon: const Icon(Icons.print_rounded),
                              label: const Text('Generar y Ver'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (sheetError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        sheetError!,
                        style: GoogleFonts.inter(
                          color: AppColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                  

                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color;
    Color bgColor;
    IconData icon;
    String label;

    switch (status) {
      case InvoiceStatus.GENERATED:
        color = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        icon = Icons.check_circle_rounded;
        label = 'Emitida';
        break;
      case InvoiceStatus.PENDING:
        color = AppColors.warning;
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        icon = Icons.hourglass_empty_rounded;
        label = 'Pendiente';
        break;
      case InvoiceStatus.FAILED:
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        icon = Icons.error_outline_rounded;
        label = 'Fallo de PDF';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardActionBadge(InvoiceStatus status) {
    Color color;
    Color bgColor;
    IconData icon;
    String label;

    if (status == InvoiceStatus.FAILED) {
      color = AppColors.error;
      bgColor = AppColors.error.withValues(alpha: 0.1);
      icon = Icons.refresh_rounded;
      label = 'Reintentar';
    } else {
      color = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.1);
      icon = Icons.add_circle_outline_rounded;
      label = 'Generar';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isGuest = FirebaseAuth.instance.currentUser == null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Historial de Facturas',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isGuest
          ? _buildGuestPlaceholder(context)
          : Column(
              children: [
                // Filter Panel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    _onSearchChanged(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por negocio, servicio o N° de factura...',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filters Row
                Row(
                  children: [
                    // Date Filter Dropdown/Button
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDateFilter,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            items: [
                              const DropdownMenuItem(value: 'Todas', child: Text('Todas las fechas')),
                              const DropdownMenuItem(value: '7dias', child: Text('Últimos 7 días')),
                              const DropdownMenuItem(value: '30dias', child: Text('Último mes')),
                              DropdownMenuItem(
                                value: 'rango',
                                child: Text(_selectedDateRange != null
                                    ? '${_formatJustDate(_selectedDateRange!.start)} - ${_formatJustDate(_selectedDateRange!.end)}'
                                    : 'Seleccionar rango...'),
                              ),
                            ],
                            onChanged: (val) async {
                              if (val == 'rango') {
                                await _selectCustomDateRange();
                              } else if (val != null) {
                                setState(() {
                                  _selectedDateFilter = val;
                                  if (val != 'rango') {
                                    _selectedDateRange = null;
                                  }
                                });
                                _onDropdownChanged();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Payment Method Filter
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPaymentMethod,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Todos', child: Text('Todos los pagos')),
                              DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                              DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedPaymentMethod = val;
                                });
                                _onDropdownChanged();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Invoices List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : _errorMessage != null
                    ? Center(
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
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _fetchInvoices,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filteredInvoices.isEmpty
                        ? RefreshIndicator(
                            onRefresh: _handleRefresh,
                            color: AppColors.primary,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long_rounded,
                                      size: 50,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'No hay facturas',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isEmpty &&
                                            _selectedPaymentMethod == 'Todos' &&
                                            _selectedDateFilter == 'Todas'
                                        ? 'Las facturas de tus servicios completados aparecerán aquí automáticamente.'
                                        : 'Prueba cambiando los filtros de búsqueda.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _handleRefresh,
                            color: AppColors.primary,
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredInvoices.length + (_isFetchingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < _filteredInvoices.length) {
                                  final invoice = _filteredInvoices[index];
                                  return _buildInvoiceCard(invoice);
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tus Facturas',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Inicia sesión para ver tu historial de facturas y detalles de tus pagos.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Iniciar Sesión',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceModel invoice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showInvoiceDetailsSheet(invoice),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header of card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date & Status
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          invoice.numeroUnico,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    // Status badge or Generated status
                    Row(
                      children: [
                        if (invoice.pdfUrl == null || invoice.pdfUrl!.isEmpty)
                          _buildCardActionBadge(invoice.invoiceStatus)
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded, size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  'Emitida',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Business and Service info
                Text(
                  invoice.businessName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.serviceName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Price, Date and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${invoice.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(invoice.fechaEmision),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Share Action Icon Button
                        IconButton(
                          icon: const Icon(Icons.share_outlined, color: AppColors.primary, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (invoice.pdfUrl != null && invoice.pdfUrl!.isNotEmpty) {
                              final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                              final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                              await InvoiceCacheManager.shareInvoice(
                                invoice.orderId,
                                invoice.pdfUrl!,
                                invoiceId: invoice.id,
                                baseUrl: baseUrl,
                                idToken: idToken,
                                subject: 'Factura ${invoice.numeroUnico}',
                              );
                            } else {
                              _showInvoiceDetailsSheet(invoice);
                            }
                          },
                          tooltip: 'Compartir',
                        ),
                        const SizedBox(width: 14),
                        // View / Print Action Button
                        IconButton(
                          icon: const Icon(Icons.print_outlined, color: AppColors.primary, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (invoice.pdfUrl != null && invoice.pdfUrl!.isNotEmpty) {
                              final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
                              final baseUrl = InvoiceCacheManager.getFunctionsBaseUrl();
                              await InvoiceCacheManager.printOrViewInvoice(
                                invoice.orderId,
                                invoice.pdfUrl!,
                                invoiceId: invoice.id,
                                baseUrl: baseUrl,
                                idToken: idToken,
                              );
                            } else {
                              _showInvoiceDetailsSheet(invoice);
                            }
                          },
                          tooltip: 'Imprimir',
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
  }
}
