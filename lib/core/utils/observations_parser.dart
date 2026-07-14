class ParsedObservations {
  final String scheduleType;
  final String dateTime;
  final String vehicleDetails;
  final List<String> rescheduleHistory;

  ParsedObservations({
    required this.scheduleType,
    required this.dateTime,
    required this.vehicleDetails,
    this.rescheduleHistory = const [],
  });

  factory ParsedObservations.parse(String? obs) {
    if (obs == null || obs.trim().isEmpty) {
      return ParsedObservations(
        scheduleType: 'Ahora mismo',
        dateTime: '22/05/2026 18:00',
        vehicleDetails: 'Vehículo no especificado',
        rescheduleHistory: const [],
      );
    }

    String mainPart = obs;
    List<String> history = [];
    if (obs.contains(' | Historial: ')) {
      final parts = obs.split(' | Historial: ');
      mainPart = parts[0];
      if (parts.length > 1) {
        history = parts[1].split(' -> ').map((s) => s.trim()).toList();
      }
    }

    // Match pattern: "Ahora mismo (22/05/2026 18:30) - Vehículo: Mazda 3 - Placa: ABC-1234"
    final scheduleRegex = RegExp(r'^(Ahora mismo|Programado)\s*\(([^)]+)\)\s*-\s*Vehículo:\s*(.*)$');
    final match = scheduleRegex.firstMatch(mainPart);

    if (match != null) {
      final type = match.group(1) ?? 'Ahora mismo';
      final dt = match.group(2) ?? '22/05/2026 18:00';
      final veh = match.group(3) ?? 'Vehículo';
      return ParsedObservations(
        scheduleType: type,
        dateTime: dt,
        vehicleDetails: veh,
        rescheduleHistory: history,
      );
    }

    // Match pattern without vehicle suffix: "Ahora mismo (22/05/2026 18:30)"
    final simpleRegex = RegExp(r'^(Ahora mismo|Programado)\s*\(([^)]+)\)(.*)$');
    final simpleMatch = simpleRegex.firstMatch(mainPart);
    if (simpleMatch != null) {
      final type = simpleMatch.group(1) ?? 'Ahora mismo';
      final dt = simpleMatch.group(2) ?? '22/05/2026 18:00';
      var rest = simpleMatch.group(3) ?? '';
      if (rest.startsWith(' - Vehículo:')) {
        rest = rest.replaceFirst(' - Vehículo:', '');
      } else if (rest.startsWith(' - ')) {
        rest = rest.replaceFirst(' - ', '');
      }
      return ParsedObservations(
        scheduleType: type,
        dateTime: dt,
        vehicleDetails: rest.trim().isEmpty ? 'Vehículo' : rest.trim(),
        rescheduleHistory: history,
      );
    }

    // If it starts with "Vehículo:"
    if (mainPart.startsWith('Vehículo:')) {
      return ParsedObservations(
        scheduleType: 'Ahora mismo',
        dateTime: '22/05/2026 18:00', // fallback for old orders
        vehicleDetails: mainPart.replaceFirst('Vehículo:', '').trim(),
        rescheduleHistory: history,
      );
    }

    // Default fallback for any other string format
    return ParsedObservations(
      scheduleType: 'Ahora mismo',
      dateTime: '22/05/2026 18:00', // fallback for old orders
      vehicleDetails: mainPart,
      rescheduleHistory: history,
    );
  }
}
