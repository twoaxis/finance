import 'package:financial_planner_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository repository;

  SignupCubit(this.repository) : super(SignupInitial());

  Future<void> signup({
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      emit(SignupError("Please fill all fields"));
      return;
    }

    if (password != repeatPassword) {
      emit(SignupError("Passwords don't match"));
      return;
    }

    emit(SignupLoading());

    try {
      await repository.signup(email: email, password: password);
      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignupError("Password is too weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(SignupError("E-mail already exists"));
      } else {
        emit(SignupError(e.message ?? "An error occurred"));
      }
    } catch (_) {
      emit(SignupError("Something went wrong"));
    }
  }
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError("Please fill all fields"));
      return;
    }

    emit(LoginLoading());

    try {
      await repository.login(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (_) {
      emit(LoginError("Invalid E-mail or Password"));
    } catch (_) {
      emit(LoginError("Something went wrong"));
    }
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository repository;

  OnboardingCubit(this.repository) : super(OnboardingInitial());

  Future<void> signInWithGoogle() async {
    emit(OnboardingLoading());
    try {
      await repository.signInWithGoogle();
      emit(OnboardingSuccess());
    } catch (_) {
      emit(OnboardingError("Google sign-in failed"));
    }
  }
}

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository repository;

  ForgetPasswordCubit(this.repository) : super(ForgetPasswordInitial());

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      emit(ForgetPasswordError("Please enter your e-mail"));
      return;
    }

    emit(ForgetPasswordLoading());

    try {
      await repository.resetPassword(email: email);
      emit(ForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // same behavior as original code
        emit(ForgetPasswordSuccess());
      } else {
        emit(ForgetPasswordError("An unexpected error has occurred"));
      }
    } catch (_) {
      emit(ForgetPasswordError("An unexpected error has occurred"));
    }
  }
}
