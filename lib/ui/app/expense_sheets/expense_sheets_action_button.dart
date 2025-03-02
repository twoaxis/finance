import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheets_add.dart';

import 'package:flutter/material.dart';

class ExpenseSheetsActionButtonAdd extends StatelessWidget {
  const ExpenseSheetsActionButtonAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExpenseSheetsAdd(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
