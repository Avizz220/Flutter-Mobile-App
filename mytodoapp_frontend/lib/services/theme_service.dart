import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'selected_theme_color';
  static const String _themeModeKey = 'theme_mode';

  // Available theme colors
  static final Map<String, Color> themeColors = {
    'Blue': Colors.blue,
    'Purple': Colors.purple,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Pink': Colors.pink,
    'Teal': Colors.teal,
    'Red': Colors.red,
    'Indigo': Colors.indigo,
  };

  // Save selected theme color
  Future<void> saveThemeColor(String colorName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, colorName);
  }

  // Get selected theme color
  Future<String> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'Blue';
  }

  // Get color from name
  static Color getColorFromName(String colorName) {
    return themeColors[colorName] ?? Colors.blue;
  }

  // Save theme mode (light/dark)
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  // Get theme mode
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false; // Default is light mode
  }
}
