// This is the base class for all custom exceptions in the application.
import 'package:flutter/foundation.dart';

class AppExceptions implements Exception {
  // These are the optional message and prefix for the exception.
  final String? _message;
  final String? _prefix;

  // This is the constructor for the AppExceptions class.
  AppExceptions([this._prefix, this._message]);

  // This method returns a string representation of the exception.
  @override
  String toString() {
    if (kDebugMode) {
      print("$_prefix$_message");
    }
    return "$_message";
  }
}

// This is a custom exception class for fetch data errors.
class FetchDataException extends AppExceptions {
  // This is the constructor for the FetchDataException class.
  FetchDataException([String? message]) : super("Error During Communication:: ", message);
}



// This is a custom exception class for bad request errors.
class BadRequestException extends AppExceptions {
  // This is the constructor for the BadRequestException class.
  BadRequestException([String? message]) : super("Invalid Request:: ", message);

}

// This is a custom exception class for unauthorized errors.
class UnauthorisedException extends AppExceptions {

  // This is the constructor for the UnauthorisedException class.
  UnauthorisedException([String? message]) : super("Unauthorised:: ", message);


}

// This is a custom exception class for invalid input errors.
class InvalidInputException extends AppExceptions {
  // This is the constructor for the InvalidInputException class.
  InvalidInputException([String? message]) : super("Invalid Input:: ", message);
}

// This is a custom exception class for bad request errors.
class InternalServerError extends AppExceptions {
  // This is the constructor for the BadRequestException class.
  InternalServerError([String? message]) : super("Internal Server Error:: ", message);

}
class DataAlreadyAddedError extends AppExceptions {
  // This is the constructor for the BadRequestException class.
  DataAlreadyAddedError([String? message])
      : super("Data Already Found:: ", message);


}

class DioExceptionError extends AppExceptions {
  // This is the constructor for the BadRequestException class.
  DioExceptionError([String? message]) : super("Error occurred due to:: ", message);
}

