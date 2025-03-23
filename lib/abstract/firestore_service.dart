import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  Future<void> writeEmptyUserData(String uid);
  Stream<Map<String, dynamic>?> listenToUserData(String uid);
  Stream<QuerySnapshot<Map<String, dynamic>>> listenToUserExpenses(String uid);
}