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
  Future<Map<String, dynamic>> getTransactions({int limit = 30, Object? startAfter}) async {
    try {
      var uid = _auth.currentUser?.uid;
      if (uid == null) {
        developer.log("getTransactions: User ID is null");
        return {'transactions': <Transaction>[], 'lastDocument': null};
      }
      
      Query query = _firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .orderBy("date", descending: true)
          .limit(limit);

      if (startAfter != null && startAfter is DocumentSnapshot) {
        query = query.startAfterDocument(startAfter);
      }
      
      var result = await query.get();

      developer.log("getTransactions: Found ${result.docs.length} documents");

      List<Transaction> transactions = result.docs.map((doc) {
        try {
          return Transaction.fromFirestore(doc);
        } catch (e) {
          developer.log("Error parsing transaction ${doc.id}: $e");
          rethrow;
        }
      }).toList();

      DocumentSnapshot? lastDocument = result.docs.isNotEmpty ? result.docs.last : null;

      return {
        'transactions': transactions,
        'lastDocument': lastDocument,
      };
    } catch (e) {
      developer.log("Error in getTransactions: $e");
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      var uid = _auth.currentUser?.uid;
      if (uid == null) {
        return [];
      }
      
      var result = await _firestore
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .where("date", isGreaterThanOrEqualTo: start)
          .where("date", isLessThanOrEqualTo: end)
          .orderBy("date", descending: true)
          .get();

      return result.docs.map((doc) {
        return Transaction.fromFirestore(doc);
      }).toList();
    } catch (e) {
      developer.log("Error in getTransactionsByDateRange: $e");
      rethrow;
    }
  }
}
