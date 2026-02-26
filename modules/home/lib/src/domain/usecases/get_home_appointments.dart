import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/repository/home_repo.dart';

final class GetHomeAppointments extends UsecaseWithoutParams<List<HomeAppointmentEntity>> {
  const GetHomeAppointments(this._repo);

  final HomeRepo _repo;

  @override
  ResultFuture<List<HomeAppointmentEntity>> call() => _repo.getMyAppointments();
}
