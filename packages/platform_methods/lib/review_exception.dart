class ReviewException implements Exception {
  const new({required this.code, required this.message, this.details});

  final String code;
  final String message;
  final String? details;

  @override
  String toString() => 'ReviewException($code): $message';
}
