import 'package:flutter_bloc/flutter_bloc.dart';

class LiabilitiesCubit extends Cubit<List<dynamic>> {
  LiabilitiesCubit() : super([]);

  void updateLiabilities(income) {
    emit(income);
  }

}