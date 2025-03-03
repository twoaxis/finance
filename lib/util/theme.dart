import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        primary: Color.fromARGB(255, 167, 34, 34),
        primaryContainer: Color.fromARGB(255, 167, 34, 34),
        onPrimary: Colors.white,
        secondary: Color.fromARGB(255, 94, 25, 25),
        secondaryContainer: Color.fromARGB(255, 94, 25, 25),
        onSecondary: Colors.white,
        surface: Color.fromARGB(255, 20, 20, 20),
        surfaceContainer: Color.fromARGB(255, 30, 30, 30),
        surfaceBright: Color.fromARGB(255, 40, 40, 40),
        onSurfaceVariant: Color.fromARGB(255, 100, 100, 100),
        outline: Color.fromARGB(255, 100, 100, 100)));

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        primary: Color.fromARGB(255, 167, 34, 34),
        primaryContainer: Color.fromARGB(255, 167, 34, 34),
        onPrimary: Colors.white,
        secondary: Color.fromARGB(255, 94, 25, 25),
        secondaryContainer: Color.fromARGB(255, 94, 25, 25),
        onSecondary: Colors.white,
        surface: Colors.white,
        surfaceContainer: const Color.fromARGB(255, 245, 245, 245),
        surfaceBright: Color.fromARGB(255, 177, 177, 177),
        onSurfaceVariant: Color.fromARGB(255, 80, 80, 80),
        outline: Color.fromARGB(255, 100, 100, 100)));
