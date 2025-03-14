import 'package:intl/intl.dart';

String formatMoney(var value) {
  return "\$${NumberFormat('#,##0').format(value)}";
}