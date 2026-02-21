import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton({super.key, required this.icon, required this.name, required this.onPressed});

  final IconData icon;
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 20,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              shape: const CircleBorder(),
              elevation: 6, // Adjust for shadow depth
              padding: const EdgeInsets.all(16), // Ensures circular shape
            ),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ],
      ),
    );
  }
}
