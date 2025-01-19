part of 'extension.dart';

extension SliverCountExtension on int {
  int get doubleTheListCount => math.max(0, (this * 2) - 1);

  int get exactIndex => this ~/ 2;

  int get lastIndex => (this * 2) - 2;

  int toRound(int i) => this % i == 0 ? (this ~/ i) : (this ~/ i + 1);
}
