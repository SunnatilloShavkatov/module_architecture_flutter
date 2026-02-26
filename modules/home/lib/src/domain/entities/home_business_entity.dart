import 'package:core/core.dart' show Equatable;

class HomeBusinessEntity extends Equatable {
  const HomeBusinessEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.distance,
    required this.waitTime,
    required this.isOpen,
    required this.description,
    required this.workingHours,
    required this.phoneNumber,
    required this.address,
  });

  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String distance;
  final String waitTime;
  final bool isOpen;
  final String description;
  final String workingHours;
  final String phoneNumber;
  final String address;

  @override
  List<Object?> get props => [
    id,
    name,
    rating,
    reviewCount,
    imageUrl,
    distance,
    waitTime,
    isOpen,
    description,
    workingHours,
    phoneNumber,
    address,
  ];
}
