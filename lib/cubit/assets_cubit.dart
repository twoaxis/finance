import 'package:flutter_bloc/flutter_bloc.dart';

class AssetsCubit extends Cubit<List<dynamic>> {
  AssetsCubit() : super([]);

  void updateAssets(assets) {
    emit(assets);
  }

}