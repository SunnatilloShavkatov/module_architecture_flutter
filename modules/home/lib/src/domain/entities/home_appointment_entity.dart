import 'package:core/core.dart' show Equatable;

class HomeAppointmentEntity extends Equatable {
  const HomeAppointmentEntity({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.staffId,
    required this.services,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    this.business,
    this.staff,
  });

  final int id;
  final int userId;
  final int businessId;
  final int staffId;
  final List<HomeAppointmentServiceEntity> services;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final double totalPrice;
  final HomeAppointmentBusinessEntity? business;
  final HomeAppointmentStaffEntity? staff;

  @override
  List<Object?> get props => [
    id,
    userId,
    businessId,
    staffId,
    services,
    startTime,
    endTime,
    status,
    totalPrice,
    business,
    staff,
  ];
}

class HomeAppointmentServiceEntity extends Equatable {
  const HomeAppointmentServiceEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMin,
  });

  final int id;
  final String name;
  final double price;
  final int durationMin;

  @override
  List<Object?> get props => [id, name, price, durationMin];
}

class HomeAppointmentBusinessEntity extends Equatable {
  const HomeAppointmentBusinessEntity({required this.id, required this.name, required this.address});

  final int id;
  final String name;
  final String address;

  @override
  List<Object?> get props => [id, name, address];
}

class HomeAppointmentStaffEntity extends Equatable {
  const HomeAppointmentStaffEntity({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
