import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_planner_mobile/abstract/auth_service.dart';

@GenerateMocks([
  AuthService,
  UserCredential,
  User
])
void main() {}