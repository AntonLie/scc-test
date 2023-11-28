// ignore_for_file: prefer_typing_uninitialized_variables

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class RefreshTokenFailedException extends AppException {
  RefreshTokenFailedException([message])
      : super(message, "Refresh Token Failed: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class InvalidSessionExpression extends AppException {
  InvalidSessionExpression([String? message])
      : super(message, "Invalid Session: ");
}