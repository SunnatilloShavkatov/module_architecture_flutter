// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:platform_methods/platform_methods.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isPhysicalDevice test', (WidgetTester tester) async {
    final PlatformMethods plugin = PlatformMethods.instance;
    final bool version = await plugin.isEmulator();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version, true);
  });
}
