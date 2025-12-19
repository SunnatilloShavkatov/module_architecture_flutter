part of 'more_bloc.dart';

sealed class MoreState extends Equatable {
  const MoreState();
}

final class MoreInitialState extends MoreState {
  const MoreInitialState();

  @override
  List<Object?> get props => [];
}

final class PackageVersionState extends MoreState {
  const PackageVersionState({required this.version});

  final PackageInfo version;

  @override
  List<Object?> get props => [version];
}
