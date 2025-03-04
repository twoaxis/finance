import 'package:financial_planner_mobile/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({super.key});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      isDarkMode = context.read<ThemeCubit>().state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Dark mode',
      ),
      value: isDarkMode,
      onChanged: (bool value) {
        final cubit = context.read<ThemeCubit>();
        cubit.isDarkMode(!isDarkMode);
        setState(() {
          isDarkMode = value;
        });
      },
      secondary: Icon(
        Icons.brightness_3,
      ),
    );
  }
}
