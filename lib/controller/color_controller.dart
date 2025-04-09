import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorController extends GetxController {
  // Default colors (initial values)
  var policeColor = Colors.black.obs; // Police (text) color
  var marqueColor = const Color(0xFFFF5722).obs; // Marque (brand) color (deepOrangeAccent)

  static const String policeColorKey = 'police_color'; // Key for police color
  static const String marqueColorKey = 'marque_color'; // Key for marque color

  // Font settings
  var selectedFontFamily = 'Courier New'.obs; // Default font family
  static const String fontFamilyKey = 'font_family'; // Key for font family


  @override
  void onInit() {
    super.onInit();
    loadSavedColors(); // Load saved colors when the controller is initialized
  }

  // Method to change police color and save it
  void changePoliceColor(Color color) async {
    policeColor.value = color;
    await saveColor(policeColorKey, color); // Save to SharedPreferences
  }

  // Method to change marque color and save it
  void changeMarqueColor(Color color) async {
    marqueColor.value = color;
    await saveColor(marqueColorKey, color); // Save to SharedPreferences
  }

  // Method to change font family and save it
  void changeFontFamily(String fontFamily) async {
    selectedFontFamily.value = fontFamily;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fontFamilyKey, fontFamily); // Save selected font family
  }

  // Save color to SharedPreferences
  Future<void> saveColor(String key, Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = color.value;
    await prefs.setInt(key, colorValue); // Save color as an integer
  }

  // Save font family to SharedPreferences
  Future<void> saveFontFamily(String fontFamily) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fontFamilyKey, fontFamily); // Save selected font family
  }

  // Load saved colors from SharedPreferences
  Future<void> loadSavedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load saved police color
    int? savedPoliceColor = prefs.getInt(policeColorKey);
    if (savedPoliceColor != null) {
      policeColor.value = Color(savedPoliceColor);
    }

    // Load saved marque color
    int? savedMarqueColor = prefs.getInt(marqueColorKey);
    if (savedMarqueColor != null) {
      marqueColor.value = Color(savedMarqueColor);
    }

    // Load saved font family
    String? savedFontFamily = prefs.getString(fontFamilyKey);
    if (savedFontFamily != null) {
      selectedFontFamily.value = savedFontFamily;
    }
  }
}
