class ServerException implements Exception {
  final String message;

  const ServerException({this.message = 'Server request failed'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache operation failed'});

  @override
  String toString() => 'CacheException: $message';
}
