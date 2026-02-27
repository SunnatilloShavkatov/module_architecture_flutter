import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app/main_common.dart';
import 'package:module_architecture_mobile/config/firebase_options_dev.dart';

Future<void> main() => mainCommon(env: Environment.dev, options: DefaultFirebaseOptions.currentPlatform);

///  apk
///  flutter build apk --flavor dev -t lib/main_dev.dart --release --split-debug-info=build/symbols
///
///  aab
///  flutter build appbundle --flavor dev -t lib/main_dev.dart --release --obfuscate --split-debug-info=build/symbols
