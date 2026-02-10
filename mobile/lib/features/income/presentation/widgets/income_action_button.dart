import 'package:twoaxis_finance/features/income/presentation/pages/income_add.dart';
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
            builder: (context) => const IncomeAddItem(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
