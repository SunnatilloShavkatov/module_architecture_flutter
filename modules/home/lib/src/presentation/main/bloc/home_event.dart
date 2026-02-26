part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeLoadEvent extends HomeEvent {
  const HomeLoadEvent();

  @override
  List<Object?> get props => [];
}

final class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();

  @override
  List<Object?> get props => [];
}
