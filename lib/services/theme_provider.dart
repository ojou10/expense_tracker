import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class uses ChangeNotifier 
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Load the saved theme when the app starts
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners(); // Tells the app to update!
  }

  // Save the theme and update the app
  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    _isDarkMode = value;
    notifyListeners(); // Tells the app to update!
  }
}