import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/repository/home_repository.dart';

class GetHomeAppointments extends UsecaseWithoutParams<List<HomeAppointmentEntity>> {
  const new(this._repo);

  final HomeRepository _repo;

  @override
  ResultFuture<List<HomeAppointmentEntity>> call() => _repo.getMyAppointments();
}
