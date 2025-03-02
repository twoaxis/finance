import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiabilitiesCubit extends Cubit<List<dynamic>> {
  LiabilitiesCubit() : super([]);

  void updateLiabilities(income) {
    emit(income);
  }

  Future<void> editLiability(int index, {String? name, int? value}) async {
    Map<String, dynamic> updatedLiability = {
      "name": name,
      "value": value,
    };
    List<dynamic> updatedLiabilitiesList = List.from(state);
    updatedLiabilitiesList[index] = updatedLiability;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"liabilities": updatedLiabilitiesList});
    emit(updatedLiabilitiesList);
  }
}
