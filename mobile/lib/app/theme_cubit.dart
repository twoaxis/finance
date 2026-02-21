import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() async {
    var instance = await SharedPreferences.getInstance();
    emit(instance.getBool('dark_mode') == true ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme(bool isDark) async {
    var instance = await SharedPreferences.getInstance();
    instance.setBool('dark_mode', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
