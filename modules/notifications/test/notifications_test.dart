import 'package:flutter_test/flutter_test.dart';

import 'src/data/datasource/notifications_remote_data_source_test.dart' as remote_data_source_test;
import 'src/data/models/notification_model_test.dart' as model_test;
import 'src/data/repository/notifications_repository_impl_test.dart' as repository_test;
import 'src/di/notifications_injection_test.dart' as injection_test;
import 'src/domain/interactor/get_unread_notifications_count_interactor_test.dart' as interactor_test;
import 'src/domain/usecases/get_notifications_test.dart' as usecase_test;
import 'src/notifications_container_test.dart' as container_test;
import 'src/presentation/notifications/bloc/notifications_bloc_test.dart' as bloc_test;
import 'src/router/notifications_router_test.dart' as router_test;

void main() {
  group('Notifications Module Tests', () {
    container_test.main();
    injection_test.main();
    router_test.main();
    remote_data_source_test.main();
    model_test.main();
    repository_test.main();
    usecase_test.main();
    interactor_test.main();
    bloc_test.main();
  });
}
