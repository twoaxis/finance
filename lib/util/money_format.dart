import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/currency_cubit.dart';

String formatMoneyWithContext(BuildContext context, num value) {
  final currency = context.read<CurrencyCubit>().state;
  final format = NumberFormat.simpleCurrency(name: currency);
  return format.format(value);
}