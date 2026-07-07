import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceCacheManager {
  // Retained for backward compatibility, but always returns false
  static Future<bool> isInvoiceCached(String orderId) async {
    return false;
  }

  // Retained for backward compatibility, but always returns null
  static Future<String?> getLocalInvoicePath(String orderId) async {
    return null;
  }

  // Retained for backward compatibility, but always returns null
  static Future<String?> downloadAndCacheInvoice(String orderId, String pdfUrl) async {
    return null;
  }

  static Future<void> shareInvoice(String orderId, String pdfUrl, {String? subject}) async {
    try {
      if (kIsWeb) {
        await SharePlus.instance.share(
          ShareParams(
            text: 'Aquí está tu factura de WashGo: $pdfUrl',
            subject: subject ?? 'Factura de WashGo',
          ),
        );
        return;
      }

      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/Factura_$orderId.pdf');
        await tempFile.writeAsBytes(response.bodyBytes);

        try {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(tempFile.path)],
              text: 'Aquí está tu factura de WashGo.',
              subject: subject ?? 'Factura de WashGo',
            ),
          );
        } finally {
          // Delete the temporary file after a delay to ensure it is sent/shared successfully by the OS
          Future.delayed(const Duration(seconds: 10), () async {
            try {
              if (await tempFile.exists()) {
                await tempFile.delete();
              }
            } catch (e) {
              // ignore: avoid_print
              print('Error deleting temporary share file: $e');
            }
          });
        }
      } else {
        // ignore: avoid_print
        print('Failed to download invoice PDF for sharing. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error sharing invoice: $e');
    }
  }

  static Future<void> printOrViewInvoice(String orderId, String pdfUrl) async {
    try {
      if (kIsWeb) {
        final uri = Uri.parse(pdfUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // ignore: avoid_print
          print('Could not launch $pdfUrl');
        }
        return;
      }

      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => response.bodyBytes,
          name: 'Factura_$orderId',
        );
      } else {
        // ignore: avoid_print
        print('Failed to download invoice PDF for printing. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error viewing/printing invoice: $e');
    }
  }
}

