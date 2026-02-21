import 'package:flutter/material.dart';

var appDarkTheme = const ColorScheme.dark(
  brightness: Brightness.dark,
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
  outline: Color.fromARGB(255, 100, 100, 100)
);

var appLightTheme = const ColorScheme.light(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 167, 34, 34),
  primaryContainer: Color.fromARGB(255, 167, 34, 34),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 94, 25, 25),
  secondaryContainer: Color.fromARGB(255, 94, 25, 25),
  onSecondary: Colors.white,
  surface: Colors.white,
  surfaceContainer: Color.fromARGB(255, 240, 240, 240),
  surfaceBright: Color.fromARGB(255, 250, 250, 250),
  onSurfaceVariant: Color.fromARGB(255, 80, 80, 80),
  outline: Color.fromARGB(255, 180, 180, 180)
);
