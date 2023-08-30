import 'package:dartz/dartz.dart';
import 'package:firebase_note/domain/core/value_object.dart';
import '../core/failure.dart';
import '../core/value_validator.dart';


class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  factory EmailAddress(String input) {
    return EmailAddress._(validateEmailAddress(input));
  }
  const EmailAddress._(this.value);
}


class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  factory Password(String input) {
    return Password._(validatePassword(input));
  }
  const Password._(this.value);
}



