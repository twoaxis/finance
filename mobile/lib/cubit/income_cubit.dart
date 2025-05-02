import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeCubit extends Cubit<List<dynamic>> {
  IncomeCubit() : super([]);

  void updateIncome(income) {
    emit(income);
  }

}