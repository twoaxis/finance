import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/abstract/firestore_service.dart';

class FirebaseFirestoreService implements FirestoreService {
  @override
  Future<void> writeEmptyUserData(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({
      "assets": [],
      "expenses": [],
      "income": [],
      "liabilities": [],
      "fixedExpenses": [],
      "receivables": []
    });
  }

  @override
  Stream<Map<String, dynamic>?> listenToUserData(String uid) => FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .snapshots()
      .map((snapshot) => snapshot.data());

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToUserExpenses(String uid) => FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("expenses")
      .snapshots();

}