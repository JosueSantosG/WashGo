// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/env/firebase_options.dart';

void main() {
  test('Query vehicle brands from emulator', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ExampleConnector.instance.dataConnect.useDataConnectEmulator('127.0.0.1', 9399);

    try {
      final brands = await ExampleConnector.instance.getVehicleBrands().execute();
      print('BRANDS COUNT: ${brands.data.vehicleBrands.length}');
      for (var b in brands.data.vehicleBrands) {
        print('BRAND: ${b.id} - ${b.name}');
      }
    } catch (e) {
      print('Error querying brands: $e');
    }
  });
}
