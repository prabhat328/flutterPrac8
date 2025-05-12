import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final String _themeKey = 'isDarkMode';
  bool _isDarkModeOn = false;
  bool get isDarkModeOn => _isDarkModeOn;

  ThemeService() {
    _loadThemeFromPrefs();
  }

  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkModeOn = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkModeOn = !_isDarkModeOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkModeOn);
    notifyListeners();
  }
}
