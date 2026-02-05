/// Exception types for the app
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
      : super(message);
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred', int? statusCode])
      : super(message, statusCode: statusCode);
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found'])
      : super(message, statusCode: 404);
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation error'])
      : super(message, statusCode: 400);
}
