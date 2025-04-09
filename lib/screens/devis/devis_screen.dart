import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/devis/creer_en_devis_and_facture.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevisScreen extends StatefulWidget {
  const DevisScreen({super.key});

  @override
  State<DevisScreen> createState() => _DevisScreenState();
}

class _DevisScreenState extends State<DevisScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'quotes'.tr,
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new_rounded,
        onPressedLeading: () {
          Get.back();
        },
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/devis_invoice.png',
                height: mq.height * 0.2,
              ),
            ),
            boldText(
                text: 'create_manage_quotes'.tr,
                fontSize: mq.aspectRatio * 50,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
            boldText(
                text: 'professionnels',
                fontSize: mq.aspectRatio * 50,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
            SizedBox(height: mq.height * 0.01),
            normalText(
                text: 'quote_note'.tr,
                fontSize: mq.aspectRatio * 40,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
            SizedBox(height: mq.height * 0.03),
            SizedBox(
              width: mq.width,
              child: bottomButtonInScreen(
                text: 'create_quote'.tr,
                bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                onPressed: () => Get.off(const CreerUnDevisAndFacture(
                  isDevis: true,
                )),
                horizontal: mq.width * 0.3,
                top: mq.height * 0.005,
                bottom: mq.height * 0.05,
              ),
            )
          ],
        ),
      ),
    );
  }
}
