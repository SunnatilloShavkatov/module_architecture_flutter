import 'package:home/src/domain/entities/home_business_entity.dart';

class HomeBusinessModel extends HomeBusinessEntity {
  const HomeBusinessModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.reviewCount,
    required super.imageUrl,
    required super.distance,
    required super.waitTime,
    required super.isOpen,
    required super.description,
    required super.workingHours,
    required super.phoneNumber,
    required super.address,
  });

  factory HomeBusinessModel.fromMap(Map<String, dynamic> map) => HomeBusinessModel(
    id: '${map['id'] ?? ''}',
    name: map['name'] ?? '',
    rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] ?? 0.0),
    reviewCount: map['reviewCount'] ?? 0,
    imageUrl: map['imageUrl'] ?? '',
    distance: map['distance'] ?? 'N/A',
    waitTime: map['waitTime'] ?? 'Unknown',
    isOpen: map['isOpen'] ?? false,
    description: map['description'] ?? '',
    workingHours: map['workingHours'] ?? '9AM - 8PM',
    phoneNumber: map['phoneNumber'] ?? '',
    address: map['address'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'rating': rating,
    'reviewCount': reviewCount,
    'imageUrl': imageUrl,
    'distance': distance,
    'waitTime': waitTime,
    'isOpen': isOpen,
    'description': description,
    'workingHours': workingHours,
    'phoneNumber': phoneNumber,
    'address': address,
  };
}
