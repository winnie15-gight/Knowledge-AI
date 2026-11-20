import 'dart:async';
import 'dart:io';

class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class ErrorHandler {
  static String parse(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error is TimeoutException) {
      return 'Connection timed out. The server took too long to respond.';
    } else if (error is AppException) {
      return error.message;
    }
    return error.toString().replaceAll('Exception: ', '');
  }
}
