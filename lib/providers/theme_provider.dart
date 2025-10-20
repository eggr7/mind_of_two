import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  bool get isInitialized => _isInitialized;

  Future<void> _loadThemeMode() async {
    try {
      final savedTheme = StorageService.loadThemeMode();
      _themeMode = _themeModeFromString(savedTheme);
      _isInitialized = true;
      notifyListeners();
      debugPrint("Theme loaded: $savedTheme");
    } catch (e) {
      debugPrint("Error loading theme: $e");
      _themeMode = ThemeMode.light;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
    await StorageService.saveThemeMode(_themeModeToString(_themeMode));
    debugPrint("Theme toggled to: ${_themeModeToString(_themeMode)}");
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await StorageService.saveThemeMode(_themeModeToString(_themeMode));
    debugPrint("Theme set to: ${_themeModeToString(_themeMode)}");
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}

