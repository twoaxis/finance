import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class ThemedInputField extends StatelessWidget {
  const ThemedInputField(
      {super.key,
      required this.label,
      required this.controller,
      required this.placeholder,
      this.obscureText = false,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.none,
      this.onTap,
      this.readOnly = false});

  final String label;
  final TextEditingController? controller;
  final String placeholder;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            filled: true,
            hintText: placeholder,
            fillColor: darkTheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
        )
      ],
    );
  }
}
