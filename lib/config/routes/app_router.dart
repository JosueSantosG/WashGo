import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/core/session/session_manager.dart';

import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/config/routes/route_guards.dart';
import 'package:washgo/features/auth/pages/active_role_selection_page.dart';
import 'package:washgo/features/auth/pages/auth_gate_page.dart';
import 'package:washgo/features/auth/pages/client_onboarding_page.dart';
import 'package:washgo/features/auth/pages/employee_code_page.dart';
import 'package:washgo/features/auth/pages/employee_onboarding_page.dart';
import 'package:washgo/features/auth/pages/login_page.dart';
import 'package:washgo/features/auth/pages/register_page.dart';
import 'package:washgo/features/auth/pages/role_selection_page.dart';
import 'package:washgo/features/auth/pages/role_detail_page.dart';
import 'package:washgo/features/dashboard/client/home_page.dart';
import 'package:washgo/features/dashboard/owner/owner_dashboard_page.dart';
import 'package:washgo/features/dashboard/owner/owner_invoice_detail_page.dart';
import 'package:washgo/features/invoices/models/invoice.dart';
import 'package:washgo/features/dashboard/employee/employee_dashboard_page.dart';
import 'package:washgo/features/laundries/pages/create_laundry_page.dart';
import 'package:washgo/features/maps/pages/map_picker_page.dart';
import 'package:washgo/features/auth/pages/super_admin_login_page.dart';
import 'package:washgo/features/dashboard/admin/super_admin_dashboard_page.dart';
import 'package:washgo/features/laundries/pages/prepaid_consumption_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:washgo/features/splash/pages/splash_page.dart';
import 'package:washgo/features/auth/pages/policy_viewer_page.dart';
import 'package:washgo/features/payments/pages/paypal_success_page.dart';
import 'package:washgo/features/payments/pages/paypal_cancel_page.dart';
import 'package:washgo/features/payments/pages/payphone_success_page.dart';
import 'package:washgo/features/payments/pages/payphone_cancel_page.dart';
import 'package:washgo/features/payments/pages/bank_transfer_instructions_page.dart';
import 'package:washgo/features/payments/pages/proof_upload_page.dart';
import 'package:washgo/features/payments/pages/proof_status_page.dart';
import 'package:washgo/features/payments/pages/admin_payment_review_page.dart';

// Converts FirebaseAuth state and real-time database user profile updates into a Listenable.
class AppRouterRefreshNotifier extends ChangeNotifier {
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QueryResult<GetCurrentUserData, void>>? _dbSubscription;
  bool _disposed = false;

  AppRouterRefreshNotifier() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _setupDbSubscription(user);
      if (!_disposed) notifyListeners();
    });
  }

  void _setupDbSubscription(User? user) {
    _dbSubscription?.cancel();
    _dbSubscription = null;

    if (user != null) {
      try {
        _dbSubscription = ExampleConnector.instance
            .getCurrentUser()
            .ref()
            .subscribe()
            .listen(
          (result) {
            SessionManager.currentUser = result.data.user;
            if (!_disposed) notifyListeners();
          },
          onError: (Object e) {
            debugPrint('Error subscribing to user updates: $e');
          },
        );
      } catch (e) {
        debugPrint('Error setting up DB subscription: $e');
      }
    } else {
      SessionManager.currentUser = null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _authSubscription?.cancel();
    _dbSubscription?.cancel();
    super.dispose();
  }
}

GoRouter? _cachedAppRouter;

GoRouter get appRouter {
  return _cachedAppRouter ??= _createAppRouter();
}

