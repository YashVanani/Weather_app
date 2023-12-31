import 'package:flutter/material.dart';
import 'package:weather_app_practical/main.dart';

/// Custom Exception model class for handling various exceptions in the app.
class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    /// Displays a SnackBar with the exception message.
    final SnackBar snackBar = SnackBar(content: Text(_message), backgroundColor: Colors.red, duration: Duration(seconds: 3), behavior: SnackBarBehavior.floating);
    snackBarKey.currentState?.showSnackBar(snackBar);

    /// Returns a formatted string with the exception prefix and message.
    return "$_prefix $_message";
  }
}

/// Exception thrown when there's a failure in communication with the server.
class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "Error During Communication:");
}

/// Exception thrown for invalid requests.
class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

/// Exception thrown when an unauthorized user token is passed.
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

/// Exception thrown for invalid input.
class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
