// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Test GoRouter matching behavior for custom schemes', (WidgetTester tester) async {
    String? matchedRoute;
    String? matchedToken;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
        ),
        GoRoute(
          path: '/paypal-callback/success',
          builder: (context, state) {
            matchedRoute = '/paypal-callback/success';
            matchedToken = state.uri.queryParameters['token'];
            return const Text('Long Path');
          },
        ),
        GoRoute(
          path: '/success',
          builder: (context, state) {
            matchedRoute = '/success';
            matchedToken = state.uri.queryParameters['token'];
            return const Text('Short Path');
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    // Simulate GoRouter parsing the deep link
    router.go('washgo://paypal-callback/success?token=EC-12345&PayerID=98765');
    await tester.pumpAndSettle();

    print('--- MATCH RESULT ---');
    print('Matched Route: $matchedRoute');
    print('Matched Token: $matchedToken');
    print('--------------------');
  });
}
