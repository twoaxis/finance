import 'package:twoaxis_finance/features/user/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User> get user;

  Future<void> logIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> logOut();
}
