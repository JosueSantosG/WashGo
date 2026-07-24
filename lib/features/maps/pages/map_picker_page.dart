import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:washgo/features/dashboard/client/home_page.dart';

class MapPickerPage extends StatefulWidget {
  final latlong.LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late latlong.LatLng _currentPosition;
  gmaps.GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Use widget's initial location, cached user location, or default fallback to Guayaquil center
    _currentPosition = widget.initialLocation ?? HomePage.cachedUserLocation ?? const latlong.LatLng(-2.1961601, -79.8862076);
    _getUserLocation();
  }

  void _moveToPosition(latlong.LatLng position) {
    if (!mounted) return;
    setState(() {
      _currentPosition = position;
    });
    _mapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngZoom(
        gmaps.LatLng(position.latitude, position.longitude),
        15.0,
      ),
    );
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
          _moveToPosition(latlong.LatLng(lastKnown.latitude, lastKnown.longitude));
        }
      } catch (_) {}

      // Get current fresh position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _moveToPosition(latlong.LatLng(position.latitude, position.longitude));
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
            child: gmaps.GoogleMap(
              initialCameraPosition: gmaps.CameraPosition(
                target: gmaps.LatLng(_currentPosition.latitude, _currentPosition.longitude),
                zoom: 15.0,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onCameraMove: (position) {
                setState(() {
                  _currentPosition = latlong.LatLng(position.target.latitude, position.target.longitude);
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          // Center pin indicator
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.0),
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
