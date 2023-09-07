import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeServices extends StateNotifier<ThemeMode> {
  ThemeServices() : super(ThemeMode.system) {
    loadFromStorage().then((value) => state = value);
  }

  saveToStorage(ThemeMode theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(theme.toString());
    prefs.setString("theme", theme.toString());
  }

  Future<ThemeMode> loadFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late ThemeMode res;
    if (prefs.containsKey('theme')) {
      String? theme = prefs.getString("theme");
      if (theme == "ThemeMode.system")
        res = ThemeMode.system;
      else if (theme == "ThemeMode.light") res = ThemeMode.light;
      if (theme == "ThemeMode.dark") res = ThemeMode.dark;
    } else {
      res = ThemeMode.system;
    }
    return res;
  }

  changeTheme(ThemeMode newTheme) {
    state = newTheme;
    saveToStorage(state);
  }
}

final themeProvider =
    StateNotifierProvider<ThemeServices, ThemeMode>((ref) => ThemeServices());
