import '../../orders/models/order_reservation.dart';

class AvailabilityService {
  /// Genera los slots disponibles para un día específico basado en el horario del negocio y el tiempo de anticipación.
  /// Los slots se generan en intervalos de 30 minutos.
  static List<DateTime> generateSlots({
    required DateTime date,
    required List<Map<String, dynamic>> businessHours,
    required int anticipationMinutes,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();
    final dayOfWeek = date.weekday; // 1 = Lunes, 7 = Domingo (en Dart weekday es 1-7)

    // Ajustar el weekday de Dart (1=Lunes, 7=Domingo) al diaDeLaSemana de la BD.
    // Busquemos las horas para este día de la semana.
    final dayConfig = businessHours.firstWhere(
      (bh) => (bh['diaDeLaSemana'] as int) == dayOfWeek,
      orElse: () => {},
    );

    if (dayConfig.isEmpty || (dayConfig['esDiaDescanso'] as bool? ?? false)) {
      return [];
    }

    final horaAperturaStr = dayConfig['horaApertura'] as String?;
    final horaCierreStr = dayConfig['horaCierre'] as String?;

    if (horaAperturaStr == null || horaCierreStr == null) {
      return [];
    }

    // Parsear horas "HH:MM"
    final openingParts = horaAperturaStr.split(':');
    final closingParts = horaCierreStr.split(':');
    if (openingParts.length < 2 || closingParts.length < 2) return [];

    final openingHour = int.parse(openingParts[0]);
    final openingMinute = int.parse(openingParts[1]);
    final closingHour = int.parse(closingParts[0]);
    final closingMinute = int.parse(closingParts[1]);

    final startOfDay = DateTime(date.year, date.month, date.day, openingHour, openingMinute);
    var endOfDay = DateTime(date.year, date.month, date.day, closingHour, closingMinute);

    if (openingHour == closingHour && openingMinute == closingMinute) {
      endOfDay = endOfDay.add(const Duration(days: 1));
    }

    final List<DateTime> slots = [];
    var currentSlot = startOfDay;

    // Calcular el límite de anticipación (ahora + minutosAnticipacion)
    final minAllowedTime = referenceTime.add(Duration(minutes: anticipationMinutes));

    while (currentSlot.isBefore(endOfDay)) {
      // El slot debe ser posterior a la hora actual + anticipación
      if (currentSlot.isAfter(minAllowedTime)) {
        slots.add(currentSlot);
      }
      currentSlot = currentSlot.add(const Duration(minutes: 30));
    }

    return slots;
  }

  /// Verifica si un slot específico de tiempo tiene capacidad disponible.
  static bool isSlotAvailable({
    required DateTime slot,
    required int durationMinutes,
    required int capacity,
    required List<OrderReservation> activeReservations,
  }) {
    final slotStart = slot;
    final slotEnd = slot.add(Duration(minutes: durationMinutes));

    // 1. Filtrar las reservas que se solapan con el intervalo del slot [slotStart, slotEnd]
    final overlapping = activeReservations.where((res) {
      final resStart = res.scheduledAt;
      final resEnd = resStart.add(Duration(minutes: res.serviceDurationMinutos));
      // Se solapan si: resStart < slotEnd AND resEnd > slotStart
      return resStart.isBefore(slotEnd) && resEnd.isAfter(slotStart);
    }).toList();

    // 2. Evaluar la concurrencia máxima en cualquier punto del intervalo del slot.
    // Los puntos de interés son el inicio del slot y el inicio de cualquier reserva que solape.
    final pointsToCheck = <DateTime>{slotStart};
    for (final res in overlapping) {
      if (res.scheduledAt.isAfter(slotStart) && res.scheduledAt.isBefore(slotEnd)) {
        pointsToCheck.add(res.scheduledAt);
      }
    }

    for (final t in pointsToCheck) {
      // Contar cuántas reservas activas cubren el instante t
      final activeCount = overlapping.where((res) {
        final resStart = res.scheduledAt;
        final resEnd = resStart.add(Duration(minutes: res.serviceDurationMinutos));
        // t está en [resStart, resEnd)
        return (t.isAtSameMomentAs(resStart) || t.isAfter(resStart)) && t.isBefore(resEnd);
      }).length;

      if (activeCount >= capacity) {
        return false;
      }
    }

    return true;
  }

  /// Genera las siguientes 3 alternativas disponibles a partir de una fecha/hora solicitada.
  static List<DateTime> getSuggestions({
    required DateTime requested,
    required int durationMinutes,
    required int capacity,
    required List<OrderReservation> activeReservations,
    required List<Map<String, dynamic>> businessHours,
    required int anticipationMinutes,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();
    final List<DateTime> suggestions = [];
    
    // Empezamos a buscar desde el día del slot solicitado hasta 3 días en el futuro
    for (int dayOffset = 0; dayOffset < 4; dayOffset++) {
      final checkDate = requested.add(Duration(days: dayOffset));
      final daySlots = generateSlots(
        date: checkDate,
        businessHours: businessHours,
        anticipationMinutes: anticipationMinutes,
        now: referenceTime,
      );

      for (final slot in daySlots) {
        // Si buscamos en el mismo día del requested, solo slots posteriores a requested
        if (dayOffset == 0 && !slot.isAfter(requested)) {
          continue;
        }

        if (isSlotAvailable(
          slot: slot,
          durationMinutes: durationMinutes,
          capacity: capacity,
          activeReservations: activeReservations,
        )) {
          suggestions.add(slot);
          if (suggestions.length >= 3) {
            return suggestions;
          }
        }
      }
    }

    return suggestions;
  }
}
