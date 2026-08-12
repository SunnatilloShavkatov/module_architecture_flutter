import 'package:core/src/either/either.dart';
import 'package:core/src/error/failure.dart';

abstract interface class ModuleInteractor<T, P> {
  const ModuleInteractor();

  Future<Either<Failure, T>> call(P params);
}

final class NoParams {
  const NoParams();
}
