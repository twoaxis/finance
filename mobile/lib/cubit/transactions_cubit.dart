import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsCubit extends Cubit<List<dynamic>> {
  TransactionsCubit() : super([]);

  void updateTransactions(transactions) {
    emit(transactions);
  }

}