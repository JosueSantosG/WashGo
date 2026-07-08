import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:washgo/features/dashboard/client/widgets/vehicles/vehicle_dialogs.dart';
import 'package:washgo/features/profile/repositories/vehicle_repository.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';

class MockVehicleRepository implements VehicleRepository {
  List<VehicleItem> vehicles = [];
  List<Map<String, String>> brands = [
    {'id': 'brand_1', 'name': 'Toyota'},
    {'id': 'brand_2', 'name': 'Yamaha'},
  ];
  Map<String, List<Map<String, dynamic>>> models = {
    'brand_1': [
      {'id': 'model_small', 'name': 'Yaris', 'category': 'Pequeño'},
      {'id': 'model_medium', 'name': 'Corolla', 'category': 'Mediano'},
      {'id': 'model_large', 'name': 'RAV4', 'category': 'Grande'},
    ],
    'brand_2': [
      {'id': 'model_moto', 'name': 'FZ', 'category': 'Moto'},
    ],
  };

  bool addVehicleCalled = false;
  String? addedModelId;
  String? addedPlate;
  String? addedCategory;

  bool updateVehicleCalled = false;
  String? updatedId;
  String? updatedModelId;
  String? updatedPlate;
  String? updatedCategory;

  @override
  Future<List<VehicleItem>> getMyVehicles() async => vehicles;

  @override
  Future<List<Map<String, String>>> getVehicleBrands() async => brands;

  @override
  Future<List<Map<String, dynamic>>> getVehicleModelsByBrand(String brandId) async {
    return models[brandId] ?? [];
  }

  @override
  Future<void> addVehicle({
    required String modelId,
    String? plate,
    String? category,
  }) async {
    addVehicleCalled = true;
    addedModelId = modelId;
    addedPlate = plate;
    addedCategory = category;
  }

  @override
  Future<void> updateVehicle({
    required String id,
    required String modelId,
    String? plate,
    String? category,
  }) async {
    updateVehicleCalled = true;
    updatedId = id;
    updatedModelId = modelId;
    updatedPlate = plate;
    updatedCategory = category;
  }

  @override
  Future<void> deleteVehicle(String id) async {}
}

void main() {
  late MockVehicleRepository mockRepo;

  setUp(() {
    mockRepo = MockVehicleRepository();
  });

  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('AddVehicleDialog loads category mapping and saves with resolved model ID', (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        AddVehicleDialog(
          vehicleRepository: mockRepo,
          onVehicleChanged: () {},
        ),
      ),
    );

    // Verify initial loading state
    expect(find.text('Cargando categorías...'), findsOneWidget);

    // Let the Future.wait finish and pump
    await tester.pumpAndSettle();

    // Verify loading has finished
    expect(find.text('Cargando categorías...'), findsNothing);

    // Verify category options are visible
    expect(find.text('Moto'), findsWidgets); // Both in title and in list card
    expect(find.text('Pequeño'), findsWidgets);
    expect(find.text('Mediano'), findsWidgets);
    expect(find.text('Grande'), findsWidgets);

    // Enter plate number
    final plateField = find.byType(TextField);
    expect(plateField, findsOneWidget);
    await tester.enterText(plateField, 'ABC-1234');

    // Tap on the 'Moto' category card
    // The text on the card is 'Moto'
    final motoCardText = find.text('Motocicleta, Scooter, Motoneta');
    expect(motoCardText, findsOneWidget);
    await tester.ensureVisible(motoCardText);
    await tester.tap(motoCardText);
    await tester.pumpAndSettle();

    // Tap on the 'Guardar' button
    final saveButton = find.text('Guardar');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify mock repo was called with Moto category details
    expect(mockRepo.addVehicleCalled, isTrue);
    expect(mockRepo.addedModelId, equals('model_moto'));
    expect(mockRepo.addedPlate, equals('ABC-1234'));
    expect(mockRepo.addedCategory, equals('Moto'));
  });

  testWidgets('EditVehicleDialog shows current state and saves update correctly', (WidgetTester tester) async {
    const existingVehicle = VehicleItem(
      id: 'veh_99',
      plate: 'XYZ-9876',
      brandModel: 'Toyota Corolla',
      type: 'Mediano',
      icon: Icons.directions_car_rounded,
      modelId: 'model_medium',
      brandId: 'brand_1',
    );

    await tester.pumpWidget(
      createWidgetUnderTest(
        EditVehicleDialog(
          vehicleRepository: mockRepo,
          vehicle: existingVehicle,
          onVehicleChanged: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify plate input is prepopulated
    final plateField = find.byType(TextField);
    expect(find.text('XYZ-9876'), findsOneWidget);

    // Change category to 'Grande'
    final grandeCardText = find.text('SUV grande, Pick-up / Camioneta, Minivan / Van');
    expect(grandeCardText, findsOneWidget);
    await tester.ensureVisible(grandeCardText);
    await tester.tap(grandeCardText);
    await tester.pumpAndSettle();

    // Change plate text
    await tester.enterText(plateField, 'NEW-4567');

    // Save
    final saveButton = find.text('Guardar');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify repo update is called
    expect(mockRepo.updateVehicleCalled, isTrue);
    expect(mockRepo.updatedId, equals('veh_99'));
    expect(mockRepo.updatedModelId, equals('model_large')); // RAV4 model ID is model_large
    expect(mockRepo.updatedPlate, equals('NEW-4567'));
    expect(mockRepo.updatedCategory, equals('Grande'));
  });
}
