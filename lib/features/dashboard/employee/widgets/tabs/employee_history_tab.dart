import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/dashboard/employee/employee_service_invoice_detail_page.dart';

class EmployeeHistoryTab extends StatefulWidget {
  final EmployeeStatus? employeeStatus;
  final bool isLoadingInvoices;
  final bool isLoadingMoreInvoices;
  final bool hasMoreInvoices;
  final String? invoicesErrorMessage;
  final List<InvoiceModel> employeeInvoices;
  final Future<void> Function() onRefreshInvoices;
  final Future<void> Function() onLoadMoreInvoices;
  final Function(String query) onSearchChanged;

  const EmployeeHistoryTab({
    super.key,
    required this.employeeStatus,
    required this.isLoadingInvoices,
    required this.isLoadingMoreInvoices,
    required this.hasMoreInvoices,
    required this.invoicesErrorMessage,
    required this.employeeInvoices,
    required this.onRefreshInvoices,
    required this.onLoadMoreInvoices,
    required this.onSearchChanged,
  });

  @override
  State<EmployeeHistoryTab> createState() => _EmployeeHistoryTabState();
}

class _EmployeeHistoryTabState extends State<EmployeeHistoryTab> {
  final TextEditingController _historySearchController = TextEditingController();
  String _historySearchQuery = '';
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _historySearchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMoreInvoices && !widget.isLoadingMoreInvoices && !widget.isLoadingInvoices) {
        widget.onLoadMoreInvoices();
      }
    }
  }

  String _getOrderDisplayCodeFromString(String orderId) {
    final displayId = orderId.length > 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId.toUpperCase();
    return '#WASH-$displayId';
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

  String _formatPaymentMethod(String method) {
    final m = method.toUpperCase();
    if (m.contains('CASH') || m.contains('EFECTIVO')) return 'Efectivo';
    if (m.contains('CARD') || m.contains('TARJETA') || m.contains('CREDIT') || m.contains('DEBIT')) return 'Tarjeta';
    if (m.contains('TRANSFER') || m.contains('TRANSFERENCIA')) return 'Transferencia';
    if (m.contains('PAYPAL')) return 'PayPal';
    return method;
  }


  List<InvoiceModel> get _filteredEmployeeInvoices {
    return widget.employeeInvoices.where((inv) => inv.orderStatus == 'COMPLETADO').toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.employeeStatus == EmployeeStatus.PENDING) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_toggle_off_rounded,
                  size: 80,
                  color: AppColors.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Historial Vacío',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aquí aparecerá el historial de servicios que completes una vez que tu cuenta esté activa.',
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

    if (widget.isLoadingInvoices) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (widget.invoicesErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                widget.invoicesErrorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: widget.onRefreshInvoices,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final invoices = _filteredEmployeeInvoices;
    final totalEarnings = invoices.fold(0.0, (sum, inv) => sum + inv.total);
    final completedCount = invoices.length;

    return RefreshIndicator(
      onRefresh: widget.onRefreshInvoices,
      color: AppColors.primary,
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Historial de Servicios',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Consulta los servicios completados y sus facturas asociadas.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Servicios Completados',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedCount',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.white24,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Facturado',
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${totalEarnings.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Field
          Container(
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
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: TextField(
              controller: _historySearchController,
              onChanged: (val) {
                setState(() {
                  _historySearchQuery = val;
                });
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  widget.onSearchChanged(val);
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por código, servicio o cliente...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.outline,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                ),
                suffixIcon: _historySearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.outline,
                          size: 20,
                        ),
                        onPressed: () {
                          _historySearchController.clear();
                          setState(() {
                            _historySearchQuery = '';
                          });
                          _debounceTimer?.cancel();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // List Header
          Text(
            'Servicios Realizados',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 12),

          if (widget.employeeInvoices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tienes servicios completados en tu historial.',
                      style: GoogleFonts.outfit(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else if (invoices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No se encontraron servicios que coincidan con la búsqueda.',
                      style: GoogleFonts.outfit(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            ...invoices.map((inv) {
              final orderCode = _getOrderDisplayCodeFromString(inv.orderId);
              
              // Status Styling
              Color statusColor;
              Color statusBgColor;
              String statusLabel;

              switch (inv.invoiceStatus) {
                case InvoiceStatus.GENERATED:
                  statusColor = Colors.green.shade700;
                  statusBgColor = Colors.green.shade50;
                  statusLabel = 'Generada';
                  break;
                case InvoiceStatus.PENDING:
                  statusColor = Colors.orange.shade700;
                  statusBgColor = Colors.orange.shade50;
                  statusLabel = 'Pendiente';
                  break;
                case InvoiceStatus.FAILED:
                  statusColor = Colors.red.shade700;
                  statusBgColor = Colors.red.shade50;
                  statusLabel = 'Fallida';
                  break;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeServiceInvoiceDetailPage(invoice: inv),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                orderCode,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusLabel,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          inv.serviceName,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.outline),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Cliente: ${inv.clientName ?? 'N/A'}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.outline),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateTime(inv.fechaEmision),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.payment_rounded, size: 16, color: AppColors.outline),
                            const SizedBox(width: 6),
                            Text(
                              'Pago: ${_formatPaymentMethod(inv.paymentMethod)}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Facturado',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${inv.total.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          if (widget.isLoadingMoreInvoices)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
