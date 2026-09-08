import 'package:flutter_test/flutter_test.dart';

import 'src/buttons/custom_loading_button_test.dart' as custom_loading_button_test;
import 'src/gap/gap_test.dart' as gap_test;

void main() {
  group('Components Package Tests', () {
    custom_loading_button_test.main();
    gap_test.main();
  });
}
