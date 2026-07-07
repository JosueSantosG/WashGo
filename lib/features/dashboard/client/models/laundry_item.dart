import 'package:latlong2/latlong.dart';

class LaundryItem {
  final String id;
  final String name;
  final String type;
  final double rating;
  final int reviewsCount;
  final String distance;
  final double distanceInMeters;
  final double price;
  final LatLng location;
  final bool isEco;
  final bool isOpen;
  final String waitTime;
  final String phone;
  final List<Map<String, dynamic>> businessHours;

  const LaundryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.distanceInMeters,
    required this.price,
    required this.location,
    required this.isEco,
    required this.isOpen,
    required this.waitTime,
    required this.phone,
    this.businessHours = const [],
  });
}
