import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Store the theme mode (light or dark)
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Load the saved theme mode from SharedPreferences
  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme_mode');
    if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }

  // Save the theme mode to SharedPreferences
  Future<void> saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', themeMode.value == ThemeMode.dark ? 'dark' : 'light');
  }

  // Toggle the theme between light and dark
  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    saveThemeMode(); // Save the selected theme mode
  }
}
