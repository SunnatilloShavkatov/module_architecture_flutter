import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';

abstract interface class HomeRepo {
  const HomeRepo();

  ResultFuture<List<HomeCategoryEntity>> getCategories();

  ResultFuture<List<HomeBusinessEntity>> getBusinesses();

  ResultFuture<List<HomeAppointmentEntity>> getMyAppointments();
}
