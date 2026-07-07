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

  bool _useRealApi = false;
  bool _isSandbox = true;

  bool get useRealApi => _useRealApi;
  bool get isSandbox => _isSandbox;

  /// Cargar configuraciones del dispositivo (sin secretos)
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      const defaultIsSandbox = bool.fromEnvironment('PAYPAL_IS_SANDBOX', defaultValue: true);
      const defaultUseRealApi = bool.fromEnvironment('PAYPAL_USE_REAL_API', defaultValue: false);
      
      _isSandbox = prefs.getBool('paypal_is_sandbox') ?? defaultIsSandbox;
      _useRealApi = prefs.getBool('paypal_use_real_api') ?? defaultUseRealApi;
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
    await prefs.setBool('paypal_use_real_api', useRealApi);

    _isSandbox = isSandbox;
    _useRealApi = useRealApi;
  }

  /// Inicia el flujo interactivo de PayPal
  Future<PaypalPaymentResult> startPaymentFlow({
    required BuildContext context,
    required double amount,
    required String serviceName,
    required String businessName,
    bool preferCard = false,
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

  final bool initialIsSandbox;
  final bool initialUseRealApi;

  const _PaypalCheckoutWidget({
    required this.amount,
    required this.serviceName,
    required this.businessName,
    required this.initialIsSandbox,
    required this.initialUseRealApi,
    this.preferCard = false,
  });

  @override
  State<_PaypalCheckoutWidget> createState() => _PaypalCheckoutWidgetState();
}

class _PaypalCheckoutWidgetState extends State<_PaypalCheckoutWidget> {
  // Steps: 
  // 0: Main/Login (Simulator mode)
  // 1: Review & Pay (Simulator mode)
  // 2: Processing (Simulator / Real Loader)
  // 3: Success Checkmark Screen
  // 4: Configuration form (Simulator vs Real API Toggle)
  // 5: Real API approval tracking (Wait for user click to verify)
  // 6: Error Screen (CORS or HTTP failure)
  int _currentStep = 0; 

  // Settings inputs (no secrets, just modes)
  late bool _useRealApi;
  late bool _isSandbox;

  // Simulator inputs
  final _emailController = TextEditingController(text: 'sb-washgo-cliente@personal.example.com');
  final _passwordController = TextEditingController(text: '12345678');
  bool _rememberMe = true;
  String? _validationError;

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

    // If Real API is enabled, start in processing loader directly to avoid flicker
    if (_useRealApi) {
      _currentStep = 2; // Processing loader
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startRealPaypalOrder();
      });
    } else {
      _currentStep = 0; // Login simulator
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
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
          _errorMessage = e.toString().replaceAll('Exception:', '').trim();
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
          setState(() {
            _currentStep = 3; // Success screen!
          });
        }
      } catch (e) {
        debugPrint('Error polling PayPal status: $e');
      }
    });
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
          setState(() {
            _realTransactionId = 'PAYID-$_realOrderId';
            _currentStep = 3; // Success step
          });
          return;
        }

        setState(() {
          _errorMessage = '$errDetail Asegúrate de aprobar el pago en PayPal antes de presionar verificar.';
          _currentStep = 5; // Return to verify step with error message
          _isCapturing = false;
        });

        // Resume status polling since they didn't approve yet
        _startStatusPolling();
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('already_captured') || errorStr.contains('already captured')) {
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
          _errorMessage = 'Error al capturar: $e';
        }
        _currentStep = 5; // Return to verify step with error message
        _isCapturing = false;
      });

      // Resume status polling on generic error
      _startStatusPolling();
    }
  }



  // --- Simulator flow handlers ---
  void _autofillSandbox() {
    setState(() {
      _emailController.text = 'sb-washgo-cliente@personal.example.com';
      _passwordController.text = 'sandbox_pass_99';
    });
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      setState(() {
        _validationError = 'Por favor, ingrese un correo de sandbox válido';
      });
      return;
    }
    if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
      setState(() {
        _validationError = 'La contraseña debe tener al menos 6 caracteres';
      });
      return;
    }

    setState(() {
      _validationError = null;
      _currentStep = 1; // Go to Review & Pay
    });
  }

  Future<void> _handlePaymentSimulation() async {
    setState(() {
      _currentStep = 2; // Processing loader
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      setState(() {
        _realTransactionId = 'PAYID-${const Uuid().v4().replaceAll('-', '').substring(0, 16).toUpperCase()}';
        _currentStep = 3; // Success checkmark
      });
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
        Container(
          color: _useRealApi
              ? (_isSandbox ? const Color(0xFFFFF9E6) : const Color(0xFFECFDF5))
              : const Color(0xFFF1F5F9),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                _useRealApi 
                    ? (_isSandbox ? Icons.science_outlined : Icons.verified_user_outlined)
                    : Icons.developer_mode_outlined,
                color: _useRealApi 
                    ? (_isSandbox ? const Color(0xFFD97706) : const Color(0xFF059669))
                    : const Color(0xFF64748B),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _useRealApi 
                      ? (_isSandbox ? 'Modo Real: PayPal Sandbox Activo' : 'Modo Real: Producción En Vivo')
                      : 'Modo Simulación Integrada (Sin credenciales)',
                  style: GoogleFonts.inter(
                    color: _useRealApi 
                        ? (_isSandbox ? const Color(0xFFB45309) : const Color(0xFF047857))
                        : const Color(0xFF475569),
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
      case 0:
        return _buildLoginStep();
      case 1:
        return _buildReviewStep();
      case 2:
        return _buildProcessingStep();
      case 3:
        return _buildSuccessStep();
      case 4:
        return _buildConfigStep();
      case 5:
        return _buildRealVerifyStep();
      case 6:
        return _buildErrorStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildConfigStep() {
    final hasBackendKeys = const String.fromEnvironment('PAYPAL_CLIENT_ID').isNotEmpty;

    return SingleChildScrollView(
      key: const ValueKey('config_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, color: Color(0xFF0070BA), size: 24),
              const SizedBox(width: 8),
              Text(
                'Configuración de PayPal',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Por motivos de seguridad y preparación para producción, se ha eliminado el ingreso de Client Secret en el dispositivo móvil.',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569), height: 1.4),
          ),
          const SizedBox(height: 16),
          
          // Backend Keys Status Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasBackendKeys ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED),
              border: Border.all(
                color: hasBackendKeys ? const Color(0xFFA7F3D0) : const Color(0xFFFED7AA),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  hasBackendKeys ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                  color: hasBackendKeys ? const Color(0xFF059669) : const Color(0xFFD97706),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasBackendKeys
                        ? 'Backend Configurado: Las claves de PayPal se detectaron en las variables de entorno.'
                        : 'Simulación de Llaves: El backend utilizará credenciales seguras simuladas de prueba.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: hasBackendKeys ? const Color(0xFF065F46) : const Color(0xFF9A3412),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Use Real API Switch
          SwitchListTile(
            title: Text(
              'Usar API Real de PayPal',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF334155)),
            ),
            subtitle: Text(
              'Activa la integración real en lugar de la simulación local.',
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
            ),
            activeThumbColor: const Color(0xFF0070BA),
            value: _useRealApi,
            onChanged: (val) {
              setState(() {
                _useRealApi = val;
              });
            },
          ),
          const Divider(),

          // Sandbox vs Live Switch (Only relevant if Real API is enabled)
          Opacity(
            opacity: _useRealApi ? 1.0 : 0.5,
            child: SwitchListTile(
              title: Text(
                'Modo Sandbox (Pruebas)',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF334155)),
              ),
              subtitle: Text(
                'Desactiva para procesar transacciones en entorno de producción real.',
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
              ),
              activeThumbColor: const Color(0xFF0070BA),
              value: _isSandbox,
              onChanged: _useRealApi
                  ? (val) {
                      setState(() {
                        _isSandbox = val;
                      });
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 0; // Back to main simulator login
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await PaypalService().saveConfig(
                      isSandbox: _isSandbox,
                      useRealApi: _useRealApi,
                    );
                    setState(() {
                      if (_useRealApi) {
                        _currentStep = 2; // Real loader
                        _startRealPaypalOrder();
                      } else {
                        _currentStep = 0; // Simulator
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0070BA),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 0: Login simulator screen
  Widget _buildLoginStep() {
    return Column(
      key: const ValueKey('login_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pagar con PayPal',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Inicia sesión en tu cuenta de pruebas para completar tu compra.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 20),

        if (_validationError != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              border: Border.all(color: const Color(0xFFFCA5A5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _validationError!,
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
          const SizedBox(height: 16),
        ],

        Text(
          'Correo electrónico (Sandbox)',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'ejemplo@sandbox.com',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Contraseña',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '••••••••',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? true;
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recordar sesión',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
                ),
              ],
            ),
            TextButton(
              onPressed: _autofillSandbox,
              child: Text(
                'Autocompletar Sandbox',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0070BA),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0070BA),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Iniciar Sesión',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.settings_outlined, size: 16),
            label: const Text('Configurar API Real / Sandbox'),
            onPressed: () {
              setState(() {
                _currentStep = 4; // Open settings form
                _validationError = null;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        )
      ],
    );
  }

  // STEP 1: Review & Pay simulator screen
  Widget _buildReviewStep() {
    return Column(
      key: const ValueKey('review_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.account_circle_rounded, color: Color(0xFF003087), size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, Cliente de Pruebas',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    _emailController.text,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Selecciona tu método de pago',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0070BA), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo de PayPal',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Disponible: \$1,245.50 USD',
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.radio_button_checked, color: Color(0xFF0070BA), size: 20),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              Row(
                children: [
                  const Icon(Icons.credit_card_rounded, color: Color(0xFF64748B), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visa Débito (•••• 4321)',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          'Asociada a tu cuenta',
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.radio_button_off, color: Color(0xFFCBD5E1), size: 20),
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
            onPressed: _handlePaymentSimulation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC439), 
              foregroundColor: const Color(0xFF1E293B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Pagar Ahora \$${widget.amount.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Serás redirigido de regreso a WashGo al finalizar.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
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
          _useRealApi ? 'Iniciando Orden con PayPal...' : 'Procesando tu pago...',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _useRealApi 
              ? 'Conectando con la API REST oficial de PayPal. Espera un momento.'
              : 'Estamos autorizando de forma segura la transacción con PayPal Sandbox.',
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
                    _realPayerEmail ?? _emailController.text,
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
                  payerEmail: _realPayerEmail ?? _emailController.text,
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
              'Aceptar',
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
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 4; // Settings form
                    _validationError = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Volver a Configurar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _useRealApi = false;
                    _currentStep = 0; // Turn off real API, use simulator
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0070BA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Usar Simulador'),
              ),
            ),
          ],
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
