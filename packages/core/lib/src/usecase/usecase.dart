import 'package:core/src/utils/utils.dart';
import 'package:flutter/foundation.dart' show immutable;

abstract class UsecaseWithParams<Types, Params> {
  const new();

  ResultFuture<Types> call(Params params);
}

abstract class UsecaseWithoutParams<Types> {
  const new();

  ResultFuture<Types> call();
}

abstract class UsecaseWithParamsVoid<Params> {
  const new();

  ResultFuture<Unit> call(Params params);
}

@immutable
final class Unit {
  const new();

  @override
  String toString() => 'Unit';
}

const unit = Unit();
