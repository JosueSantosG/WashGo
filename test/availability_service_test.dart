import 'package:flutter_test/flutter_test.dart';
import 'package:washgo/features/laundries/services/availability_service.dart';
import 'package:washgo/features/orders/models/order_reservation.dart';

void main() {
  group('AvailabilityService Tests', () {
    final List<Map<String, dynamic>> businessHours = [
      {
        'diaDeLaSemana': 1, // Lunes
        'esDiaDescanso': false,
        'horaApertura': '08:00',
        'horaCierre': '12:00',
      },
      {
        'diaDeLaSemana': 2, // Martes
        'esDiaDescanso': true,
        'horaApertura': null,
        'horaCierre': null,
      },
    ];

    test('generateSlots generates correct 30-minute intervals during open hours', () {
      final monday = DateTime(2026, 6, 22); // Lunes
      final now = DateTime(2026, 6, 22, 7, 0); // Lunes 7:00 AM

      final slots = AvailabilityService.generateSlots(
        date: monday,
        businessHours: businessHours,
        anticipationMinutes: 30,
        now: now,
      );

      // slots: 8:00 (isAfter 7:30 - yes), 8:30, 9:00, 9:30, 10:00, 10:30, 11:00, 11:30
      // 12:00 is closing, so last slot starting is 11:30 (before closing)
      expect(slots.length, equals(8));
      expect(slots.first, equals(DateTime(2026, 6, 22, 8, 0)));
      expect(slots.last, equals(DateTime(2026, 6, 22, 11, 30)));
    });

    test('generateSlots generates 48 slots for a 24-hour business day', () {
      final List<Map<String, dynamic>> businessHours24h = [
        {
          'diaDeLaSemana': 1, // Lunes
          'esDiaDescanso': false,
          'horaApertura': '00:00',
          'horaCierre': '00:00',
        },
      ];
      final monday = DateTime(2026, 6, 22); // Lunes
      final now = DateTime(2026, 6, 21, 23, 0); // Domingo 11:00 PM

      final slots = AvailabilityService.generateSlots(
        date: monday,
        businessHours: businessHours24h,
        anticipationMinutes: 30, // Limit is Domingo 23:30
        now: now,
      );

      // Should generate 48 slots (from 00:00 to 23:30)
      expect(slots.length, equals(48));
      expect(slots.first, equals(DateTime(2026, 6, 22, 0, 0)));
      expect(slots.last, equals(DateTime(2026, 6, 22, 23, 30)));
    });

    test('generateSlots filters out slots before anticipation limit', () {
      final monday = DateTime(2026, 6, 22); // Lunes
      final now = DateTime(2026, 6, 22, 9, 15); // Lunes 9:15 AM

      final slots = AvailabilityService.generateSlots(
        date: monday,
        businessHours: businessHours,
        anticipationMinutes: 30, // Limit is 9:45 AM
        now: now,
      );

      // slots allowed: 10:00, 10:30, 11:00, 11:30
      expect(slots.length, equals(4));
      expect(slots.first, equals(DateTime(2026, 6, 22, 10, 0)));
    });

    test('generateSlots returns empty list on rest day', () {
      final tuesday = DateTime(2026, 6, 23); // Martes
      final now = DateTime(2026, 6, 23, 7, 0);

      final slots = AvailabilityService.generateSlots(
        date: tuesday,
        businessHours: businessHours,
        anticipationMinutes: 30,
        now: now,
      );

      expect(slots, isEmpty);
    });

    test('isSlotAvailable returns true when slots have capacity', () {
      final slot = DateTime(2026, 6, 22, 9, 0);
      final activeReservations = [
        OrderReservation(
          orderId: 'order1',
          businessId: 'biz1',
          scheduledAt: DateTime(2026, 6, 22, 8, 0),
          serviceDurationMinutos: 45, // Ends at 8:45, no overlap
          serviceId: 'service1',
          createdAt: DateTime.now(),
        ),
        OrderReservation(
          orderId: 'order2',
          businessId: 'biz1',
          scheduledAt: DateTime(2026, 6, 22, 9, 30),
          serviceDurationMinutos: 30, // Starts at 9:30, no overlap for a 30-min slot starting at 9:00 (ends at 9:30)
          serviceId: 'service1',
          createdAt: DateTime.now(),
        ),
      ];

      final isAvailable = AvailabilityService.isSlotAvailable(
        slot: slot,
        durationMinutes: 30,
        capacity: 1,
        activeReservations: activeReservations,
      );

      expect(isAvailable, isTrue);
    });

    test('isSlotAvailable returns false when overlapping reservations exceed capacity', () {
      final slot = DateTime(2026, 6, 22, 9, 0);
      final activeReservations = [
        OrderReservation(
          orderId: 'order1',
          businessId: 'biz1',
          scheduledAt: DateTime(2026, 6, 22, 8, 45),
          serviceDurationMinutos: 30, // 8:45 to 9:15, overlaps [9:00, 9:30]
          serviceId: 'service1',
          createdAt: DateTime.now(),
        ),
      ];

      final isAvailable = AvailabilityService.isSlotAvailable(
        slot: slot,
        durationMinutes: 30,
        capacity: 1, // Only 1 vehicle allowed concurrently
        activeReservations: activeReservations,
      );

      expect(isAvailable, isFalse);
    });

    test('getSuggestions returns next 3 available slots', () {
      final requested = DateTime(2026, 6, 22, 8, 30);
      final now = DateTime(2026, 6, 22, 7, 0);

      // We block slots: 9:00, 9:30
      final activeReservations = [
        OrderReservation(
          orderId: 'order1',
          businessId: 'biz1',
          scheduledAt: DateTime(2026, 6, 22, 9, 0),
          serviceDurationMinutos: 60, // Blocks 9:00-10:00
          serviceId: 'service1',
          createdAt: DateTime.now(),
        ),
      ];

      final suggestions = AvailabilityService.getSuggestions(
        requested: requested,
        durationMinutes: 30,
        capacity: 1,
        activeReservations: activeReservations,
        businessHours: businessHours,
        anticipationMinutes: 30,
        now: now,
      );

      // Available slots generated for Monday:
      // 8:00 (not after requested 8:30)
      // 8:30 (not after requested 8:30, excluded by getSuggestions same-day rule: `!slot.isAfter(requested)`)
      // 9:00 (blocked)
      // 9:30 (blocked)
      // 10:00 (available!)
      // 10:30 (available!)
      // 11:00 (available!)
      // 11:30 (available!)
      expect(suggestions.length, equals(3));
      expect(suggestions[0], equals(DateTime(2026, 6, 22, 10, 0)));
      expect(suggestions[1], equals(DateTime(2026, 6, 22, 10, 30)));
      expect(suggestions[2], equals(DateTime(2026, 6, 22, 11, 0)));
    });
  });
}
