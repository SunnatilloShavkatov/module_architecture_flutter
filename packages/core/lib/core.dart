import 'package:base_dependencies/base_dependencies.dart';

import 'src/connectivity/network_info.dart';
import 'src/di/app_injector.dart';
import 'src/local_source/local_source.dart';

export 'src/constants/constants.dart';
export 'src/constants/env.dart';
export 'src/core_abstractions/app_router.dart';
export 'src/core_abstractions/injection.dart';
export 'src/core_abstractions/injector.dart';
export 'src/core_abstractions/module_container.dart';
export 'src/core_container.dart';
export 'src/di/app_injector.dart';
export 'src/di/core_injection.dart';
export 'src/extension/extension.dart';
export 'src/icons/app_icons.dart';
export 'src/l10n/app_localizations.dart';
export 'src/local_source/local_source.dart';
export 'src/native_splash/flutter_native_splash.dart';
export 'src/options/app_options.dart';
export 'src/services/base_listener_types.dart';
export 'src/services/notification_service.dart';
export 'src/theme/themes.dart';
export 'src/utils/utils.dart';

/// internet connection
NetworkInfo get networkInfo => AppInjector.instance.get<NetworkInfo>();

Connectivity get connectivity => AppInjector.instance.get<Connectivity>();

PackageInfo get packageInfo => AppInjector.instance.get<PackageInfo>();

LocalSource get localSource => AppInjector.instance.get<LocalSource>();
