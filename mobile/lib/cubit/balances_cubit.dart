import 'package:flutter_bloc/flutter_bloc.dart';

class BalancesCubit extends Cubit<List<dynamic>> {
  BalancesCubit() : super([]);

  void updateBalances(balances) {
    emit(balances);
  }

}