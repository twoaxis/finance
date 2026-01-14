import 'package:financial_planner_mobile/features/auth/data/data_sources/remote/firebase_remote_data_source.dart';

abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> signup({
    required String email,
    required String password,
  });
  Future<void> resetPassword({
    required String email,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> login({
    required String email,
    required String password,
  }) {
    return remote.login(email: email, password: password);
  }

  @override
  Future<void> signup({
    required String email,
    required String password,
  }) {
    return remote.signup(email: email, password: password);
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) =>
      remote.resetPassword(email: email);
}

abstract class OnboardingRepository {
  Future<void> signInWithGoogle();
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remote;

  OnboardingRepositoryImpl(this.remote);

  @override
  Future<void> signInWithGoogle() {
    return remote.signInWithGoogle();
  }
}
