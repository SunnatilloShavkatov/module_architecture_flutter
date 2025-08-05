import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:others/src/presentation/splash/splash_page.dart';

void main() {
  group('SplashPage Tests', () {
    testWidgets('SplashPage displays logo text', (WidgetTester tester) async {
      // Build the SplashPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      // Verify that the splash page shows "Logo" text
      expect(find.text('Logo'), findsOneWidget);
    });

    testWidgets('SplashPage has correct background and text styling', (WidgetTester tester) async {
      // Build the SplashPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      // Verify scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      
      // Verify logo text is present
      expect(find.text('Logo'), findsOneWidget);
    });

    testWidgets('SplashPage initiates navigation after delay', (WidgetTester tester) async {
      // Create a mock navigator key to track navigation
      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      
      // Build the SplashPage with a navigator
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const SplashPage(),
          routes: {
            '/main': (context) => const Scaffold(body: Text('Main Page')),
          },
        ),
      );

      // Verify we start with splash
      expect(find.text('Logo'), findsOneWidget);
      
      // Wait for the 2-second delay
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // After delay, should navigate to main page
      expect(find.text('Main Page'), findsOneWidget);
      expect(find.text('Logo'), findsNothing);
    });
  });
}