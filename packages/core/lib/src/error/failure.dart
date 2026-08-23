import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ServerFailure extends Failure {
  const new({required super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

class NoInternetFailure extends Failure {
  const new({required super.message});

  @override
  List<Object?> get props => <Object?>[message];
}

class CacheFailure extends Failure {
  const new({required super.message});

  @override
  List<Object?> get props => <Object?>[message];
}
