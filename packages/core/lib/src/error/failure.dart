import "package:base_dependencies/base_dependencies.dart";

sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({required super.message});

  @override
  List<Object?> get props => <Object?>[];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});

  @override
  List<Object?> get props => <Object?>[message];
}
