import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/controller/locale_controller.dart';
import 'package:facturation_intuitive/controller/monthley_summray_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/models/pages_model.dart';
import 'package:facturation_intuitive/screens/clients/clients_screen.dart';
import 'package:facturation_intuitive/screens/devis/creer_en_devis_and_facture.dart';
import 'package:facturation_intuitive/screens/devis/devis_screen.dart';
import 'package:facturation_intuitive/screens/facture/facturation_history_screen.dart';
import 'package:facturation_intuitive/screens/personalization_facture/personalization_screen.dart';
import 'package:facturation_intuitive/screens/profile/profiel_screen.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/list_tile_pages.dart';
import 'package:facturation_intuitive/widgets/month_bar_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final MonthlySummaryController monthlySummaryController = Get.put(MonthlySummaryController());
final FactureController factureController = Get.find<FactureController>();

List<PagesModel> pages = [
  PagesModel(
    route: const FacturationHistoryScreen(),
    icon: Assets.iconsInvoice,
    title: 'invoice',
  ),
  PagesModel(
    route: const DevisScreen(),
    icon: Assets.iconsDevis,
    title: 'quotes',
  ),
  PagesModel(
    route: const ClientsScreen(),
    icon: Assets.iconsClients,
    title: 'clients',
  ),
  PagesModel(
    route: const PersonalizationScreen(),
    icon: Assets.iconsPersonnaliser,
    title: 'customize_invoice',
  ),
];

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();

    if (selectedStartDate == null && selectedEndDate == null) {
      final now = DateTime.now();
      selectedStartDate = DateTime(now.year, 1);
      selectedEndDate = DateTime(now.year, 12);

      // Use addPostFrameCallback for calculations to avoid conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        monthlySummaryController.selectedStartDate.value = selectedStartDate!;
        monthlySummaryController.selectedEndDate.value = selectedEndDate!;
        monthlySummaryController.calculateMonthlyTotals();
      });
    }
  }

  // Method to select start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        monthlySummaryController.selectedStartDate.value = selectedStartDate; // Update controller
        monthlySummaryController.calculateMonthlyTotals(); // Recalculate totals based on new range
      });
    }
  }

  // Method to select end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        monthlySummaryController.selectedEndDate.value = selectedEndDate; // Update controller
        monthlySummaryController.calculateMonthlyTotals(); // Recalculate totals based on new range
      });
    }
  }

  String getLocalizedMonthName(int month, String locale) {
    final now = DateTime.now();
    // Use year/month from input, and arbitrary day (1) to get valid DateTime
    final date = DateTime(now.year, month, 1);
    return DateFormat.MMMM(locale).format(date);
  }

  TextSpan _buildTextSpan() {
    final localeController = Get.find<LocaleController>();
    final currentLocale = localeController.appLocale.value;

    final startText = selectedStartDate != null
        ? "${getLocalizedMonthName(selectedStartDate!.month, currentLocale.languageCode)}/${selectedStartDate!.year}"
        : "select_start".tr;

    final endText = selectedEndDate != null
        ? "${getLocalizedMonthName(selectedEndDate!.month, currentLocale.languageCode)}/${selectedEndDate!.year}"
        : "select_end".tr;

    final themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return TextSpan(
      children: [
        TextSpan(
          text: startText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: selectedStartDate != null ? TextDecoration.underline : null,
            color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
            fontSize: mq.aspectRatio * 40,
            fontFamily: Assets.fontsArial,
          ),
        ),
        TextSpan(
          text: ' - ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
            fontSize: mq.aspectRatio * 40,
            fontFamily: Assets.fontsArial,
          ),
        ),
        TextSpan(
          text: endText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: selectedEndDate != null ? TextDecoration.underline : null,
            color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
            fontSize: mq.aspectRatio * 40,
            fontFamily: Assets.fontsArial,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'invoice'.tr,
        hasLeading: true,
        iconLeading: CupertinoIcons.settings,
        onPressedLeading: () => Get.to(const ProfielScreen(), transition: Transition.fadeIn),
        hasActions: true,
        iconActions: CupertinoIcons.sun_max,
        onPressedAction: () => themeController.toggleTheme(),
        iconActions2: Icons.translate,
        onPressedAction2: () {
          final localeController = Get.find<LocaleController>();
          final currentLocale = localeController.appLocale.value;
          if (currentLocale.languageCode == 'en') {
            localeController.changeLocale('fr', 'FR');
          } else {
            localeController.changeLocale('en', 'US');
          }
        },
      ),
      body: Obx(
        () {
          final isLightTheme = themeController.themeMode.value == ThemeMode.light;
          return Container(
            width: mq.width,
            height: mq.height,
            color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(text: 'period'.tr, color: isLightTheme ? Colors.black : Colors.white),
                    SizedBox(height: mq.height * 0.01),
                    GestureDetector(
                      // ignore: use_build_context_synchronously
                      onTap: () => _selectStartDate(context).then((_) => _selectEndDate(context)),
                      child: RichText(
                        text: _buildTextSpan(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: mq.height * 0.01),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: mq.width * 0.04),
                          // Get the maximum montantTotal dynamically
                          child: Obx(() {
                            double maxTotal = monthlySummaryController.monthlyTotals.values.isEmpty
                                ? 0.0
                                : monthlySummaryController.monthlyTotals.values
                                    .reduce((a, b) => a > b ? a : b);
                            return boldText(
                              text: '${maxTotal.toStringAsFixed(2)} €',
                              color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                            );
                          }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * 0.2,
                      width: mq.width,
                      child: MonthBarChart(),
                    ),
                    ListView.builder(
                      itemCount: pages.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return functionsPages(
                          context,
                          route: page.route,
                          assetsIcon: page.icon,
                          title: page.title.tr,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(
        () {
          final ThemeController themeController = Get.find<ThemeController>();
          final isLightTheme = themeController.themeMode.value == ThemeMode.light;
          return Container(
            color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
            child: bottomButtonInScreen(
              text: 'create_invoice'.tr,
              horizontal: mq.width * 0.1,
              top: mq.height * 0.001,
              bottom: mq.height * 0.05,
              bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
              onPressed: () {
                factureController.clearItems();
                factureController.resetSelectedClient();
                Get.to(
                  () => const CreerUnDevisAndFacture(isDevis: false),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
