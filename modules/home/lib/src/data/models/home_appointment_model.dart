import 'package:home/src/domain/entities/home_appointment_entity.dart';

class HomeAppointmentModel extends HomeAppointmentEntity {
  const HomeAppointmentModel({
    required super.id,
    required super.userId,
    required super.businessId,
    required super.staffId,
    required super.services,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.totalPrice,
    super.business,
    super.staff,
  });

  factory HomeAppointmentModel.fromMap(Map<String, dynamic> map) {
    final List<HomeAppointmentServiceEntity> services = [];
    final Map<String, dynamic> user = map['user'] != null ? Map<String, dynamic>.from(map['user'] as Map) : {};
    final Map<String, dynamic> business = map['business'] != null
        ? Map<String, dynamic>.from(map['business'] as Map)
        : {};
    final Map<String, dynamic> staff = map['staff'] != null ? Map<String, dynamic>.from(map['staff'] as Map) : {};

    if (map['services'] != null && map['services'] is List) {
      for (final service in map['services']) {
        services.add(HomeAppointmentServiceModel.fromMap(Map<String, dynamic>.from(service as Map)));
      }
    }
    return HomeAppointmentModel(
      id: map['id'] ?? 0,
      userId: user['id'] ?? 0,
      businessId: business['id'] ?? 0,
      staffId: staff['id'] ?? 0,
      services: services,
      startTime: DateTime.tryParse(map['startTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      endTime: DateTime.tryParse(map['endTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      status: map['status'] ?? '',
      totalPrice: (map['totalPrice'] is num) ? (map['totalPrice'] as num).toDouble() : 0,
      business: map['business'] != null ? HomeAppointmentBusinessModel.fromMap(business) : null,
      staff: map['staff'] != null ? HomeAppointmentStaffModel.fromMap(staff) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'businessId': businessId,
    'staffId': staffId,
    'services': services
        .map(
          (service) => {
            'id': service.id,
            'name': service.name,
            'price': service.price,
            'durationMin': service.durationMin,
          },
        )
        .toList(),
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'status': status,
    'totalPrice': totalPrice,
    'business': business != null ? {'id': business?.id, 'name': business?.name, 'address': business?.address} : null,
    'staff': staff != null ? {'id': staff?.id, 'fullName': staff?.name} : null,
  };
}

class HomeAppointmentServiceModel extends HomeAppointmentServiceEntity {
  const HomeAppointmentServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.durationMin,
  });

  factory HomeAppointmentServiceModel.fromMap(Map<String, dynamic> map) => HomeAppointmentServiceModel(
    id: map['id'] ?? 0,
    name: map['name'] ?? '',
    price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0,
    durationMin: map['durationMin'] ?? 0,
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'price': price, 'durationMin': durationMin};
}

class HomeAppointmentBusinessModel extends HomeAppointmentBusinessEntity {
  const HomeAppointmentBusinessModel({required super.id, required super.name, required super.address});

  factory HomeAppointmentBusinessModel.fromMap(Map<String, dynamic> map) =>
      HomeAppointmentBusinessModel(id: map['id'] ?? 0, name: map['name'] ?? '', address: map['address'] ?? '');

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'address': address};
}

class HomeAppointmentStaffModel extends HomeAppointmentStaffEntity {
  const HomeAppointmentStaffModel({required super.id, required super.name});

  factory HomeAppointmentStaffModel.fromMap(Map<String, dynamic> map) =>
      HomeAppointmentStaffModel(id: map['id'] ?? 0, name: map['fullName'] ?? map['name'] ?? '');

  Map<String, dynamic> toMap() => {'id': id, 'fullName': name};
}
