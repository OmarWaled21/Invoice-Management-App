import 'dart:developer';

import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/controller/monthley_summray_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/devis/creer_en_devis_and_facture.dart';
import 'package:facturation_intuitive/screens/facture/facture_history_details.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class FacturationHistoryScreen extends StatefulWidget {
  const FacturationHistoryScreen({super.key});

  @override
  State<FacturationHistoryScreen> createState() => _FacturationHistoryScreenState();
}

class _FacturationHistoryScreenState extends State<FacturationHistoryScreen> {
  final FactureController factureController = Get.put(FactureController());
  final MonthlySummaryController monthlySummaryController = Get.put(MonthlySummaryController());

  FormattedDate formattedDate = FormattedDate(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Refresh data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call the method to refresh the facture history here
      factureController.loadFactureHistory().then((_) {
        // After loading, calculate monthly totals
        monthlySummaryController.calculateMonthlyTotals();
      });
    });
  }

  Future<void> _selectMonthYear() async {
    final DateTime? pickedDate = await showMonthYearPicker(
      context: context,
      initialDate: formattedDate.dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Get.locale, // Set locale to French
    );

    if (pickedDate != null) {
      setState(() {
        formattedDate = FormattedDate(DateTime(pickedDate.year, pickedDate.month));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double monthlyTotal =
        monthlySummaryController.getMonthlyTotalForDate(formattedDate.dateTime);
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'all_invoices'.tr,
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new_rounded,
        onPressedLeading: () {
          Get.back();
        },
        hasActions: true,
        textAction: 'delete',
        onPressedAction: () => factureController.clearFactureDetails(),
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _selectMonthYear,
                  child: boldText(
                    text: DateFormat('MMMM yyyy', 'fr').format(formattedDate.dateTime),
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                  ),
                ),
                boldText(
                    text: "${'tot_month'.tr}: ${monthlyTotal.toStringAsFixed(2)} €",
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                const Divider(),
                Obx(() {
                  // Filter invoices for the selected month and year
                  final filteredFactures = factureController.factureHistory.where((facture) {
                    final factureDate = facture.dateEmission; // Assuming dateEmission is a DateTime
                    return factureDate.year == formattedDate.dateTime.year &&
                        factureDate.month == formattedDate.dateTime.month;
                  }).toList();

                  // Check if filteredFactures is empty
                  if (filteredFactures.isEmpty) {
                    return Center(
                        child: boldText(
                            text: "no_invoice".tr,
                            color:
                                isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor));
                  }

                  log("Filtering for: ${formattedDate.dateTime.year}-${formattedDate.dateTime.month}");

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredFactures.length, // Use filteredFactures length here
                    reverse: true,
                    itemBuilder: (context, index) {
                      final factures =
                          filteredFactures[index]; // Get the facture from filteredFactures
                      return GestureDetector(
                        onTap: () => Get.to(() => FactureHistoryDetails(facture: factures)),
                        child: SizedBox(
                          width: mq.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      boldText(
                                          text: factures.invoiceNumber,
                                          fontSize: mq.aspectRatio * 40,
                                          color: isLightTheme
                                              ? ColorsTheme.blackColor
                                              : ColorsTheme.whiteColor),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: mq.width * 0.04, right: mq.width * 0.07),
                                        constraints: BoxConstraints(
                                          maxWidth: mq.width * 0.53,
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: mq.width * 0.37,
                                          ),
                                          child: normalText(
                                              text: factures.clientDetails!.name.toUpperCase(),
                                              fontSize: mq.aspectRatio * 40,
                                              color: isLightTheme
                                                  ? ColorsTheme.blackColor
                                                  : ColorsTheme.whiteColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  boldText(
                                      text: "${factures.montantTotal.toStringAsFixed(2)} €",
                                      fontSize: mq.aspectRatio * 45,
                                      color: isLightTheme
                                          ? ColorsTheme.blackColor
                                          : ColorsTheme.whiteColor),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: mq.aspectRatio * 10,
                                    height: mq.aspectRatio * 10,
                                    decoration: BoxDecoration(
                                      color: isLightTheme
                                          ? ColorsTheme.darkGreyColor
                                          : ColorsTheme.lightGreyColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: mq.width * 0.02),
                                  thinText(
                                      text: FormattedDate(factures.dateEmission)
                                          .formattedDayShortMonth,
                                      fontSize: mq.aspectRatio * 40,
                                      color: isLightTheme
                                          ? ColorsTheme.darkGreyColor
                                          : ColorsTheme.lightGreyColor),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: mq.width,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: bottomButtonInScreen(
          text: 'create_invoice'.tr,
          bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
          horizontal: mq.width * 0.1,
          top: mq.height * 0.005,
          bottom: mq.height * 0.05,
          onPressed: () => Get.to(() => const CreerUnDevisAndFacture(isDevis: false)),
        ),
      ),
    );
  }
}
