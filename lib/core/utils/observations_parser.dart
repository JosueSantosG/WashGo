class ParsedObservations {
  final String scheduleType;
  final String dateTime;
  final String vehicleDetails;

  ParsedObservations({
    required this.scheduleType,
    required this.dateTime,
    required this.vehicleDetails,
  });

  factory ParsedObservations.parse(String? obs) {
    if (obs == null || obs.trim().isEmpty) {
      return ParsedObservations(
        scheduleType: 'Ahora mismo',
        dateTime: '22/05/2026 18:00',
        vehicleDetails: 'Vehículo no especificado',
      );
    }

    // Match pattern: "Ahora mismo (22/05/2026 18:30) - Vehículo: Mazda 3 - Placa: ABC-1234"
    final scheduleRegex = RegExp(r'^(Ahora mismo|Programado)\s*\(([^)]+)\)\s*-\s*Vehículo:\s*(.*)$');
    final match = scheduleRegex.firstMatch(obs);

    if (match != null) {
      final type = match.group(1) ?? 'Ahora mismo';
      final dt = match.group(2) ?? '22/05/2026 18:00';
      final veh = match.group(3) ?? 'Vehículo';
      return ParsedObservations(
        scheduleType: type,
        dateTime: dt,
        vehicleDetails: veh,
      );
    }

    // Match pattern without vehicle suffix: "Ahora mismo (22/05/2026 18:30)"
    final simpleRegex = RegExp(r'^(Ahora mismo|Programado)\s*\(([^)]+)\)(.*)$');
    final simpleMatch = simpleRegex.firstMatch(obs);
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
      );
    }

    // If it starts with "Vehículo:"
    if (obs.startsWith('Vehículo:')) {
      return ParsedObservations(
        scheduleType: 'Ahora mismo',
        dateTime: '22/05/2026 18:00', // fallback for old orders
        vehicleDetails: obs.replaceFirst('Vehículo:', '').trim(),
      );
    }

    // Default fallback for any other string format
    return ParsedObservations(
      scheduleType: 'Ahora mismo',
      dateTime: '22/05/2026 18:00', // fallback for old orders
      vehicleDetails: obs,
    );
  }
}
