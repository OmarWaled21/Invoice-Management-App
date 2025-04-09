import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormatDuPrix extends StatelessWidget {
  const FormatDuPrix({super.key});

  @override
  Widget build(BuildContext context) {
    final FactureController factureController = Get.find<FactureController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'price_format'.tr,
        hasLeading: true,
        onPressedLeading: () => Get.back(),
        iconLeading: Icons.arrow_back_ios_new_rounded,
        hasActions: true,
        onPressedAction: () async {
          await factureController.saveSelectedPriceFormat();
          Get.back();
        },
        textAction: 'OK',
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.04),
        child: Column(
          children: [
            normalText(
                text: "price_note".tr,
                fontSize: mq.aspectRatio * 35,
                hasOverFlow: false,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
            Obx(
              () => _buildChoosingPrice(
                  onTap: factureController.selectPrixHT,
                  title: "${'price'.tr} HT",
                  value: 'price_no_tax'.tr,
                  isSelected: factureController.isPrixHTSelected.value,
                  color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  borderColor: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor),
            ),
            Obx(
              () => _buildChoosingPrice(
                  onTap: factureController.selectPrixTTC,
                  title: "${'price'.tr} TTC",
                  value: 'price_with_tax'.tr,
                  isSelected: factureController.isPrixTTCSelected.value,
                  color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  borderColor: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoosingPrice({
    required VoidCallback onTap,
    required String title,
    required String value,
    required bool isSelected,
    required Color color,
    required Color borderColor,
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: mq.width,
        margin: EdgeInsets.symmetric(vertical: mq.height * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: !isSelected ? Colors.grey.shade400 : borderColor),
          borderRadius: BorderRadius.circular(mq.aspectRatio * 40),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
          child: Column(
            children: [
              boldText(text: title, color: color),
              normalText(text: value, fontSize: mq.aspectRatio * 30, color: color)
            ],
          ),
        ),
      ),
    );
  }
}
