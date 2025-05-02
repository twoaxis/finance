import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCubit extends Cubit<List<dynamic>> {
  ExpensesCubit() : super([]);

  void updateExpenses(expenses) {
    emit(expenses);
  }

}