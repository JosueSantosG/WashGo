import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class SuperAdminSession {
  static bool get isLoggedIn {
    return FirebaseAuth.instance.currentUser != null &&
        SessionManager.activeRole == UserRole.SUPER_ADMIN;
  }
  
  static void logout() {
    SessionManager.activeRole = null;
    FirebaseAuth.instance.signOut();
  }
}
