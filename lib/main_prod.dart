import 'package:merge_dependencies/merge_dependencies.dart';
import 'package:module_architecture_mobile/app/main_common.dart';
import 'package:module_architecture_mobile/config/firebase_options_prod.dart';

Future<void> main() => mainCommon(env: Environment.prod, options: DefaultFirebaseOptions.currentPlatform);

///  apk
///  flutter build apk --flavor prod -t lib/main_prod.dart --release --split-debug-info=build/symbols
///
///  aab
///  flutter build appbundle --flavor prod -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/symbols
