part of 'more_bloc.dart';

sealed class MoreEvent extends Equatable {
  const MoreEvent();
}

final class GetPackageVersionEvent extends MoreEvent {
  const GetPackageVersionEvent();

  @override
  List<Object?> get props => [];
}
