import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:washgo/features/dashboard/client/home_page.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late LatLng _currentPosition;
  final MapController _mapController = MapController();
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Use widget's initial location, cached user location, or default fallback to Guayaquil center
    _currentPosition = widget.initialLocation ?? HomePage.cachedUserLocation ?? const LatLng(-2.1961601, -79.8862076);
    _getUserLocation();
  }

  void _moveToPosition(LatLng position) {
    if (!mounted) return;
    setState(() {
      _currentPosition = position;
    });
    if (_isMapReady) {
      try {
        _mapController.move(position, 15.0);
      } catch (e) {
        debugPrint('Error moving map: $e');
      }
    } else {
      // Retry in 100ms if the map controller isn't ready
      Future.delayed(const Duration(milliseconds: 100), () => _moveToPosition(position));
    }
  }

  Future<void> _getUserLocation() async {
    if (widget.initialLocation != null) return;
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      // Attempt to immediately load last known position (if supported)
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          _moveToPosition(LatLng(lastKnown.latitude, lastKnown.longitude));
        }
      } catch (_) {}

      // Get current fresh position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _moveToPosition(LatLng(position.latitude, position.longitude));
    } catch (e) {
      debugPrint('Error getting location for picker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 15.0,
                onMapReady: () {
                  setState(() {
                    _isMapReady = true;
                  });
                },
                onPositionChanged: (camera, hasGesture) {
                  setState(() {
                    _currentPosition = camera.center;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.washgo',
                ),
              ],
            ),
          ),
          // Center pin indicator
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.0), // Adjust to point exactly to the center
              child: Icon(
                Icons.location_on,
                size: 50.0,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                context.pop(_currentPosition);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirmar Ubicación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
