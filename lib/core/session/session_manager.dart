import 'package:flutter/foundation.dart';
import 'package:washgo/dataconnect-generated/example.dart';

/// Gestiona el estado reactivo de sesión del usuario en la aplicación.
class SessionManager extends ChangeNotifier {
  static final SessionManager instance = SessionManager._internal();
  factory SessionManager() => instance;
  SessionManager._internal();

  static UserRole? _activeRole;
  static GetCurrentUserUser? _currentUser;

  static UserRole? get activeRole => _activeRole;
  static set activeRole(UserRole? role) {
    if (_activeRole != role) {
      _activeRole = role;
      instance.notifyListeners();
    }
  }

  static GetCurrentUserUser? get currentUser => _currentUser;
  static set currentUser(GetCurrentUserUser? user) {
    if (_currentUser != user) {
      _currentUser = user;
      instance.notifyListeners();
    }
  }

  void clearSession() {
    _activeRole = null;
    _currentUser = null;
    notifyListeners();
  }
}
