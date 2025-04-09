import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/clients_controller.dart';
import 'package:facturation_intuitive/controller/color_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/controller/locale_controller.dart';
import 'package:facturation_intuitive/controller/monthley_summray_controller.dart';
import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/screens/splash_screen.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Load language from SharedPreferences BEFORE anything else
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('lang_code') ?? 'en'; // fallback to English

  // Step 2: Initialize date formatting based on saved language
  await initializeDateFormatting(langCode, null);
  // Initialize the GetX Controller
  Get.put(LocaleController());
  Get.put(ClientsController());
  Get.lazyPut(() => FactureModelController(), fenix: true);
  Get.put(ProfileController());
  Get.put(FactureController());
  Get.put(ColorController());
  Get.put(MonthlySummaryController());
  // Initialize the GetX controller
  final themeController = Get.put(ThemeController());
  // Load the saved theme mode (if any)
  await themeController.loadThemeMode();
  runApp(FacturationIntuitive());
}

class FacturationIntuitive extends StatelessWidget {
  FacturationIntuitive({super.key});

  // This widget is the root of your application.
  final ThemeController themeController = Get.put(ThemeController());
  final LocaleController localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Obx(
      () => GetMaterialApp(
        translations: AppTranslations(),
        locale: localeController.appLocale.value, // Set default locale to French
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        themeMode: themeController.themeMode.value,
        title: 'Facturation Intuitive',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
