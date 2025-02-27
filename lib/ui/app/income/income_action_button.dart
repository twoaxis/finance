import 'package:financial_planner_mobile/ui/app/income/add_income.dart';
import 'package:flutter/material.dart';

class IncomeActionButton extends StatelessWidget {
  const IncomeActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddIncome(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
