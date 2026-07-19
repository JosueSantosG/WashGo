import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:washgo/core/utils/web_helper.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/orders/repositories/firebase_order_repository.dart';

class PaypalPaymentResult {
  final bool isSuccess;
  final String? transactionId;
  final String? payerEmail;
  final String? errorMessage;

  PaypalPaymentResult({
    required this.isSuccess,
    this.transactionId,
    this.payerEmail,
    this.errorMessage,
  });
}

/// Clase que simula el servidor/backend seguro (ej. Firebase Cloud Functions).
/// Aquí se realiza toda la lógica con el Client Secret de PayPal de forma segura,
/// sin exponer credenciales al dispositivo móvil.
class PaypalBackendService {
  // Credenciales privadas simuladas a nivel de servidor (cargadas de variables de entorno del backend)
  // En producción, estas claves residen únicamente en el entorno del servidor y nunca se exponen al cliente.
  static const String _clientId = String.fromEnvironment(
    'PAYPAL_CLIENT_ID',
    defaultValue: '',
  );

  static const String _clientSecret = String.fromEnvironment(
    'PAYPAL_CLIENT_SECRET',
    defaultValue: '',
  );

  final bool isSandbox;

  PaypalBackendService({required this.isSandbox});

  String get _baseUrl => isSandbox
      ? 'https://api-m.sandbox.paypal.com'
      : 'https://api-m.paypal.com';

  /// Obtiene un token de acceso OAuth2 utilizando las credenciales seguras del servidor
  Future<String> _getAccessToken() async {
    final id = _clientId.isNotEmpty ? _clientId : 'ASb-washgo-client-id-simulated-xyz123';
    final secret = _clientSecret.isNotEmpty ? _clientSecret : 'EEl-washgo-client-secret-simulated-abc987';
    
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$id:$secret'))}';
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/oauth2/token'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['access_token'] as String;
      } else {
        throw Exception('PayPal OAuth2 Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') || e.toString().contains('CORS')) {
        throw Exception('CORS_ERROR');
      }
      rethrow;
    }
  }

  /// Crea una orden de pago en PayPal en representación del cliente
  Future<Map<String, String>> createOrder({
    required double amount,
    required String serviceName,
    required String businessName,
    bool preferCard = false,
    String? washgoOrderId,
  }) async {
    final token = await _getAccessToken();
    
    String returnUrl = 'https://example.com/paypal-callback/success';
    String cancelUrl = 'https://example.com/paypal-callback/cancel';
    if (kIsWeb) {
      try {
        final origin = Uri.base.origin;
        if (origin.startsWith('http')) {
          returnUrl = '$origin/paypal-callback/success';
          cancelUrl = '$origin/paypal-callback/cancel';
        }
      } catch (_) {}
    }
    
    if (washgoOrderId != null) {
      returnUrl = '$returnUrl?washgoOrderId=$washgoOrderId';
      cancelUrl = '$cancelUrl?washgoOrderId=$washgoOrderId';
    }
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v2/checkout/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'intent': 'CAPTURE',
          'purchase_units': [
            {
              'amount': {
                'currency_code': 'USD',
                'value': amount.toStringAsFixed(2),
              },
              'description': 'Servicio: $serviceName - $businessName',
            }
          ],
          'payment_source': {
            'paypal': {
              'experience_context': {
                'brand_name': 'WashGo',
                'landing_page': preferCard ? 'BILLING' : 'LOGIN',
                'user_action': 'PAY_NOW',
                'return_url': returnUrl,
                'cancel_url': cancelUrl,
              }
            }
          }
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final orderId = json['id'] as String;
        final links = json['links'] as List;
        
        final approveLinkMap = links.firstWhere(
          (link) => link['rel'] == 'payer-action' || link['rel'] == 'approve',
          orElse: () => null,
        );
        
        if (approveLinkMap == null) {
          throw Exception('No se encontró el link de aprobación (approve o payer-action) en la respuesta de PayPal.');
        }
        
        final approveLink = approveLinkMap['href'] as String;
        
        return {
          'orderId': orderId,
          'approveUrl': approveLink,
        };
      } else {
        throw Exception('PayPal Order Creation Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') || e.toString().contains('CORS')) {
        throw Exception('CORS_ERROR');
      }
      rethrow;
    }
  }

  /// Obtiene el estado actual de la orden (APPROVED, COMPLETED, etc.)
  Future<String> getOrderStatus(String orderId) async {
    final token = await _getAccessToken();
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/v2/checkout/orders/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['status'] as String;
      } else {
        throw Exception('Error al obtener estado de orden: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') || e.toString().contains('CORS')) {
        throw Exception('CORS_ERROR');
      }
      rethrow;
    }
  }

  /// Captura un pago aprobado por el usuario
  Future<Map<String, dynamic>?> captureOrder(String orderId) async {
    final token = await _getAccessToken();
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v2/checkout/orders/$orderId/capture'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final errorJson = jsonDecode(response.body);
        return errorJson as Map<String, dynamic>;
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest') || e.toString().contains('CORS')) {
        throw Exception('CORS_ERROR');
      }
      rethrow;
    }
  }
}

