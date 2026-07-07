import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'environment.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    final env = Environment.current;
    if (kIsWeb) {
      return _webOptions(env);
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidOptions(env);
      case TargetPlatform.iOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for ios');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macos');
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for windows');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static FirebaseOptions _webOptions(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDlTXwhFVAxcmhb8qZzQar9xpSTQjVHya8',
          appId: '1:822631956035:web:fd4b9b4bd52483e1175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392-dev',
          authDomain: 'washgo-app-8392-dev.firebaseapp.com',
          storageBucket: 'washgo-app-8392-dev.firebasestorage.app',
        );
      case AppEnvironment.staging:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDlTXwhFVAxcmhb8qZzQar9xpSTQjVHya8',
          appId: '1:822631956035:web:fd4b9b4bd52483e1175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392-staging',
          authDomain: 'washgo-app-8392-staging.firebaseapp.com',
          storageBucket: 'washgo-app-8392-staging.firebasestorage.app',
        );
      case AppEnvironment.prod:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDlTXwhFVAxcmhb8qZzQar9xpSTQjVHya8',
          appId: '1:822631956035:web:fd4b9b4bd52483e1175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392',
          authDomain: 'washgo-app-8392.firebaseapp.com',
          storageBucket: 'washgo-app-8392.firebasestorage.app',
        );
    }
  }

  static FirebaseOptions _androidOptions(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDe5Dp2SL_7_04UOCEpxF8wWrroZptsRjs',
          appId: '1:822631956035:android:d63160c51c8dc202175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392-dev',
          storageBucket: 'washgo-app-8392-dev.firebasestorage.app',
        );
      case AppEnvironment.staging:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDe5Dp2SL_7_04UOCEpxF8wWrroZptsRjs',
          appId: '1:822631956035:android:d63160c51c8dc202175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392-staging',
          storageBucket: 'washgo-app-8392-staging.firebasestorage.app',
        );
      case AppEnvironment.prod:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDe5Dp2SL_7_04UOCEpxF8wWrroZptsRjs',
          appId: '1:822631956035:android:d63160c51c8dc202175ef6',
          messagingSenderId: '822631956035',
          projectId: 'washgo-app-8392',
          storageBucket: 'washgo-app-8392.firebasestorage.app',
        );
    }
  }
}
