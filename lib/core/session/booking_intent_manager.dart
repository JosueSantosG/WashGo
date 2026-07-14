import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BookingIntent {
  final String laundryId;
  final String laundryName;
  final String serviceId;
  final String serviceName;
  final String vehicleCategory; // 'Moto', 'Pequeño', 'Mediano', 'Grande'
  final bool scheduleNow;
  final DateTime selectedDate;
  final DateTime? selectedTimeSlot;
  final DateTime savedAt;

  BookingIntent({
    required this.laundryId,
    required this.laundryName,
    required this.serviceId,
    required this.serviceName,
    required this.vehicleCategory,
    required this.scheduleNow,
    required this.selectedDate,
    this.selectedTimeSlot,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'laundryId': laundryId,
        'laundryName': laundryName,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'vehicleCategory': vehicleCategory,
        'scheduleNow': scheduleNow,
        'selectedDate': selectedDate.toIso8601String(),
        'selectedTimeSlot': selectedTimeSlot?.toIso8601String(),
        'savedAt': savedAt.toIso8601String(),
      };

  factory BookingIntent.fromJson(Map<String, dynamic> json) => BookingIntent(
        laundryId: json['laundryId'] as String,
        laundryName: json['laundryName'] as String,
        serviceId: json['serviceId'] as String,
        serviceName: json['serviceName'] as String,
        vehicleCategory: json['vehicleCategory'] as String,
        scheduleNow: json['scheduleNow'] as bool,
        selectedDate: DateTime.parse(json['selectedDate'] as String),
        selectedTimeSlot: json['selectedTimeSlot'] != null
            ? DateTime.parse(json['selectedTimeSlot'] as String)
            : null,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );
}

class PendingPaymentIntent {
  final String orderId;
  final String paymentMethod;
  final double amount;
  final String serviceName;
  final String businessName;
  final String? businessId;
  final DateTime createdAt;
  final String? transactionId;
  final String? phoneNumber;

  PendingPaymentIntent({
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    required this.serviceName,
    required this.businessName,
    this.businessId,
    required this.createdAt,
    this.transactionId,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'paymentMethod': paymentMethod,
        'amount': amount,
        'serviceName': serviceName,
        'businessName': businessName,
        'businessId': businessId,
        'createdAt': createdAt.toIso8601String(),
        'transactionId': transactionId,
        'phoneNumber': phoneNumber,
      };

  factory PendingPaymentIntent.fromJson(Map<String, dynamic> json) =>
      PendingPaymentIntent(
        orderId: json['orderId'] as String,
        paymentMethod: json['paymentMethod'] as String,
        amount: (json['amount'] as num).toDouble(),
        serviceName: json['serviceName'] as String,
        businessName: json['businessName'] as String,
        businessId: json['businessId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        transactionId: json['transactionId'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
      );
}

class BookingIntentManager {
  BookingIntentManager._privateConstructor();
  static final BookingIntentManager instance = BookingIntentManager._privateConstructor();

  static const _key = 'booking_intent';
  static const _pendingPaymentKey = 'pending_payment_intent';
  static const _maxAge = Duration(hours: 24);

  SharedPreferences? _prefs;
  BookingIntent? _intent;

  Future<void> ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
    // On init, _intent stays null; getIntent() will lazy-load from prefs.
  }

  void saveIntent(BookingIntent intent) {
    _intent = intent;
    _persistIntent(intent);
  }

  BookingIntent? getIntent() {
    if (_intent != null) {
      // Check TTL on in-memory intent
      if (DateTime.now().difference(_intent!.savedAt) > _maxAge) {
        clearIntent();
        return null;
      }
      return _intent;
    }

    // Lazy-load from SharedPreferences
    _intent = _loadIntent();
    if (_intent != null) {
      // Check TTL on loaded intent
      if (DateTime.now().difference(_intent!.savedAt) > _maxAge) {
        clearIntent();
        return null;
      }
    }
    return _intent;
  }

  bool hasIntentForLaundry(String laundryId) {
    return getIntent()?.laundryId == laundryId;
  }

  void clearIntent() {
    _intent = null;
    _removePersistedIntent();
  }

  // ---- Pending Payment Intent ----

  void savePendingPaymentIntent(PendingPaymentIntent intent) {
    _persistPendingPaymentIntent(intent);
  }

  PendingPaymentIntent? getPendingPaymentIntent() {
    return _loadPendingPaymentIntent();
  }

  bool hasPendingPaymentIntent() {
    final intent = getPendingPaymentIntent();
    if (intent == null) return false;
    final age = DateTime.now().difference(intent.createdAt);
    if (age > _maxAge) {
      clearPendingPaymentIntent();
      return false;
    }
    return true;
  }

  void clearPendingPaymentIntent() {
    _removePersistedPendingPaymentIntent();
  }

  bool hasIntent() {
    return getIntent() != null;
  }

  /// Resets the singleton to its initial state. Only for testing.
  static void resetForTesting() {
    instance._intent = null;
    instance._prefs = null;
  }

  // ---- Private persistence helpers ----

  void _persistIntent(BookingIntent intent) {
    _prefs?.setString(_key, jsonEncode(intent.toJson()));
  }

  BookingIntent? _loadIntent() {
    final raw = _prefs?.getString(_key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return BookingIntent.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  void _removePersistedIntent() {
    _prefs?.remove(_key);
  }

  void _persistPendingPaymentIntent(PendingPaymentIntent intent) {
    _prefs?.setString(_pendingPaymentKey, jsonEncode(intent.toJson()));
  }

  PendingPaymentIntent? _loadPendingPaymentIntent() {
    final raw = _prefs?.getString(_pendingPaymentKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return PendingPaymentIntent.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  void _removePersistedPendingPaymentIntent() {
    _prefs?.remove(_pendingPaymentKey);
  }
}
