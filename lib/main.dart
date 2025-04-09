import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/clients_controller.dart';
import 'package:facturation_intuitive/controller/color_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/controller/monthley_summray_controller.dart';
import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/screens/splash_screen.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';


late Size mq;

void main() async{
  await initializeDateFormatting('fr', null); // Initialize French locale data
  // Initialize the GetX Controller
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
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Obx(() => GetMaterialApp(
        locale: const Locale('fr', 'FR'), // Set default locale to French
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
