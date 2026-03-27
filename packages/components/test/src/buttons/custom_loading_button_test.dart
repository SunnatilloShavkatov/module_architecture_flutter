import 'package:components/src/buttons/custom_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomLoadingButton', () {
    testWidgets('shows child and no loader when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomLoadingButton(
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loader and no child when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomLoadingButton(
              isLoading: true,
              child: Text('Submit'),
            ),
          ),
        ),
      );

      // child text should not be visible when loading
      expect(find.text('Submit'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('triggers onPressed when tapped and not loading', (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomLoadingButton(
              onPressed: () => tapCount++,
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      // CustomLoadingButton uses rxdart throttleTime (1 second).
      // We need to pump to allow the stream listener to fire.
      await tester.pump();

      expect(tapCount, 1);
    });

    testWidgets('throttles multiple taps within 1 second', (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomLoadingButton(
              onPressed: () => tapCount++,
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      // Multiple taps
      await tester.tap(find.text('Submit'));
      await tester.pump(); // fires first
      await tester.tap(find.text('Submit'));
      await tester.pump(); // throttled
      await tester.tap(find.text('Submit'));
      await tester.pump(); // throttled

      expect(tapCount, 1);
    });

    testWidgets('does not trigger onPressed when loading', (WidgetTester tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomLoadingButton(
              onPressed: () => tapCount++,
              isLoading: true,
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      // At this point child text is not visible, so we find by type or loader
      final button = find.byType(CustomLoadingButton);
      await tester.tap(button);
      await tester.pump();

      expect(tapCount, 0);
    });
  });
}
