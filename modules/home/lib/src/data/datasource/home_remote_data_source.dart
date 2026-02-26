import 'package:core/core.dart';
import 'package:home/src/data/datasource/home_api_paths.dart';
import 'package:home/src/data/models/home_appointment_model.dart';
import 'package:home/src/data/models/home_business_model.dart';
import 'package:home/src/data/models/home_category_model.dart';

part 'home_remote_data_source_impl.dart';

abstract interface class HomeRemoteDataSource {
  const HomeRemoteDataSource();

  Future<List<HomeCategoryModel>> getCategories();

  Future<List<HomeBusinessModel>> getBusinesses();

  Future<List<HomeAppointmentModel>> getMyAppointments();
}
