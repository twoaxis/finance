import 'package:twoaxis_finance/ui/app/bills/bills_add.dart';
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
            builder: (context) => BillsAddItem(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
