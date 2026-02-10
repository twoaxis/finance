import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_repository.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'dart:developer' as developer;

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TransactionRepositoryImpl(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _firestore = firestore,
        _auth = auth;

  @override
  Future<String> addTransaction(String name, TransactionType type, double amount,
      {String? source, String? category, DateTime? date}) async {
    var docRef = await _firestore
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .collection("transactions")
        .add({
      "name": name,
      "type": type.name,
      "amount": amount,
      "date": date ?? DateTime.now(),
      "source": source,
      "category": category,
    });
    return docRef.id;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _firestore
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .collection("transactions")
        .doc(id)
        .delete();
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    try {
      var uid = _auth.currentUser?.uid;
      if (uid == null) {
        developer.log("getAllTransactions: User ID is null");
        return [];
      }
      
      var result = await _firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .get();

      developer.log("getAllTransactions: Found ${result.docs.length} documents");

      return result.docs.map((doc) {
        try {
          return Transaction.fromFirestore(doc);
        } catch (e) {
          developer.log("Error parsing transaction ${doc.id}: $e");
          rethrow;
        }
      }).toList();
    } catch (e) {
      developer.log("Error in getAllTransactions: $e");
      rethrow;
    }
  }
}
