import 'package:financial_planner_mobile/abstract/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _instance.authStateChanges();

  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) => _instance.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) => _instance.signInWithEmailAndPassword(email: email, password: password);



}