import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/auth/models/super_admin_session.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/dataconnect-generated/example.dart';

String? authRedirect(BuildContext context, GoRouterState state) {
  if (state.matchedLocation == AppRoutes.splash) {
    return null;
  }

  final bool isSuperAdminRoute = state.matchedLocation.startsWith('/superadmin') || state.matchedLocation == AppRoutes.adminPaymentReview;
  if (isSuperAdminRoute) {
    if ((state.matchedLocation == AppRoutes.superAdminDashboard || state.matchedLocation == AppRoutes.adminPaymentReview) && !SuperAdminSession.isLoggedIn) {
      return AppRoutes.superAdminLogin;
    }
    return null;
  }

  // Allow super admin to view prepaid consumption
  if (state.matchedLocation == AppRoutes.prepaidConsumption && SuperAdminSession.isLoggedIn) {
    return null;
  }

  final authUser = FirebaseAuth.instance.currentUser;
  final bool isLoggedIn = authUser != null;
  final bool isLoggingIn =
      state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register;

  final bool isPublicRoute = state.matchedLocation == AppRoutes.home ||
      state.matchedLocation == '/explore' ||
      state.matchedLocation == '/reservas' ||
      state.matchedLocation == '/facturas' ||
      state.matchedLocation == '/perfil' ||
      state.matchedLocation == AppRoutes.terms ||
      state.matchedLocation == AppRoutes.privacy ||
      state.matchedLocation == AppRoutes.paypalSuccess ||
      state.matchedLocation == AppRoutes.paypalCancel ||
      state.matchedLocation == AppRoutes.paypalSuccessScheme ||
      state.matchedLocation == AppRoutes.paypalCancelScheme;

  if (isPublicRoute) {
    return null;
  }

  if (!isLoggedIn && !isLoggingIn) {
    return AppRoutes.login;
  }

  if (isLoggedIn && isLoggingIn) {
    return AppRoutes.authGate;
  }

  if (isLoggedIn) {
    final user = SessionManager.currentUser;
    final activeRole = SessionManager.activeRole;
    if (user != null && activeRole != null) {
      // Check if user still has the activeRole
      final roles = user.roles
          .map((e) => e is Known<UserRole> ? e.value : null)
          .whereType<UserRole>()
          .toList();
      if (!roles.contains(activeRole)) {
        SessionManager.activeRole = null;
        return AppRoutes.authGate;
      }

      // If active role is employee, check their status
      if (activeRole == UserRole.EMPLEADO) {
        final status = user.employeeStatus is Known<EmployeeStatus>
            ? (user.employeeStatus as Known<EmployeeStatus>).value
            : EmployeeStatus.UNASSIGNED;

        final isEmployeeDashboard = state.matchedLocation == AppRoutes.employeeDashboard;
        if (isEmployeeDashboard &&
            (status == EmployeeStatus.REJECTED || status == EmployeeStatus.UNASSIGNED)) {
          return AppRoutes.authGate;
        }
      }
    }
  }

  return null;
}
