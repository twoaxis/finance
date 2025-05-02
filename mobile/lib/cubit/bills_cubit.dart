import 'package:flutter_bloc/flutter_bloc.dart';

class BillsCubit extends Cubit<List<dynamic>> {
  BillsCubit() : super([]);

  void updateBills(bills) {
    emit(bills);
  }

}