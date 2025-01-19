class ServerException implements Exception {
  const ServerException({required this.message});

  factory ServerException.fromJson(Map<String, dynamic> json) =>
      ServerException(message: json['detail']);
  final String message;
}

class NoInternetException implements Exception {
  const NoInternetException();
}

class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => message;
}
