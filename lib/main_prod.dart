import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app/main_common.dart';
import 'package:module_architecture_mobile/config/firebase_options_prod.dart';

Future<void> main() => mainCommon(env: Environment.prod, options: DefaultFirebaseOptions.currentPlatform);

///  run
///  flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=.enc.prod.json
///
///  apk
///  flutter build apk --flavor prod -t lib/main_prod.dart --release --dart-define-from-file=.enc.prod.json --split-debug-info=build/symbols
///
///  aab
///  flutter build appbundle --flavor prod -t lib/main_prod.dart --release --dart-define-from-file=.enc.prod.json --obfuscate --split-debug-info=build/symbols
///
///  ipa
///  flutter build ipa --flavor prod -t lib/main_prod.dart --release --dart-define-from-file=.enc.prod.json --obfuscate --split-debug-info=build/symbols
