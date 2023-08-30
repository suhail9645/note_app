import 'package:dartz/dartz.dart';
import 'failure.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String emailAddress) {
  const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  if (RegExp(emailRegex).hasMatch(emailAddress)) {
    return Right(emailAddress);
  } else {
    return Left(ValueFailure.invalidEmail(failedValue: emailAddress));
  }
}


Either<ValueFailure<String>, String> validatePassword(String password) {
 
  if (password.length>=6) {
    return Right(password);
  } else {
    return Left(ValueFailure.shortPassword(failedValue: password));
  }
}