import 'package:core/core.dart';
import 'package:payments/src/data/datasource/payments_remote_data_source.dart';
import 'package:payments/src/data/repository/payments_repository_impl.dart';
import 'package:payments/src/domain/repository/payments_repository.dart';
import 'package:payments/src/domain/usecases/add_payment_method.dart';
import 'package:payments/src/domain/usecases/delete_payment_method.dart';
import 'package:payments/src/domain/usecases/get_payment_methods.dart';
import 'package:payments/src/presentation/payment_methods/bloc/payment_methods_bloc.dart';

final class PaymentsInjection implements Injection {
  const PaymentsInjection();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<PaymentsRemoteDataSource>(() => PaymentsRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<PaymentsRepository>(() => PaymentsRepositoryImpl(di.get()))
      /// usecases
      ..registerLazySingleton(() => GetPaymentMethods(di.get()))
      ..registerLazySingleton(() => AddPaymentMethod(di.get()))
      ..registerLazySingleton(() => DeletePaymentMethod(di.get()))
      /// bloc
      ..registerFactory(() => PaymentMethodsBloc(di.get(), di.get(), di.get()));
  }
}
