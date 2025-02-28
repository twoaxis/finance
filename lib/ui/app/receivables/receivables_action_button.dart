import 'package:financial_planner_mobile/ui/app/receivables/add_receivables.dart';

import 'package:flutter/material.dart';

class ReceivablesActionButton extends StatelessWidget {
  const ReceivablesActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddReceivables(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
