import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:financial_planner_mobile/cubit/currency_cubit.dart';

String formatMoneyWithContext(BuildContext context, num value) {
  var currency = context.read<CurrencyCubit>().state;
  var format = NumberFormat.simpleCurrency(name: currency);
  return format.format(value);
}