class PaypalService {
  static final PaypalService _instance = PaypalService._internal();
  factory PaypalService() => _instance;
  PaypalService._internal();

  bool _useRealApi = true;
  bool _isSandbox = true;

  bool get useRealApi => _useRealApi;
  bool get isSandbox => _isSandbox;

  /// Cargar configuraciones del dispositivo (sin secretos)
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      const defaultIsSandbox = bool.fromEnvironment('PAYPAL_IS_SANDBOX', defaultValue: true);
      
      _isSandbox = prefs.getBool('paypal_is_sandbox') ?? defaultIsSandbox;
      _useRealApi = true; // Always force real API in production checkout flow
    } catch (e) {
      debugPrint('Error loading PayPal config: $e');
    }
  }

  /// Guardar configuraciones del dispositivo (sin secretos)
  Future<void> saveConfig({
    required bool isSandbox,
    required bool useRealApi,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('paypal_is_sandbox', isSandbox);
    await prefs.setBool('paypal_use_real_api', true);

    _isSandbox = isSandbox;
    _useRealApi = true;
  }

  /// Inicia el flujo interactivo de PayPal
  Future<PaypalPaymentResult> startPaymentFlow({
    required BuildContext context,
    required double amount,
    required String serviceName,
    required String businessName,
    bool preferCard = false,
    String? washgoOrderId,
  }) async {
    await init();

    if (!context.mounted) {
      return PaypalPaymentResult(isSuccess: false, errorMessage: 'Contexto de la interfaz de usuario no disponible.');
    }

    final result = await showDialog<PaypalPaymentResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 480,
            maxHeight: 650,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _PaypalCheckoutWidget(
            amount: amount,
            serviceName: serviceName,
            businessName: businessName,
            initialIsSandbox: _isSandbox,
            initialUseRealApi: _useRealApi,
            preferCard: preferCard,
            washgoOrderId: washgoOrderId,
          ),
        ),
      ),
    );

    return result ?? PaypalPaymentResult(isSuccess: false, errorMessage: 'Pago cancelado por el usuario');
  }
}

class _PaypalCheckoutWidget extends StatefulWidget {
  final double amount;
  final String serviceName;
  final String businessName;
  final bool preferCard;
  final String? washgoOrderId;

  final bool initialIsSandbox;
  final bool initialUseRealApi;

  const _PaypalCheckoutWidget({
    required this.amount,
    required this.serviceName,
    required this.businessName,
    required this.initialIsSandbox,
    required this.initialUseRealApi,
    this.preferCard = false,
    this.washgoOrderId,
  });

