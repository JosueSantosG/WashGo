// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:washgo/main.dart';

void main() {
  testWidgets('App builds, shows Splash Screen, and then routes to Login Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WashGoApp());

    // Verify that the brand name 'WashGo' and slogan appear on the splash screen.
    expect(find.text('WashGo'), findsWidgets);
    expect(find.text('Tu lavado de autos a un clic'), findsOneWidget);

    // Verify that the login page 'Iniciar Sesión' is not yet present
    expect(find.text('Iniciar Sesión'), findsNothing);

    // Let the splash screen animation complete and trigger navigation (2.5 seconds duration)
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verify that it has navigated to the Login Page
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
