class BusinessReservationConfig {
  final int capacidadSimultanea;
  final int tiempoAnticipacionMinutos;
  final bool isConfigured;

  const BusinessReservationConfig({
    required this.capacidadSimultanea,
    required this.tiempoAnticipacionMinutos,
    required this.isConfigured,
  });

  factory BusinessReservationConfig.empty() {
    return const BusinessReservationConfig(
      capacidadSimultanea: 1,
      tiempoAnticipacionMinutos: 0,
      isConfigured: false,
    );
  }

  factory BusinessReservationConfig.fromJson(Map<String, dynamic> json) {
    return BusinessReservationConfig(
      capacidadSimultanea: json['capacidadSimultanea'] as int? ?? 1,
      tiempoAnticipacionMinutos: json['tiempoAnticipacionMinutos'] as int? ?? 0,
      isConfigured: json['isConfigured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capacidadSimultanea': capacidadSimultanea,
      'tiempoAnticipacionMinutos': tiempoAnticipacionMinutos,
      'isConfigured': isConfigured,
    };
  }

  BusinessReservationConfig copyWith({
    int? capacidadSimultanea,
    int? tiempoAnticipacionMinutos,
    bool? isConfigured,
  }) {
    return BusinessReservationConfig(
      capacidadSimultanea: capacidadSimultanea ?? this.capacidadSimultanea,
      tiempoAnticipacionMinutos: tiempoAnticipacionMinutos ?? this.tiempoAnticipacionMinutos,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }
}
