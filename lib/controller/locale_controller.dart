import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  Rx<Locale> appLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    loadLocale(); // Load saved locale on startup
  }

  void changeLocale(String languageCode, String countryCode) async {
    final locale = Locale(languageCode, countryCode);
    appLocale.value = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang_code', languageCode);
    await prefs.setString('country_code', countryCode);

    Get.updateLocale(locale);
  }

  void loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('lang_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';

    appLocale.value = Locale(langCode, countryCode);
    Get.updateLocale(appLocale.value);
  }
}
