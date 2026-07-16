import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:washgo/config/env/environment.dart';

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

  /// Returns the base URL for Cloud Functions endpoints.
  /// Derives the project ID from Firebase options and handles emulator host resolution.
  static String getFunctionsBaseUrl() {
    var projectId = Firebase.apps.isNotEmpty ? Firebase.app().options.projectId : 'washgo-app-8392';
    if (Environment.useEmulators) {
      if (projectId.endsWith('-dev')) {
        projectId = projectId.substring(0, projectId.length - 4);
      } else if (projectId.endsWith('-staging')) {
        projectId = projectId.substring(0, projectId.length - 8);
      }
      return 'http://${Environment.emulatorHost}:5001/$projectId/us-central1/api';
    } else {
      return 'https://us-central1-$projectId.cloudfunctions.net/api';
    }
  }

  /// Share an invoice. When [invoiceId], [baseUrl], and [idToken] are provided,
  /// uses the server proxy endpoint (bypasses storage.rules in emulators).
  static Future<void> shareInvoice(
    String orderId,
    String pdfUrl, {
    String? subject,
    String? invoiceId,
    String? baseUrl,
    String? idToken,
  }) async {
    try {
      // If we have proxy info, download via server endpoint
      if (baseUrl != null && idToken != null) {
        final String proxyPath = invoiceId != null
            ? '/invoices/$invoiceId/pdf'
            : '/orders/$orderId/invoice-pdf';
        final response = await http.get(
          Uri.parse('$baseUrl$proxyPath'),
          headers: {'Authorization': 'Bearer $idToken'},
        );

        if (response.statusCode == 200) {
          if (kIsWeb) {
            // On web, use signed URL for sharing if we have an invoiceId
            if (invoiceId != null) {
              final urlResponse = await http.get(
                Uri.parse('$baseUrl/invoices/$invoiceId/url'),
                headers: {'Authorization': 'Bearer $idToken'},
              );
              if (urlResponse.statusCode == 200) {
                final data = jsonDecode(urlResponse.body);
                final signedUrl = data['url'] as String? ?? pdfUrl;
                await SharePlus.instance.share(
                  ShareParams(
                    text: 'Aquí está tu factura de WashGo: $signedUrl',
                    subject: subject ?? 'Factura de WashGo',
                  ),
                );
                return;
              }
            }
            // Web fallback: share raw URL (works for orderId-only too)
            await SharePlus.instance.share(
              ShareParams(
                text: 'Aquí está tu factura de WashGo: $pdfUrl',
                subject: subject ?? 'Factura de WashGo',
              ),
            );
            return;
          }

          // Mobile: save to temp file and share
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
          return;
        }
      }

      // Fallback: use pdfUrl directly (original behavior)
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

  /// View or print an invoice. When [invoiceId], [baseUrl], and [idToken] are provided,
  /// uses the server proxy endpoint (bypasses storage.rules in emulators).
  static Future<void> printOrViewInvoice(
    String orderId,
    String pdfUrl, {
    String? invoiceId,
    String? baseUrl,
    String? idToken,
  }) async {
    try {
      // If we have proxy info, download via server endpoint
      if (baseUrl != null && idToken != null) {
        final String proxyPath = invoiceId != null
            ? '/invoices/$invoiceId/pdf'
            : '/orders/$orderId/invoice-pdf';
        final response = await http.get(
          Uri.parse('$baseUrl$proxyPath'),
          headers: {'Authorization': 'Bearer $idToken'},
        );

        if (response.statusCode == 200) {
          if (kIsWeb) {
            // On web, try signed URL if we have an invoiceId
            if (invoiceId != null) {
              final urlResponse = await http.get(
                Uri.parse('$baseUrl/invoices/$invoiceId/url'),
                headers: {'Authorization': 'Bearer $idToken'},
              );
              if (urlResponse.statusCode == 200) {
                final data = jsonDecode(urlResponse.body);
                final signedUrl = data['url'] as String;
                final uri = Uri.parse(signedUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return;
                }
              }
            }
            // Fallback for web: launch raw PDF URL (works for orderId-only too)
            final uri = Uri.parse(pdfUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            return;
          } else {
            // Mobile: display PDF
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => response.bodyBytes,
              name: 'Factura_$orderId',
            );
            return;
          }
        }
      }

      // Fallback: use pdfUrl directly (original behavior)
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
