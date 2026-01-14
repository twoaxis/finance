import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
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

abstract class OnboardingRemoteDataSource {
  Future<void> signInWithGoogle();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  OnboardingRemoteDataSourceImpl(
    this.auth,
    this.googleSignIn,
  );

  @override
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await auth.signInWithCredential(credential);
  }
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(
    this.auth,
    this.firestore,
  );

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firestore.collection("users").doc(credential.user!.uid).set({
      "assets": [],
      "expenses": [],
      "income": [],
      "liabilities": [],
      "fixedExpenses": [],
      "receivables": [],
    });

    await credential.user?.sendEmailVerification();
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