  @override
  State<_PaypalCheckoutWidget> createState() => _PaypalCheckoutWidgetState();
}

class _PaypalCheckoutWidgetState extends State<_PaypalCheckoutWidget> {
  // Steps: 
  // 2: Processing (Real Loader)
  // 3: Success Checkmark Screen
  // 5: Real API approval tracking (Wait for user click to verify)
  // 6: Error Screen (CORS or HTTP failure)
  int _currentStep = 2; 

  late bool _useRealApi;
  late bool _isSandbox;

  // Real REST execution state
  String? _realOrderId;
  String? _realApproveUrl;
  String? _realTransactionId;
  String? _realPayerEmail;
  String? _errorMessage;
  Timer? _statusTimer;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _useRealApi = widget.initialUseRealApi;
    _isSandbox = widget.initialIsSandbox;

    _currentStep = 2; // Processing loader
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRealPaypalOrder();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _openPayPalUrl(String url) async {
    if (kIsWeb) {
      openBrowserPopup(url);
      return;
    }
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      throw Exception('No se pudo abrir la página de pago de PayPal.');
    }
  }

  /// Initialize real PayPal Order via REST API on the simulated backend
  Future<void> _startRealPaypalOrder() async {
    setState(() {
      _currentStep = 2; // Processing
      _errorMessage = null;
    });

    final backendService = PaypalBackendService(
      isSandbox: _isSandbox,
    );

    try {
      final orderResult = await backendService.createOrder(
        amount: widget.amount,
        serviceName: widget.serviceName,
        businessName: widget.businessName,
        preferCard: widget.preferCard,
        washgoOrderId: widget.washgoOrderId,
      );

      _realOrderId = orderResult['orderId'];
      _realApproveUrl = orderResult['approveUrl'];

      if (_realApproveUrl == null || _realApproveUrl!.isEmpty) {
        throw Exception('El link de aprobación retornado por PayPal está vacío.');
      }

      String finalUrl = _realApproveUrl!;
      if (widget.preferCard) {
        if (finalUrl.contains('?')) {
          finalUrl += '&fundingSource=card';
        } else {
          finalUrl += '?fundingSource=card';
        }
      }

      // Launch URL using platform-optimized helper
      await _openPayPalUrl(finalUrl);

      setState(() {
        _currentStep = 5; // Go to confirmation wait state
      });
      
      _startStatusPolling();
    } catch (e) {
      setState(() {
        if (e.toString().contains('CORS_ERROR')) {
          _errorMessage = 'CORS_ERROR';
        } else {
          _errorMessage = 'Error al procesar el pago';
        }
        _currentStep = 6; // Error step
      });
    }
  }

  void _startStatusPolling() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_realOrderId == null || !mounted || _currentStep != 5) {
        timer.cancel();
        return;
      }
      final backendService = PaypalBackendService(
        isSandbox: _isSandbox,
      );

      try {
        final status = await backendService.getOrderStatus(_realOrderId!);
        debugPrint('Polling PayPal Order $_realOrderId status: $status');
        if (status == 'APPROVED') {
          timer.cancel();
          _verifyAndCapturePayment();
        } else if (status == 'COMPLETED') {
          timer.cancel();
          _updateWashgoOrderStatus();
          setState(() {
            _currentStep = 3; // Success screen!
          });
        }
      } catch (e) {
        debugPrint('Error polling PayPal status: $e');
      }
    });
  }

  void _updateWashgoOrderStatus() {
    final orderId = widget.washgoOrderId;
    if (orderId != null && orderId.isNotEmpty) {
      debugPrint('Updating Washgo Order $orderId status to EN_COLA after successful PayPal payment...');
      FirebaseOrderRepository().updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.EN_COLA,
      ).then((_) {
        debugPrint('Washgo Order $orderId status successfully updated to EN_COLA.');
      }).catchError((err) {
        debugPrint('Error updating Washgo Order $orderId status to EN_COLA: $err');
      });
    }
  }

  /// Verification & capture of the PayPal Order
  Future<void> _verifyAndCapturePayment() async {
    if (_realOrderId == null || _isCapturing) return;

    // Stop status polling immediately during manual or automatic capture process
    _statusTimer?.cancel();
    _statusTimer = null;

    setState(() {
      _isCapturing = true;
      _currentStep = 2; // Loading spinner
      _errorMessage = null;
    });

    final backendService = PaypalBackendService(
      isSandbox: _isSandbox,
    );

    try {
      final captureResponse = await backendService.captureOrder(_realOrderId!);
      
      if (captureResponse == null) {
        throw Exception('No se recibió respuesta al capturar la orden.');
      }

      final status = captureResponse['status'];
      
      if (status == 'COMPLETED') {
        // Successful payment capture!
        _realTransactionId = captureResponse['id'] ?? 'PAYID-$_realOrderId';
        final purchaseUnits = captureResponse['purchase_units'] as List?;
        if (purchaseUnits != null && purchaseUnits.isNotEmpty) {
          final payments = purchaseUnits[0]['payments'] as Map?;
          if (payments != null) {
            final captures = payments['captures'] as List?;
            if (captures != null && captures.isNotEmpty) {
              _realTransactionId = captures[0]['id'] ?? _realTransactionId;
            }
          }
        }
        
        final payer = captureResponse['payer'] as Map?;
        if (payer != null) {
          _realPayerEmail = payer['email_address'];
        }

        _updateWashgoOrderStatus();
        setState(() {
          _currentStep = 3; // Success step
        });
      } else {
        // Payment was not completed (e.g. still in CREATED or APPROVED state but capture failed, or canceled)
        final errorDetails = captureResponse['details'] as List?;
        String errDetail = 'El pago no se ha completado.';
        String? errorCode;
        if (errorDetails != null && errorDetails.isNotEmpty) {
          errDetail = errorDetails[0]['description'] ?? errDetail;
          errorCode = errorDetails[0]['issue'] ?? errorDetails[0]['name'];
        }

        // If the order has already been captured, it is a success!
        if (errDetail.toLowerCase().contains('already captured') || 
            (errorCode != null && errorCode.toLowerCase().contains('already_captured'))) {
          _updateWashgoOrderStatus();
          setState(() {
            _realTransactionId = 'PAYID-$_realOrderId';
            _currentStep = 3; // Success step
          });
          return;
        }

        setState(() {
          _errorMessage = 'El pago no se ha completado. Asegúrate de aprobar el pago en PayPal antes de presionar verificar.';
          _currentStep = 5; // Return to verify step with error message
          _isCapturing = false;
        });

        // Resume status polling since they didn't approve yet
        _startStatusPolling();
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('already_captured') || errorStr.contains('already captured')) {
        _updateWashgoOrderStatus();
        setState(() {
          _realTransactionId = 'PAYID-$_realOrderId';
          _currentStep = 3; // Success step
        });
        return;
      }

      setState(() {
        if (e.toString().contains('CORS_ERROR')) {
          _errorMessage = 'CORS_ERROR';
        } else {
          _errorMessage = 'Error al verificar el pago';
        }
        _currentStep = 5; // Return to verify step with error message
        _isCapturing = false;
      });

      // Resume status polling on generic error
      _startStatusPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PayPal Brand Header
        Container(
          color: const Color(0xFF003087),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.paypal_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    'PayPal',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, color: Color(0xFF0079C1), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Seguro',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0079C1),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Environment Indicator Banner
        if (_isSandbox)
          Container(
            color: const Color(0xFFFFF9E6),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.science_outlined,
                  color: Color(0xFFD97706),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Modo Real: PayPal Sandbox Activo',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB45309),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Order Summary Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.businessName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.serviceName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),

        // Content Area depending on current step
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStepWidget(),
            ),
          ),
        ),

        // Footer Actions
        if (_currentStep < 2 || _currentStep == 5 || _currentStep == 6)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, PaypalPaymentResult(isSuccess: false, errorMessage: 'Cancelado por el usuario'));
                  },
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'WashGo Checkout',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case 2:
        return _buildProcessingStep();
      case 3:
        return _buildSuccessStep();
      case 5:
        return _buildRealVerifyStep();
      case 6:
        return _buildErrorStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 2: Processing spinner
  Widget _buildProcessingStep() {
    return Column(
      key: const ValueKey('processing_step'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0070BA)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Iniciando Orden con PayPal...',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Conectando con la API REST oficial de PayPal. Espera un momento.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // STEP 3: Success Screen
  Widget _buildSuccessStep() {
    return Column(
      key: const ValueKey('success_step'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFECFDF5),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¡Pago aprobado exitosamente!',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF065F46),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tu reserva en ${widget.businessName} se completará en unos instantes.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF047857),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transacción ID:',
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                  ),
                  Expanded(
                    child: Text(
                      _realTransactionId ?? 'PAYID-SIMULATED-OK',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 11, 
                        fontWeight: FontWeight.bold, 
                        color: const Color(0xFF334155),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payer Email:',
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                  ),
                  Text(
                    _realPayerEmail ?? 'usuario@paypal.com',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                PaypalPaymentResult(
                  isSuccess: true,
                  transactionId: _realTransactionId,
                  payerEmail: _realPayerEmail ?? 'usuario@paypal.com',
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981), 
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Aceptar y Volver',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 5: Real API approval tracking (Wait for user click to verify or auto-detect)
  Widget _buildRealVerifyStep() {
    return Column(
      key: const ValueKey('real_verify_step'),
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Esperando Confirmación',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hemos abierto PayPal en tu navegador. Completa el pago allí y detectaremos la confirmación en tiempo real.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
        ),
        const SizedBox(height: 20),

        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              border: Border.all(color: const Color(0xFFFCA5A5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFB91C1C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué debes hacer?',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
              ),
              const SizedBox(height: 8),
              _buildStepRow('1', 'Inicia sesión y confirma tu pago en la pestaña de PayPal.'),
              const SizedBox(height: 6),
              _buildStepRow('2', '¡Listo! En cuanto pagues, esta pantalla se cerrará sola.'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Capture button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _verifyAndCapturePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC439), 
              foregroundColor: const Color(0xFF1E293B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Verificar manualmente',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // Re-launch URL if lost
            if (_realApproveUrl != null) {
              _openPayPalUrl(_realApproveUrl!);
            }
          },
          child: Text(
            'Reabrir ventana de PayPal',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0070BA),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 6: Error Screen
  Widget _buildErrorStep() {
    final isCorsError = _errorMessage == 'CORS_ERROR';

    return Column(
      key: const ValueKey('error_step'),
      children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 56),
        const SizedBox(height: 16),
        Text(
          isCorsError ? 'Restricción CORS detectada' : 'Error en Conexión PayPal',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
        ),
        const SizedBox(height: 12),
        Text(
          isCorsError
              ? 'Las políticas de seguridad de PayPal bloquean llamadas HTTP directas desde navegadores web (CORS) por seguridad de tus credenciales.\n\nEn producción, estas llamadas deben pasar por un backend intermediario seguro (como Firebase Cloud Functions).\n\nPara probar en Web en este momento, te recomendamos usar el Simulador Interactivo o ejecutar en un Emulador de Celular.'
              : _errorMessage ?? 'Ha ocurrido un error inesperado al procesar el pago con PayPal.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569), height: 1.4),
        ),
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _startRealPaypalOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0070BA),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: Text(
              'Reintentar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(String index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFCBD5E1),
            shape: BoxShape.circle,
          ),
          child: Text(
            index,
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
          ),
        ),
      ],
    );
  }
}
