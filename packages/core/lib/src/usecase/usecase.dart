import 'package:core/src/utils/utils.dart';

abstract class UsecaseWithParams<Types, Params> {
  const new();

  ResultFuture<Types> call(Params params);
}

abstract class UsecaseWithoutParams<Types> {
  const new();

  ResultFuture<Types> call();
}
