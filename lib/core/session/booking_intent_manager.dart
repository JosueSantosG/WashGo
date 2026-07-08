class BookingIntent {
  final String laundryId;
  final String serviceId;
  final String vehicleCategory; // 'Moto', 'Pequeño', 'Mediano', 'Grande'
  final String? plate;
  final bool scheduleNow;
  final DateTime selectedDate;
  final DateTime? selectedTimeSlot;

  BookingIntent({
    required this.laundryId,
    required this.serviceId,
    required this.vehicleCategory,
    this.plate,
    required this.scheduleNow,
    required this.selectedDate,
    this.selectedTimeSlot,
  });
}

class BookingIntentManager {
  BookingIntentManager._privateConstructor();
  static final BookingIntentManager instance = BookingIntentManager._privateConstructor();

  BookingIntent? _intent;

  void saveIntent(BookingIntent intent) {
    _intent = intent;
  }

  BookingIntent? getIntent() {
    return _intent;
  }

  void clearIntent() {
    _intent = null;
  }

  bool hasIntent() {
    return _intent != null;
  }
}
