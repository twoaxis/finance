import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCubit extends Cubit<dynamic> {
  BudgetCubit() : super([]);

  void updateBudget(budget) {
    emit(budget);
  }

}