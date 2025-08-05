import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main/src/presentation/main/main_page.dart';

void main() {
  group('MainPage Tests', () {
    testWidgets('MainPage displays bottom navigation bar', (WidgetTester tester) async {
      // Build the MainPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Verify main page structure
      expect(find.byKey(const Key('main')), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byKey(const Key('custom_navigation_bar')), findsOneWidget);
    });

    testWidgets('MainPage has 4 navigation tabs', (WidgetTester tester) async {
      // Build the MainPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Verify 4 bottom navigation items
      expect(find.byType(BottomNavigationBarItem), findsNWidgets(4));
      
      // Verify navigation icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.route), findsOneWidget);
      expect(find.byIcon(Icons.book_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('MainPage shows home tab content by default', (WidgetTester tester) async {
      // Build the MainPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Verify main stack and home tab are present
      expect(find.byKey(const Key('main_stack')), findsOneWidget);
      expect(find.byKey(const Key('offstage_home')), findsOneWidget);
      
      // Verify home tab shows list content
      expect(find.byType(IndexedStack), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('MainPage displays numbered list items in home tab', (WidgetTester tester) async {
      // Build the MainPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Pump and settle to ensure all widgets are built
      await tester.pumpAndSettle();

      // Verify list items with numbers are present
      expect(find.text('0'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('MainPage tab navigation works', (WidgetTester tester) async {
      // Build the MainPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Initially on home tab (index 0)
      expect(find.byKey(const Key('offstage_home')), findsOneWidget);

      // Tap on settings tab (index 1)
      await tester.tap(find.byIcon(Icons.route));
      await tester.pumpAndSettle();

      // Verify settings tab content appears
      expect(find.byKey(const Key('offstage_settings')), findsOneWidget);
      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('PlaceholderScreen displays correct text', (WidgetTester tester) async {
      const testText = 'Test Screen';
      
      // Build a PlaceholderScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: PlaceholderScreen(text: testText),
        ),
      );

      // Verify the placeholder shows the correct text
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });
  });
}