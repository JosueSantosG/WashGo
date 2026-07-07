import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/invoices/repositories/invoice_repository.dart';
import 'package:washgo/features/invoices/utils/invoice_cache_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class OwnerInvoiceDetailPage extends StatefulWidget {
  final InvoiceModel invoice;

  const OwnerInvoiceDetailPage({
    super.key,
    required this.invoice,
  });

  @override
  State<OwnerInvoiceDetailPage> createState() => _OwnerInvoiceDetailPageState();
}

class _OwnerInvoiceDetailPageState extends State<OwnerInvoiceDetailPage> {
  final InvoiceRepository _invoiceRepository = FirebaseInvoiceRepository();
  late InvoiceModel _currentInvoice;
  bool _isGenerating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentInvoice = widget.invoice;
  }

  Future<void> _handleRegeneratePdf() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final updatedInvoice = await _invoiceRepository.regenerateInvoicePdf(_currentInvoice.id);
      if (mounted) {
        setState(() {
          _currentInvoice = updatedInvoice;
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Factura generada exitosamente',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error regenerating invoice PDF: $e');
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _errorMessage = 'Error al generar la factura. Inténtalo de nuevo.';
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

  @override
  Widget build(BuildContext context) {
    final status = _currentInvoice.invoiceStatus;
    final bool hasPdf = _currentInvoice.pdfUrl != null && _currentInvoice.pdfUrl!.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _currentInvoice);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context, _currentInvoice),
          ),
          title: Text(
            'Detalle de Factura',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Card (Factura ID, Status, Date)
                _buildHeaderCard(status),
                const SizedBox(height: 16),

                // 2. Financial Breakdown Card
                _buildFinancialBreakdownCard(),
                const SizedBox(height: 16),

                // 3. Client and Employee Info Card
                _buildParticipantsCard(),
                const SizedBox(height: 16),

                // 4. Service and Observations Card
                _buildServiceDetailsCard(),
                const SizedBox(height: 24),

                // 5. Error Message (if any)
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 6. Action Buttons
                _buildActionButtons(status, hasPdf),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(InvoiceStatus status) {
    Color statusColor;
    Color statusBgColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case InvoiceStatus.GENERATED:
        statusColor = AppColors.success;
        statusBgColor = AppColors.success.withValues(alpha: 0.1);
        statusLabel = 'Emitida';
        statusIcon = Icons.check_circle_rounded;
        break;
      case InvoiceStatus.PENDING:
        statusColor = AppColors.warning;
        statusBgColor = AppColors.warning.withValues(alpha: 0.1);
        statusLabel = 'Pendiente';
        statusIcon = Icons.hourglass_empty_rounded;
        break;
      case InvoiceStatus.FAILED:
        statusColor = AppColors.error;
        statusBgColor = AppColors.error.withValues(alpha: 0.1);
        statusLabel = 'Fallo PDF';
        statusIcon = Icons.error_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentInvoice.numeroUnico,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(_currentInvoice.fechaEmision),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Icon(Icons.business_rounded, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Establecimiento:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentInvoice.businessName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desglose Financiero',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildFinancialRow('Subtotal', '\$${_currentInvoice.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _buildFinancialRow(
            'Descuento',
            '-\$${_currentInvoice.discount.toStringAsFixed(2)}',
            valueColor: _currentInvoice.discount > 0 ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          _buildFinancialRow('Impuesto (15% IVA)', '\$${_currentInvoice.tax.toStringAsFixed(2)}'),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
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
                  'Total Facturado',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  '\$${_currentInvoice.total.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal & Cliente',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.person_rounded,
            title: 'Cliente',
            value: _currentInvoice.clientName ?? 'Consumidor Final',
            subtitle: _currentInvoice.clientEmail != null || _currentInvoice.clientPhone != null
                ? '${_currentInvoice.clientEmail ?? ''}${_currentInvoice.clientEmail != null && _currentInvoice.clientPhone != null ? ' · ' : ''}${_currentInvoice.clientPhone ?? ''}'
                : null,
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          _buildInfoRow(
            icon: Icons.engineering_rounded,
            title: 'Empleado Asignado',
            value: _currentInvoice.employeeName ?? 'Sin asignar',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetailsCard() {
    final hasObservations = _currentInvoice.observations != null && _currentInvoice.observations!.trim().isNotEmpty;
    final isPaypal = _currentInvoice.paymentMethod.toUpperCase() == 'PAYPAL';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles del Servicio',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Servicio Realizado',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentInvoice.serviceName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Método de Pago',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaypal ? Colors.blue.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPaypal ? Icons.payment_rounded : Icons.money_rounded,
                      size: 14,
                      color: isPaypal ? Colors.blue[700] : Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPaypal ? 'PayPal' : 'Efectivo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPaypal ? Colors.blue[700] : Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasObservations) ...[
            const Divider(height: 28, color: Color(0xFFF1F5F9)),
            Text(
              'Observaciones',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _currentInvoice.observations!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(InvoiceStatus status, bool hasPdf) {
    if (_isGenerating) {
      return Column(
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            'Procesando factura...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (status == InvoiceStatus.FAILED) {
      return ElevatedButton.icon(
        onPressed: _handleRegeneratePdf,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Reintentar Generar Factura'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
    }

    if (hasPdf) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                await InvoiceCacheManager.shareInvoice(
                  _currentInvoice.orderId,
                  _currentInvoice.pdfUrl!,
                  subject: 'Factura ${_currentInvoice.numeroUnico}',
                );
              },
              icon: const Icon(Icons.share_rounded),
              label: const Text('Compartir'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                await InvoiceCacheManager.printOrViewInvoice(
                  _currentInvoice.orderId,
                  _currentInvoice.pdfUrl!,
                );
              },
              icon: const Icon(Icons.print_rounded),
              label: const Text('Ver / Imprimir'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
        ],
      );
    }

    // Default fallback (e.g. status is PENDING but no URL yet)
    return ElevatedButton.icon(
      onPressed: _handleRegeneratePdf,
      icon: const Icon(Icons.picture_as_pdf_rounded),
      label: const Text('Generar PDF de Factura'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
