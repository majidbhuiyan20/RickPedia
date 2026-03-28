abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ConnectionTimeoutException extends NetworkException {
  ConnectionTimeoutException()
      : super('Connection timeout. Please check your internet connection.');
}

class ReceiveTimeoutException extends NetworkException {
  ReceiveTimeoutException() : super('Request timeout. Please try again.');
}

class ServerException extends NetworkException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
  }) : super(message);
}

class UnknownException extends NetworkException {
  UnknownException(String message) : super(message);
}
