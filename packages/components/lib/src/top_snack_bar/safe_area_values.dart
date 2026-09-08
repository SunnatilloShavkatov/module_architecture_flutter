part of 'top_snack_bar.dart';

/// A data class that is used to pass safe area values for snackbar
final class SafeAreaValues {
  const new({this.top = true, this.left = true, this.right = true, this.bottom = true, this.minimum = EdgeInsets.zero});

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
}
