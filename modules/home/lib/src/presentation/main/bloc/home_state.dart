part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitialState extends HomeState {
  const HomeInitialState();

  @override
  List<Object?> get props => [];
}

final class HomeLoadingState extends HomeState {
  const HomeLoadingState();

  @override
  List<Object?> get props => [];
}

final class HomeSuccessState extends HomeState {
  const HomeSuccessState({
    required this.firstName,
    required this.categories,
    required this.businesses,
    required this.appointments,
  });

  final String firstName;
  final List<HomeCategoryEntity> categories;
  final List<HomeBusinessEntity> businesses;
  final List<HomeAppointmentEntity> appointments;

  @override
  List<Object?> get props => [firstName, categories, businesses, appointments];
}

final class HomeFailureState extends HomeState {
  const HomeFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
