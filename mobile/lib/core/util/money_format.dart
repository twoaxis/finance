import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';

String formatMoneyWithContext(BuildContext context, num value) {
  var state = context.read<UserCubit>().state;
  String currency = 'USD';
  if (state is UserStateAuthenticated) {
    currency = state.user.currency;
  }
  var format = NumberFormat.simpleCurrency(name: currency);
  return format.format(value);
}
