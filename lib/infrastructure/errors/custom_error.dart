class WrongCredentials implements Exception{}
class InvalidToken implements Exception{}
class ConnectionTimeout implements Exception{}
class UserNotFound implements Exception{}

class CustomError implements Exception{

  final String message;

  CustomError(this.message);


}