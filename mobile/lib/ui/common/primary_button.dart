import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed, this.enabled = true});

  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black,
          elevation: 3,
        ),
        onPressed: enabled ? () {
          onPressed();
        } : null,
        child: Text(
          text,
          style: TextStyle(color: darkTheme.onPrimary),
        ),
      ),
    );
  }
}
