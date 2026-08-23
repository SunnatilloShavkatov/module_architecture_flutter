part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const new();
}

final class HomeLoadEvent extends HomeEvent {
  const new();

  @override
  List<Object?> get props => [];
}

final class HomeRefreshEvent extends HomeEvent {
  const new();

  @override
  List<Object?> get props => [];
}
