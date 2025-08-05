import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:module_architecture_flutter/app.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the splash screen shows Logo text
    expect(find.text('Logo'), findsOneWidget);
    
    // Verify that the app has the correct initial structure
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App navigates from splash to main after delay', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify we start on splash
    expect(find.text('Logo'), findsOneWidget);
    
    // Wait for splash delay (2 seconds) and pump frames
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify navigation to main page occurred
    // Check for bottom navigation which is part of main page
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Main page has bottom navigation with 4 tabs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Wait for navigation to main page
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify bottom navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify 4 navigation items
    expect(find.byType(BottomNavigationBarItem), findsNWidgets(4));
    
    // Verify main page content structure
    expect(find.byKey(const Key('main')), findsOneWidget);
    expect(find.byKey(const Key('main_stack')), findsOneWidget);
  });

  testWidgets('Home tab shows list with numbered items', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Wait for navigation to main page
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify we're on home tab by default and can see list items
    expect(find.byKey(const Key('offstage_home')), findsOneWidget);
    
    // Check that list items are present (should show numbers 0-99)
    expect(find.text('0'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
  });
}
