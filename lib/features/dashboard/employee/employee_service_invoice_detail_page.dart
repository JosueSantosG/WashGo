import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class EmployeeServiceInvoiceDetailPage extends StatelessWidget {
  final InvoiceModel invoice;

  const EmployeeServiceInvoiceDetailPage({super.key, required this.invoice});

  String _getOrderDisplayCode(String orderId) {
    final displayId = orderId.length > 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId.toUpperCase();
    return '#WASH-$displayId';
  }

  @override
  Widget build(BuildContext context) {
    // Parse observations
    final rawObs = invoice.observations ?? '';
    String originalObs = rawObs;
    String employeeNotes = 'Ninguna observación registrada.';

    if (rawObs.contains(' | Notas de Entrega: ')) {
      final parts = rawObs.split(' | Notas de Entrega: ');
      originalObs = parts[0];
      employeeNotes = parts[1];
    } else if (rawObs.contains('Notas de Entrega: ')) {
      final parts = rawObs.split('Notas de Entrega: ');
      originalObs = '';
      employeeNotes = parts[1];
    }

    final parsedObs = ParsedObservations.parse(originalObs);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detalle de Servicio',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top overview card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getOrderDisplayCode(invoice.orderId),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'COMPLETADO',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    invoice.serviceName,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    parsedObs.vehicleDetails,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha del Servicio',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            parsedObs.dateTime,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total del Servicio',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${invoice.total.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Customer Details Card
            _buildSectionTitle('Datos del Cliente', Icons.person_rounded),
            _buildDetailCard([
              _buildDetailRow(
                'Nombre',
                invoice.clientName ?? 'Cliente Genérico',
              ),
              _buildDetailRow(
                'Correo',
                invoice.clientEmail ?? 'No especificado',
              ),
              _buildDetailRow(
                'Teléfono',
                invoice.clientPhone ?? 'No especificado',
                trailing: (invoice.clientPhone != null && invoice.clientPhone!.isNotEmpty)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final Uri launchUri = Uri(scheme: 'tel', path: invoice.clientPhone);
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              }
                            },
                            child: const Icon(
                              Icons.phone_rounded,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final formattedPhone = invoice.clientPhone!.replaceAll(RegExp(r'[^\d+]'), '');
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
                            },
                            child: const Icon(
                              Icons.message_rounded,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ]),
            const SizedBox(height: 20),

            // Order/Service Details Card
            _buildSectionTitle(
              'Información de la Orden',
              Icons.receipt_long_rounded,
            ),
            _buildDetailCard([
              _buildDetailRow(
                'Código de Orden',
                _getOrderDisplayCode(invoice.orderId),
              ),
              _buildDetailRow('ID de Orden completo', invoice.orderId),
              _buildDetailRow('Negocio/Lavandería', invoice.businessName),
              _buildDetailRow('Tipo de Horario', parsedObs.scheduleType),
            ]),
            const SizedBox(height: 20),

            // Observations Card
            _buildSectionTitle(
              'Observaciones del Empleado',
              Icons.comment_rounded,
            ),
            _buildDetailCard([
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  employeeNotes,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Payment and Invoice Info Card
            _buildSectionTitle(
              'Método de Pago y Facturación',
              Icons.payment_rounded,
            ),
            _buildDetailCard([
              _buildDetailRow(
                'Método de Pago',
                () {
                  final String paymentMethod = invoice.paymentMethod.toUpperCase();
                  if (paymentMethod == 'PAYPAL') return 'PayPal 💳';
                  if (paymentMethod == 'PAYPHONE') return 'PayPhone 📱';
                  if (paymentMethod.contains('TRANSFERENCIA')) return 'Transferencia 🏦';
                  return 'Efectivo 💵';
                }(),
              ),
              _buildDetailRow(
                'Estado de Factura',
                _getInvoiceStatusName(invoice.invoiceStatus),
              ),
              _buildDetailRow('Número de Factura', invoice.numeroUnico),
              if (invoice.generatedAt != null)
                _buildDetailRow(
                  'Fecha de Facturación',
                  '${invoice.generatedAt!.day.toString().padLeft(2, '0')}/${invoice.generatedAt!.month.toString().padLeft(2, '0')}/${invoice.generatedAt!.year} ${invoice.generatedAt!.hour.toString().padLeft(2, '0')}:${invoice.generatedAt!.minute.toString().padLeft(2, '0')}',
                ),
            ]),
            const SizedBox(height: 20),

            // Acciones de Factura
            _buildSectionTitle(
              'Acciones de Factura',
              Icons.picture_as_pdf_rounded,
            ),
            if (invoice.pdfUrl != null && invoice.pdfUrl!.isNotEmpty)
              _buildInvoiceActionsCard(context)
            else
              _buildNoInvoiceCard(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceActionsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final url = invoice.pdfUrl;
                if (url != null && url.isNotEmpty) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No se pudo abrir la factura PDF.'),
                        ),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.visibility_rounded, color: Colors.white),
              label: Text(
                'Ver Factura',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                final url = invoice.pdfUrl;
                if (url != null && url.isNotEmpty) {
                  SharePlus.instance.share(
                    ShareParams(
                      text: url,
                      subject: 'Factura ${invoice.numeroUnico}',
                    ),
                  );
                }
              },
              icon: const Icon(Icons.share_rounded, color: AppColors.primary),
              label: Text(
                'Compartir',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoInvoiceCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'La factura PDF aún no ha sido generada.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInvoiceStatusName(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.GENERATED:
        return 'Generada (Listo) ✅';
      case InvoiceStatus.FAILED:
        return 'Error de Generación ❌';
      case InvoiceStatus.PENDING:
        return 'Pendiente ⏳';
    }
  }
}
