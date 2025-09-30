import 'package:core/src/either/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either', () {
    test('Right carries value and maps', () {
      const Either<String, int> e = Right(2);
      expect(e.isRight, isTrue);
      expect(e.isLeft, isFalse);
      expect(e.right, 2);
      expect(e.map((r) => r + 1).right, 3);
      expect(e.mapLeft((l) => 'x').right, 2);
      expect(e.fold((l) => -1, (r) => r * 2), 4);
      expect(e.swap(), const Left<int, String>(2));
    });

    test('Left carries value and maps', () {
      const Either<String, int> e = Left('err');
      expect(e.isLeft, isTrue);
      expect(e.isRight, isFalse);
      expect(e.left, 'err');
      expect(e.map((r) => r).left, 'err');
      expect(e.mapLeft((l) => l.toUpperCase()).left, 'ERR');
      expect(e.fold((l) => l.length, (r) => r), 3);
      expect(e.swap(), const Right<int, String>('err'));
    });

    test('either combinators', () {
      const Either<String, int> e = Right(1);
      final Either<String, String> res = e.either((l) => 'L$l', (r) => 'R$r');
      expect(res, const Right<String, String>('R1'));

      const Either<String, int> l = Left('x');
      expect(l.then((r) => Right(r + 1)), const Left<String, int>('x'));
      expect(l.thenLeft((left) => Right<int, int>(left.length)), const Right<int, int>(1));
    });

    test('tryCatch and tryExcept', () {
      final Either<String, int> ok = Either.tryCatch<String, int, StateError>((e) => e.toString(), () => 5);
      expect(ok, const Right<String, int>(5));

      final Either<FormatException, int> fail = Either.tryExcept<FormatException, int>(() {
        throw const FormatException('bad');
      });
      expect(fail.isLeft, isTrue);
      expect(fail.left.message, 'bad');
    });
  });

  group('FutureEither', () {
    test('fold async', () async {
      const Either<String, int> e = Right(10);
      final result = await Future<Either<String, int>>.value(e).fold((l) async => -1, (r) async => r * 3);
      expect(result, 30);
    });

    test('swap async', () async {
      final swapped = await Future.value(const Left<String, int>('oops')).swap();
      expect(swapped, const Right<int, String>('oops'));
    });
  });
}
