import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit() : super("USD");

  void updateCurrency(currency) {
    emit(currency);
  }

}