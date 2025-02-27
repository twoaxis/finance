import 'package:flutter_bloc/flutter_bloc.dart';

class FixedExpensesCubit extends Cubit<List<dynamic>> {
  FixedExpensesCubit() : super([]);

  void updateFixedExpenses(income) {
    emit(income);
  }

}