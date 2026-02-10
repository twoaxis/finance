import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:rxdart/rxdart.dart';
import 'package:twoaxis_finance/core/failures/network.dart';
import 'package:twoaxis_finance/core/failures/validation.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_failures.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/assets/domain/entities/asset.dart';
import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().switchMap((user) {
      if (user == null) return Stream.value(User.empty);

      return _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
        var domainUser = User(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
          balances: [],
          income: [],
          assets: [],
          bills: [],
          receivables: [],
          liabilities: [],
          currency: 'USD',
        );

        if (doc.exists && doc.data() != null) {
          var data = doc.data()!;

          if (data.containsKey('currency')) {
            domainUser = domainUser.copyWith(
              currency: data['currency'] as String,
            );
          }
          if (data.containsKey('name')) {
            domainUser = domainUser.copyWith(
              name: data['name'] as String,
            );
          }
          if (data.containsKey('balances')) {
            var balances = data['balances'] as List;
            domainUser = domainUser.copyWith(
                balances: balances.map((balance) {
              return Balance.fromFirestore(balance);
            }).toList());
          }
          if (data.containsKey('income')) {
            var income = data['income'] as List;
            domainUser = domainUser.copyWith(
                income: income.map((i) {
              return Income.fromFirestore(i);
            }).toList());
          }
          if (data.containsKey('assets')) {
            var assets = data['assets'] as List;
            domainUser = domainUser.copyWith(
                assets: assets.map((asset) {
              return Asset.fromFirestore(asset);
            }).toList());
          }
          if (data.containsKey('bills')) {
            var bills = data['bills'] as List;
            domainUser = domainUser.copyWith(
                bills: bills.map((bill) {
              return Bill.fromFirestore(bill);
            }).toList());
          }
          if (data.containsKey('receivables')) {
            var receivables = data['receivables'] as List;
            domainUser = domainUser.copyWith(
                receivables: receivables.map((receivable) {
              return Receivable.fromFirestore(receivable);
            }).toList());
          }
          if (data.containsKey('liabilities')) {
            var liabilities = data['liabilities'] as List;
            domainUser = domainUser.copyWith(
                liabilities: liabilities.map((liability) {
              return Liability.fromFirestore(liability);
            }).toList());
          }
          if (data.containsKey('budget') && data['budget'] != null) {
            domainUser = domainUser.copyWith(
              budget: Budget.fromFirestore(data['budget']),
            );
          }
        }
        return domainUser;
      });
    });
  }

  @override
  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundFailure();
      } else if (e.code == "wrong-password") {
        throw InvalidPasswordFailure();
      } else if (e.code == "invalid-credential") {
        throw InvalidCredentialsFailure();
      } else {
        throw ServerFailure();
      }
    } on SocketException {
      throw ConnectionFailure();
    } catch (_) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw UserNotFoundFailure();
      } else if (e.code == "weak-password") {
        throw InvalidPasswordFailure();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailFailure();
      } else {
        throw ServerFailure();
      }
    } on SocketException {
      throw ConnectionFailure();
    } catch (_) {
      throw ServerFailure();
    }
  }
}
