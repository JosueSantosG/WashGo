import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';

abstract class VehicleRepository {
  Future<List<VehicleItem>> getMyVehicles();
  Future<List<Map<String, String>>> getVehicleBrands();
  Future<List<Map<String, dynamic>>> getVehicleModelsByBrand(String brandId);
  Future<void> addVehicle({
    required String modelId,
    String? plate,
  });
  Future<void> updateVehicle({
    required String id,
    required String modelId,
    String? plate,
  });
  Future<void> deleteVehicle(String id);
}
