import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, staging, prod }

class Environment {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static AppEnvironment get current {
    switch (_env.toLowerCase()) {
      case 'staging':
        return AppEnvironment.staging;
      case 'prod':
      case 'production':
        return AppEnvironment.prod;
      case 'dev':
      default:
        return AppEnvironment.dev;
    }
  }

  static bool get useEmulators {
    if (kIsWeb) {
      final host = Uri.base.host;
      return kDebugMode || 
             host == 'localhost' || 
             host == '127.0.0.1' || 
             host == '0.0.0.0' || 
             host.startsWith('192.168.') || 
             host.startsWith('10.');
    }
    return kDebugMode;
  }

  static String get emulatorHost {
    // 10.0.2.2 is only for Android emulators.
    // Desktop and web should use localhost.
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host == 'localhost') {
        return '127.0.0.1';
      }
      return host;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return '10.0.2.2';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return '127.0.0.1';
    }
  }
}
