import 'package:flutter_bloc/flutter_bloc.dart';

class AssetsCubit extends Cubit<List<dynamic>> {
  AssetsCubit() : super([]);

  void updateAssets(income) {
    emit(income);
  }

}