import 'package:financial_planner_mobile/ui/app/assets/assets_add.dart';
import 'package:flutter/material.dart';

class AssetActionButton extends StatelessWidget {
  const AssetActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AssetsAdd(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
