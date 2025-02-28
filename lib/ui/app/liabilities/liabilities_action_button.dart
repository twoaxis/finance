import 'package:financial_planner_mobile/ui/app/liabilities/add_liabilities.dart';

import 'package:flutter/material.dart';

class LiabilitiesActionButton extends StatelessWidget {
  const LiabilitiesActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddLiabilities(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
