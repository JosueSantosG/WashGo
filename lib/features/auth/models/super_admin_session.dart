class SuperAdminSession {
  static bool isLoggedIn = false;
  
  static void logout() {
    isLoggedIn = false;
  }
}
