// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/env/firebase_options.dart';

void main() {
  test('Query super admin businesses from emulator', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ExampleConnector.instance.dataConnect.useDataConnectEmulator('127.0.0.1', 9399);

    try {
      print('Executing query...');
      final response = await ExampleConnector.instance.superAdminGetBusinesses().execute();
      print('BUSINESS COUNT: ${response.data.businesses.length}');
      for (var b in response.data.businesses) {
        print('BUSINESS: ${b.id} - ${b.nombre}');
        for (var s in b.services_on_business) {
          print('  SERVICE: ${s.id} - ${s.nombre} (P: ${s.precioPequeno}, Pendiente: ${s.precioPendiente}, Activo: ${s.activo})');
        }
      }
    } catch (e, stackTrace) {
      print('Error querying businesses: $e');
      print('Stack trace: $stackTrace');
    }
  });
}
