import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivablesCubit extends Cubit<List<dynamic>> {
  ReceivablesCubit() : super([]);

  void updateReceivables(income) {
    emit(income);
  }

}