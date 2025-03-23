import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Stream<User?> authStateChanges();
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  User? getCurrentUser();
}