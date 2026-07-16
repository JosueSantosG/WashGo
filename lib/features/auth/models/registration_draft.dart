import 'package:washgo/dataconnect-generated/example.dart';

class RegistrationDraft {
  static String name = '';
  static String email = '';
  static String password = '';
  static UserRole? role;

  static void clear() {
    name = '';
    email = '';
    password = '';
    role = null;
  }
}
