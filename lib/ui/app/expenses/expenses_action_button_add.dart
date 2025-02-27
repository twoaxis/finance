import 'package:financial_planner_mobile/ui/app/expenses/add_expenses.dart';

import 'package:flutter/material.dart';

class ExpensesActionButtonAdd extends StatelessWidget {
  const ExpensesActionButtonAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddExpenses(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
