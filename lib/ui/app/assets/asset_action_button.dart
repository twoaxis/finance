import 'package:financial_planner_mobile/ui/app/assets/add_assets.dart';
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
            builder: (context) => const AddAssets(),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
