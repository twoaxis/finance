import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/core/failures/validation.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_failures.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';

part "auth_events.dart";

part "auth_states.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _authRepository.logIn(email: event.email, password: event.password);

      emit(AuthSuccess());
    } on UserNotFoundFailure {
      emit(AuthFailure("E-mail does not exist"));
    } on InvalidPasswordFailure {
      emit(AuthFailure("Incorrect password"));
    } on InvalidCredentialsFailure {
      emit(AuthFailure("E-mail or password is incorrect"));
    } catch (_) {
      emit(AuthFailure("An error occurred"));
    }
  }

  Future<void> _onSignupRequested(
      AuthSignupRequested event, Emitter<AuthState> emit) async {

    emit(AuthLoading());

    try {
      await _authRepository.signUp(email: event.email, password: event.password);

      emit(AuthSuccess());
    } on UserExistsFailure {
      emit(AuthFailure("E-mail is already taken"));
    } on InvalidEmailFailure {
      emit(AuthFailure("Invalid E-mail"));
    } on InvalidPasswordFailure {
      emit(AuthFailure("Weak Password"));
    } catch (_) {
      emit(AuthFailure("An error occurred"));
    }
  }
}
