import 'package:core/src/utils/utils.dart';

abstract class UsecaseWithParams<Types, Params> {
  const UsecaseWithParams();

  ResultFuture<Types> call(Params params);
}

abstract class UsecaseWithoutParams<Types> {
  const UsecaseWithoutParams();

  ResultFuture<Types> call();
}
