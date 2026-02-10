import 'package:twoaxis_finance/features/bills/presentation/pages/bills_add.dart';
import 'package:flutter/material.dart';

class BillsActionButton extends StatelessWidget {
  const BillsActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BillsAddItem(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
