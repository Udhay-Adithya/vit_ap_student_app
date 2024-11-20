class ServerUnreachableException implements Exception {
  final String message;
  final int statusCode;

  ServerUnreachableException(this.message, this.statusCode);

  @override
  String toString() =>
      'IncorrectPasswordException: $message (Status code: $statusCode)';
}