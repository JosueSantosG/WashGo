import 'package:flutter/material.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';
import 'vehicle_repository.dart';

class FirebaseVehicleRepository implements VehicleRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  String _normalizeCategory(String? raw) {
    if (raw == null) return 'Pequeño';
    final lower = raw.toLowerCase().trim();
    if (lower.contains('moto')) return 'Moto';
    if (lower.contains('hatchback') || lower.contains('pequeñ') || lower.contains('pequen')) return 'Pequeño';
    if (lower.contains('suv') || lower.contains('grand')) return 'Grande';
    if (lower.contains('median') || lower.contains('sedan') || lower.contains('crossover')) return 'Mediano';
    return 'Pequeño';
  }

  @override
  Future<List<VehicleItem>> getMyVehicles() async {
    final response = await _connector.getMyVehicles().execute();
    final List<VehicleItem> vehicles = [];

    for (final v in response.data.vehicles) {
      final rawCategory = (v.category != null && v.category!.isNotEmpty) ? v.category! : v.model.category;
      final category = _normalizeCategory(rawCategory);
      IconData ic = Icons.directions_car_filled_rounded;
      if (category == 'Grande') {
        ic = Icons.airport_shuttle_rounded;
      } else if (category == 'Moto') {
        ic = Icons.motorcycle_rounded;
      } else if (category == 'Mediano') {
        ic = Icons.directions_car_rounded;
      }

      vehicles.add(
        VehicleItem(
          id: v.id,
          plate: v.plate ?? '',
          brandModel: '${v.model.brand.name} ${v.model.name}',
          type: category,
          icon: ic,
          modelId: v.model.id,
          brandId: v.model.brand.id,
        ),
      );
    }
    return vehicles;
  }

  @override
  Future<List<Map<String, String>>> getVehicleBrands() async {
    final response = await _connector.getVehicleBrands().execute();
    return response.data.vehicleBrands.map((b) => {
      'id': b.id,
      'name': b.name,
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getVehicleModelsByBrand(String brandId) async {
    final response = await _connector.getVehicleModelsByBrand(brandId: brandId).execute();
    return response.data.vehicleModels.map((m) => {
      'id': m.id,
      'name': m.name,
      'category': m.category,
    }).toList();
  }

  @override
  Future<void> addVehicle({
    required String modelId,
    String? plate,
    String? category,
  }) async {
    await _connector
        .addVehicle(modelId: modelId)
        .plate(plate)
        .category(category)
        .execute();
  }

  @override
  Future<void> updateVehicle({
    required String id,
    required String modelId,
    String? plate,
    String? category,
  }) async {
    await _connector
        .updateVehicle(id: id, modelId: modelId)
        .plate(plate)
        .category(category)
        .execute();
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await _connector.deleteVehicle(id: id).execute();
  }
}
