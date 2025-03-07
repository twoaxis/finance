import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeCubit extends Cubit<List<dynamic>> {
  IncomeCubit() : super([]);

  void updateIncome(income) {
    emit(income);
  }

  Future<void> editIncome(int index, {String? name, int? value}) async {
    Map<String, dynamic> updatedIncome = {
      "name": name,
      "value": value,
    };
    List<dynamic> updatedIncomeList = List.from(state);
    updatedIncomeList[index] = updatedIncome;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"income": updatedIncomeList});
    emit(updatedIncomeList);
  }
}
