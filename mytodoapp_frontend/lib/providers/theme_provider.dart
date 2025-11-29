import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/services/theme_service.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  String _currentTheme = 'Blue';

  String get currentTheme => _currentTheme;

  Color get accentColor => ThemeService.getColorFromName(_currentTheme);

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _currentTheme = await _themeService.getThemeColor();
    // Update the global AppColor
    AppColor.updateAccentColor(ThemeService.getColorFromName(_currentTheme));
    notifyListeners();
  }

  Future<void> setTheme(String colorName) async {
    _currentTheme = colorName;
    await _themeService.saveThemeColor(colorName);
    // Update the global AppColor
    AppColor.updateAccentColor(ThemeService.getColorFromName(colorName));
    notifyListeners();
  }
}
