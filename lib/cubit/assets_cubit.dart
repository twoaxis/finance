import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssetsCubit extends Cubit<List<dynamic>> {
  AssetsCubit() : super([]);

  void updateAssets(income) {
    emit(income);
  }

  Future<void> editAsset(int index, {String? name, int? value}) async {
    Map<String, dynamic> updatedAsset = {
      "name": name,
      "value": value,
    };
    List<dynamic> updatedAssetsList = List.from(state);
    updatedAssetsList[index] = updatedAsset;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"assets": updatedAssetsList});
    emit(updatedAssetsList);
  }
}
