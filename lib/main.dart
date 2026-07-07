import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:washgo/app/app.dart';
import 'package:washgo/config/env/environment.dart';
import 'package:washgo/config/env/firebase_options.dart';
import 'package:washgo/dataconnect-generated/example.dart';

export 'package:washgo/app/app.dart' show WashGoApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Crashlytics
  try {
    // Disable Crashlytics collection in debug mode or when running with local emulators
    final enableCrashlytics = !kDebugMode && !Environment.useEmulators;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enableCrashlytics);
    debugPrint('Firebase Crashlytics collection enabled: $enableCrashlytics');

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e, stack) {
    debugPrint('Error configuring Firebase Crashlytics: $e\n$stack');
  }

  // Configurar para usar el emulador local de Data Connect y Storage/Auth
  if (Environment.useEmulators) {
    final host = Environment.emulatorHost;
    debugPrint('Configuring local emulators on host: $host');

    try {
      FirebaseAuth.instance.useAuthEmulator(host, 9099);
      debugPrint('Auth emulator configured on $host:9099');
    } catch (e, stack) {
      debugPrint('Error configurando emulador de Auth: $e\n$stack');
    }

    try {
      FirebaseStorage.instance.useStorageEmulator(host, 9199);
      debugPrint('Storage emulator configured on $host:9199');
    } catch (e, stack) {
      debugPrint('Error configurando emulador de Storage: $e\n$stack');
    }

    try {
      ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, 9399);
      debugPrint('Data Connect emulator configured on $host:9399');
    } catch (e, stack) {
      debugPrint('Error configurando emulador de Data Connect: $e\n$stack');
    }
  } else {
    debugPrint('Emulators are NOT enabled. Running in production mode.');
  }

  runApp(const WashGoApp());
}

