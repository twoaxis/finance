import 'package:financial_planner_mobile/ui/app/balances/balances_add.dart';
import 'package:flutter/material.dart';

class BalancesActionButton extends StatelessWidget {
  const BalancesActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BalancesAdd(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
