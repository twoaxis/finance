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

}