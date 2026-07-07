import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/invoices/utils/csv_download_stub.dart'
    if (dart.library.html) 'package:washgo/features/invoices/utils/csv_download_web.dart';

class CsvExporter {
  static Future<void> exportInvoicesCsv(List<InvoiceModel> invoices) async {
    // 1. Generate CSV content
    final buffer = StringBuffer();
    // UTF-8 BOM to open correctly in Excel
    buffer.write('\uFEFF');
    // Headers
    buffer.writeln('Número Factura,Fecha de Emisión,Cliente,Empleado,Servicio,Método de Pago,Subtotal,Descuento,Impuesto,Total,Estado');
    
    for (final inv in invoices) {
      final numero = _escapeCsv(inv.numeroUnico);
      final fecha = _escapeCsv(inv.fechaEmision.toLocal().toString());
      final cliente = _escapeCsv(inv.clientName ?? 'Sin registrar');
      final empleado = _escapeCsv(inv.employeeName ?? 'Sin asignar');
      final servicio = _escapeCsv(inv.serviceName);
      final metodoPago = _escapeCsv(inv.paymentMethod);
      final subtotal = inv.subtotal.toStringAsFixed(2);
      final descuento = inv.discount.toStringAsFixed(2);
      final impuesto = inv.tax.toStringAsFixed(2);
      final total = inv.total.toStringAsFixed(2);
      final estado = _escapeCsv(inv.invoiceStatus.name);
      
      buffer.writeln('$numero,$fecha,$cliente,$empleado,$servicio,$metodoPago,$subtotal,$descuento,$impuesto,$total,$estado');
    }
    
    final csvData = buffer.toString();
    final bytes = Uint8List.fromList(csvData.codeUnits);
    
    if (kIsWeb) {
      downloadCsvWeb(csvData, 'Reporte_Facturas_WashGo.csv');
    } else {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/Reporte_Facturas_WashGo.csv');
      await tempFile.writeAsBytes(bytes);
      
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(tempFile.path)],
            text: 'Aquí está el reporte de facturación de WashGo.',
            subject: 'Reporte de Facturación WashGo',
          ),
        );
      } finally {
        Future.delayed(const Duration(seconds: 10), () async {
          try {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          } catch (e) {
            debugPrint('Error deleting temp CSV: $e');
          }
        });
      }
    }
  }

  static String _escapeCsv(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n') || field.contains('\r')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }
}