GoRouter _createAppRouter() {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(initialTab: 0),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const HomePage(initialTab: 0),
    ),
    GoRoute(
      path: '/reservas',
      builder: (context, state) => const HomePage(initialTab: 1),
    ),
    GoRoute(
      path: '/facturas',
      builder: (context, state) => const HomePage(initialTab: 2),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const HomePage(initialTab: 3),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.authGate,
      builder: (context, state) => const AuthGatePage(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: AppRoutes.roleDetail,
      builder: (context, state) {
        final roleStr = state.uri.queryParameters['role'] ?? 'CLIENTE';
        final role = UserRole.values.firstWhere(
          (e) => e.name == roleStr,
          orElse: () => UserRole.CLIENTE,
        );
        return RoleDetailPage(role: role);
      },
    ),
    GoRoute(
      path: AppRoutes.onboardingCliente,
      builder: (context, state) => const ClientOnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.onboardingEmployee,
      builder: (context, state) => const EmployeeOnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.employeeCode,
      builder: (context, state) => const EmployeeCodePage(),
    ),
    GoRoute(
      path: AppRoutes.ownerDashboard,
      builder: (context, state) => const OwnerDashboardPage(initialTab: 0),
    ),
    GoRoute(
      path: AppRoutes.employeeDashboard,
      builder: (context, state) => const EmployeeDashboardPage(),
    ),
    GoRoute(
      path: '/owner-dashboard/services',
      builder: (context, state) => const OwnerDashboardPage(initialTab: 1),
    ),
    GoRoute(
      path: '/owner-dashboard/employees',
      builder: (context, state) => const OwnerDashboardPage(initialTab: 2),
    ),
    GoRoute(
      path: '/owner-dashboard/billing',
      builder: (context, state) => const OwnerDashboardPage(initialTab: 3),
    ),
    GoRoute(
      path: '/owner-dashboard/reviews',
      builder: (context, state) => const OwnerDashboardPage(initialTab: 4),
    ),
    GoRoute(
      path: AppRoutes.ownerBillingDetail,
      builder: (context, state) {
        final invoice = state.extra as InvoiceModel;
        return OwnerInvoiceDetailPage(invoice: invoice);
      },
    ),
    GoRoute(
      path: '/owner-dashboard/config',
      builder: (context, state) => const OwnerDashboardPage(initialTab: 5),
    ),
    GoRoute(
      path: AppRoutes.createLaundry,
      builder: (context, state) => const CreateLaundryPage(),
    ),
    GoRoute(
      path: '/select-active-role',
      builder: (context, state) => const ActiveRoleSelectionPage(),
    ),
    GoRoute(
      path: AppRoutes.superAdminLogin,
      builder: (context, state) => const SuperAdminLoginPage(),
    ),
    GoRoute(
      path: AppRoutes.superAdminDashboard,
      builder: (context, state) => const SuperAdminDashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.prepaidConsumption,
      builder: (context, state) {
        final Map<String, dynamic> extras = (state.extra as Map?)?.cast<String, dynamic>() ?? {};
        return PrepaidConsumptionPage(
          businessId: (extras['businessId'] ?? '') as String,
          businessName: (extras['businessName'] ?? '') as String,
          saldoInicial: (extras['saldoInicial'] as num?)?.toDouble() ?? 0.0,
          saldoConsumido: (extras['saldoConsumido'] as num?)?.toDouble() ?? 0.0,
          saldoDisponible: (extras['saldoDisponible'] as num?)?.toDouble() ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.mapPicker,
      builder: (context, state) {
        final initialLocation = state.extra as LatLng?;
        return MapPickerPage(initialLocation: initialLocation);
      },
    ),
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) => const PolicyViewerPage(type: PolicyType.terms),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      builder: (context, state) => const PolicyViewerPage(type: PolicyType.privacy),
    ),
    GoRoute(
      path: AppRoutes.paypalSuccess,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        final payerId = state.uri.queryParameters['PayerID'];
        return PaypalSuccessPage(token: token, payerId: payerId);
      },
    ),
    GoRoute(
      path: AppRoutes.paypalSuccessScheme,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        final payerId = state.uri.queryParameters['PayerID'];
        return PaypalSuccessPage(token: token, payerId: payerId);
      },
    ),
    GoRoute(
      path: AppRoutes.paypalCancel,
      builder: (context, state) => const PaypalCancelPage(),
    ),
    GoRoute(
      path: AppRoutes.paypalCancelScheme,
      builder: (context, state) => const PaypalCancelPage(),
    ),
    GoRoute(
      path: AppRoutes.payphoneSuccess,
      builder: (context, state) {
        final transactionId = state.uri.queryParameters['transactionId'] ?? state.uri.queryParameters['id'];
        final orderId = state.uri.queryParameters['clientTransactionId'] ??
            state.uri.queryParameters['orderId'] ??
            state.uri.queryParameters['clientTxId'];
        return PayphoneSuccessPage(transactionId: transactionId, orderId: orderId);
      },
    ),
    GoRoute(
      path: AppRoutes.payphoneCancel,
      builder: (context, state) {
        final orderId = state.uri.queryParameters['clientTransactionId'] ??
            state.uri.queryParameters['orderId'] ??
            state.uri.queryParameters['clientTxId'];
        return PayphoneCancelPage(orderId: orderId);
      },
    ),
    GoRoute(
      name: AppRoutes.bankTransferInstructions,
      path: AppRoutes.bankTransferInstructions,
      builder: (context, state) {
        final args = (state.extra as Map<String, dynamic>?) ?? {};
        return BankTransferInstructionsPage(
          orderId: (args['orderId'] as String?) ?? '',
          amount: (args['amount'] as num?)?.toDouble() ?? 0.0,
          serviceName: (args['serviceName'] as String?) ?? '',
          businessName: (args['businessName'] as String?) ?? '',
          businessId: args['businessId'] as String?,
        );
      },
    ),
    GoRoute(
      name: AppRoutes.proofUpload,
      path: AppRoutes.proofUpload,
      builder: (context, state) {
        final args = (state.extra as Map<String, dynamic>?) ?? {};
        return ProofUploadPage(
          orderId: (args['orderId'] as String?) ?? '',
          amount: (args['amount'] as num?)?.toDouble() ?? 0.0,
          serviceName: (args['serviceName'] as String?) ?? '',
          businessName: (args['businessName'] as String?) ?? '',
        );
      },
    ),
    GoRoute(
      name: AppRoutes.proofStatus,
      path: AppRoutes.proofStatus,
      builder: (context, state) {
        final args = (state.extra as Map<String, dynamic>?) ?? {};
        return ProofStatusPage(
          orderId: (args['orderId'] as String?) ?? '',
          proofStatus: (args['proofStatus'] as String?) ?? 'PENDING',
          amount: (args['amount'] as num?)?.toDouble() ?? 0.0,
          serviceName: (args['serviceName'] as String?) ?? '',
          businessName: (args['businessName'] as String?) ?? '',
        );
      },
    ),
    GoRoute(
      name: AppRoutes.adminPaymentReview,
      path: AppRoutes.adminPaymentReview,
      builder: (context, state) {
        return const AdminPaymentReviewPage();
      },
    ),
  ];

  if (Firebase.apps.isEmpty) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      routes: routes,
      redirect: (context, state) {
        if (state.matchedLocation == AppRoutes.splash) {
          return null;
        }
        if (state.matchedLocation == AppRoutes.authGate) {
          return AppRoutes.login;
        }
        return null;
      },
    );
  }

  final refreshNotifier = AppRouterRefreshNotifier();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: authRedirect,
    routes: routes,
  );
}
