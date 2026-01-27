part of 'utils.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef DataList = List<dynamic>;

typedef ResultFeatureVoid = ResultFuture<void>;
typedef ResultVoid = Future<void>;
typedef ResultData<T> = Future<T>;
