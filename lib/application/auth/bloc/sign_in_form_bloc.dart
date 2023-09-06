import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_note/domain/auth/auth_failure.dart';
import 'package:firebase_note/domain/auth/i_auth_facade.dart';
import 'package:firebase_note/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(signInFormEvent);
  }

  FutureOr<void> signInFormEvent(
      SignInFormEvent event, Emitter<SignInFormState> emit) async* {
    yield* event.map(
      emailChanged: (value) async* {
        yield state.copyWith(
            emailAddress: EmailAddress(value.emailStr),
            authFailureOrSuccessOption: none());
      },
      passwordChanged: (value) async* {
        yield state.copyWith(
            password: Password(value.passwordStr),
            authFailureOrSuccessOption: none());
      },
      registerWithEmailAndPasswordPressed: (value) async* {
        yield* _performOnAuthFacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (value) async* {
        yield* _performOnAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword,
        );
      },
      signInWithGooglePressed: (value) async* {
        yield state.copyWith(
            isSubmitting: true, authFailureOrSuccessOption: none());
        final filureOrSuccess = await _authFacade.signInWithGoogle();
        yield state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: some(filureOrSuccess));
      },
    );
  }

  Stream<SignInFormState> _performOnAuthFacadeWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function(
              {required EmailAddress emailAddress, required Password password})
          forwardedCall) async* {
    bool isEmailValid = state.emailAddress.isValid();
    bool isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;
    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
          isSubmitting: true, authFailureOrSuccessOption: none());
      failureOrSuccess = await forwardedCall(
          emailAddress: state.emailAddress, password: state.password);
    }
    yield state.copyWith(
        showErrorMessage: true,
        isSubmitting: false,
        authFailureOrSuccessOption: optionOf(failureOrSuccess));
  }
}
