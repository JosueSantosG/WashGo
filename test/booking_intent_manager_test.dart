import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:washgo/core/session/booking_intent_manager.dart';

BookingIntent createTestIntent({
  String laundryId = 'test-laundry-1',
  String laundryName = 'Test Lavandería',
  String serviceId = 'service-1',
  String serviceName = 'Lavado Completo',
  String vehicleCategory = 'Mediano',
  String? plate = 'ABC-1234',
  bool scheduleNow = true,
  DateTime? selectedDate,
  DateTime? selectedTimeSlot,
  DateTime? savedAt,
}) {
  return BookingIntent(
    laundryId: laundryId,
    laundryName: laundryName,
    serviceId: serviceId,
    serviceName: serviceName,
    vehicleCategory: vehicleCategory,
    plate: plate,
    scheduleNow: scheduleNow,
    selectedDate: selectedDate ?? DateTime(2026, 7, 8),
    selectedTimeSlot: selectedTimeSlot,
    savedAt: savedAt ?? DateTime(2026, 7, 8, 10, 0, 0),
  );
}

void main() {
  setUp(() {
    BookingIntentManager.resetForTesting();
  });

  group('BookingIntent serialization', () {
    test('toJson / fromJson round-trip preserves all fields', () {
      final original = createTestIntent(
        selectedDate: DateTime(2026, 7, 8),
        selectedTimeSlot: DateTime(2026, 7, 8, 14, 30),
        savedAt: DateTime(2026, 7, 8, 10, 0, 0),
      );

      final json = original.toJson();
      final restored = BookingIntent.fromJson(json);

      expect(restored.laundryId, equals('test-laundry-1'));
      expect(restored.laundryName, equals('Test Lavandería'));
      expect(restored.serviceId, equals('service-1'));
      expect(restored.serviceName, equals('Lavado Completo'));
      expect(restored.vehicleCategory, equals('Mediano'));
      expect(restored.plate, equals('ABC-1234'));
      expect(restored.scheduleNow, isTrue);
      expect(restored.selectedDate, equals(DateTime(2026, 7, 8)));
      expect(restored.selectedTimeSlot, equals(DateTime(2026, 7, 8, 14, 30)));
      expect(restored.savedAt, equals(DateTime(2026, 7, 8, 10, 0, 0)));
    });

    test('null optional fields survive round-trip', () {
      final original = createTestIntent(
        plate: null,
        selectedTimeSlot: null,
        selectedDate: DateTime(2026, 7, 8),
        savedAt: DateTime(2026, 7, 8, 10, 0, 0),
      );

      final json = original.toJson();
      final restored = BookingIntent.fromJson(json);

      expect(restored.plate, isNull);
      expect(restored.selectedTimeSlot, isNull);
      expect(restored.laundryId, equals('test-laundry-1'));
      expect(restored.scheduleNow, isTrue);
    });
  });

  group('BookingIntentManager persistence', () {
    test('SharedPreferences persistence survives reset', () async {
      SharedPreferences.setMockInitialValues({});
      await BookingIntentManager.instance.ensureInitialized();

      final intent = createTestIntent();
      BookingIntentManager.instance.saveIntent(intent);

      // Reset singleton to simulate app restart
      BookingIntentManager.resetForTesting();
      await BookingIntentManager.instance.ensureInitialized();

      final loaded = BookingIntentManager.instance.getIntent();
      expect(loaded, isNotNull);
      expect(loaded!.laundryId, equals('test-laundry-1'));
      expect(loaded.laundryName, equals('Test Lavandería'));
      expect(loaded.serviceId, equals('service-1'));
      expect(loaded.serviceName, equals('Lavado Completo'));
      expect(loaded.vehicleCategory, equals('Mediano'));
      expect(loaded.plate, equals('ABC-1234'));
      expect(loaded.scheduleNow, isTrue);
    });

    test('clearIntent removes both memory and persisted intent', () async {
      SharedPreferences.setMockInitialValues({});
      await BookingIntentManager.instance.ensureInitialized();

      final intent = createTestIntent();
      BookingIntentManager.instance.saveIntent(intent);
      expect(BookingIntentManager.instance.hasIntent(), isTrue);

      BookingIntentManager.instance.clearIntent();
      expect(BookingIntentManager.instance.hasIntent(), isFalse);
      expect(BookingIntentManager.instance.getIntent(), isNull);

      // Reset and re-initialize to confirm persistence was also cleared
      BookingIntentManager.resetForTesting();
      await BookingIntentManager.instance.ensureInitialized();

      expect(BookingIntentManager.instance.hasIntent(), isFalse);
      expect(BookingIntentManager.instance.getIntent(), isNull);
    });
  });

  group('TTL expiry', () {
    test('intent older than 24h is discarded and cleared', () async {
      SharedPreferences.setMockInitialValues({});
      await BookingIntentManager.instance.ensureInitialized();

      // Create intent with savedAt 25 hours in the past
      final expired = createTestIntent(
        savedAt: DateTime.now().subtract(const Duration(hours: 25)),
      );
      BookingIntentManager.instance.saveIntent(expired);

      // getIntent should detect TTL and return null
      final loaded = BookingIntentManager.instance.getIntent();
      expect(loaded, isNull);
      expect(BookingIntentManager.instance.hasIntent(), isFalse);

      // Reset and re-initialize to confirm persistence was also cleaned
      BookingIntentManager.resetForTesting();
      await BookingIntentManager.instance.ensureInitialized();

      expect(BookingIntentManager.instance.getIntent(), isNull);
    });

    test('intent within 24h is still valid', () async {
      SharedPreferences.setMockInitialValues({});
      await BookingIntentManager.instance.ensureInitialized();

      // Create intent with savedAt 1 hour ago (well within TTL)
      final valid = createTestIntent(
        savedAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      BookingIntentManager.instance.saveIntent(valid);

      final loaded = BookingIntentManager.instance.getIntent();
      expect(loaded, isNotNull);
      expect(loaded!.laundryId, equals('test-laundry-1'));
    });
  });
}
