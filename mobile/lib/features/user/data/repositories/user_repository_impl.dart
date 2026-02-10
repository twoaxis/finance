import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twoaxis_finance/features/assets/domain/entities/asset.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  String get _userId => _auth.currentUser?.uid ?? '';

  DocumentReference get _userDoc => _firestore.collection('users').doc(_userId);

  @override
  Future<void> addAsset(Asset asset) async {
    await _userDoc.update({
      'assets': FieldValue.arrayUnion([asset.toFirestore()])
    });
  }

  @override
  Future<void> addBalance(Balance balance) async {
    await _userDoc.update({
      'balances': FieldValue.arrayUnion([balance.toFirestore()])
    });
  }

  @override
  Future<void> addBill(Bill bill) async {
    await _userDoc.update({
      'bills': FieldValue.arrayUnion([bill.toFirestore()])
    });
  }

  @override
  Future<void> addIncome(Income income) async {
    await _userDoc.update({
      'income': FieldValue.arrayUnion([income.toFirestore()])
    });
  }

  @override
  Future<void> addLiability(Liability liability) async {
    await _userDoc.update({
      'liabilities': FieldValue.arrayUnion([liability.toFirestore()])
    });
  }

  @override
  Future<void> addReceivable(Receivable receivable) async {
    await _userDoc.update({
      'receivables': FieldValue.arrayUnion([receivable.toFirestore()])
    });
  }

  @override
  Future<void> removeAsset(Asset asset) async {
    await _userDoc.update({
      'assets': FieldValue.arrayRemove([asset.toFirestore()])
    });
  }

  @override
  Future<void> removeBalance(Balance balance) async {
    await _userDoc.update({
      'balances': FieldValue.arrayRemove([balance.toFirestore()])
    });
  }

  @override
  Future<void> removeBill(Bill bill) async {
    await _userDoc.update({
      'bills': FieldValue.arrayRemove([bill.toFirestore()])
    });
  }

  @override
  Future<void> removeIncome(Income income) async {
    await _userDoc.update({
      'income': FieldValue.arrayRemove([income.toFirestore()])
    });
  }

  @override
  Future<void> removeLiability(Liability liability) async {
    await _userDoc.update({
      'liabilities': FieldValue.arrayRemove([liability.toFirestore()])
    });
  }

  @override
  Future<void> removeReceivable(Receivable receivable) async {
    await _userDoc.update({
      'receivables': FieldValue.arrayRemove([receivable.toFirestore()])
    });
  }

  @override
  Future<void> updateAssets(List<Asset> assets) async {
    await _userDoc.update({
      'assets': assets.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateBalances(List<Balance> balances) async {
    await _userDoc.update({
      'balances': balances.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateBills(List<Bill> bills) async {
    await _userDoc.update({
      'bills': bills.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateBudget(Budget? budget) async {
    await _userDoc.update({
      'budget': budget?.toFirestore()
    });
  }

  @override
  Future<void> updateIncome(List<Income> income) async {
    await _userDoc.update({
      'income': income.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateLiabilities(List<Liability> liabilities) async {
    await _userDoc.update({
      'liabilities': liabilities.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateReceivables(List<Receivable> receivables) async {
    await _userDoc.update({
      'receivables': receivables.map((e) => e.toFirestore()).toList()
    });
  }

  @override
  Future<void> updateName(String name) async {
    await _userDoc.update({
      'name': name
    });
  }

  @override
  Future<void> updateCurrency(String currency) async {
    await _userDoc.update({
      'currency': currency
    });
  }
}
