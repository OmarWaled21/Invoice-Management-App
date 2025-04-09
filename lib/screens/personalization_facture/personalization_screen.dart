import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/personalization_facture/choose_model.dart';
import 'package:facturation_intuitive/screens/personalization_facture/couleurs_et_polices.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_1.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_2.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  // Widget to show the selected model
  Widget _getSelectedModel(int selectedModel) {
    switch (selectedModel) {
      case 2:
        return const FactureModel2();
      default:
        return const FactureModel1();
    }
  }

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Get the FactureController instance
    final FactureModelController factureController =
        Get.find<FactureModelController>();
    final FactureController factureClear = Get.find<FactureController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Personnaliser la facture',
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new,
        onPressedLeading: () {
          Get.back();
          factureClear.clearItems();
        },
      ),
      body: Obx(() => Container(
            width: mq.width,
            height: mq.height,
            color:
                isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
            child: Column(
              children: [
                InteractiveViewer(
                  key: _globalKey,
                  maxScale: 4.0,
                  child: Center(
                    child: SizedBox(
                      height: mq.height * 0.65,
                      width: mq.width * 0.9,
                      child: Container(
                        margin: EdgeInsets.only(top: mq.height * 0.05),
                        // Adjust padding
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(60),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        // Show the selected facture model based on the controller's selectedModel
                        child: _getSelectedModel(
                            factureController.selectedModel.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: Container(
        width: mq.width,
        height: mq.height * 0.15,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            bottomDesignModel(
              name: 'Modéle',
              assetIcon: Assets.iconsInvoice,
              color: isLightTheme
                  ? ColorsTheme.blackColor
                  : ColorsTheme.orangeColor,
              borderColor: isLightTheme
                  ? ColorsTheme.blackColor.withAlpha(40)
                  : ColorsTheme.orangeColor.withAlpha(80),
              onPressed: () {
                // Navigate to ChooseModel screen
                Get.to(
                  () => const ChooseModel(),
                  transition: Transition.downToUp,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
            bottomDesignModel(
              name: 'Couleurs et polices',
              assetIcon: Assets.iconsPersonnaliser,
              color: isLightTheme
                  ? ColorsTheme.blackColor
                  : ColorsTheme.orangeColor,
              borderColor: isLightTheme
                  ? ColorsTheme.blackColor.withAlpha(40)
                  : ColorsTheme.orangeColor.withAlpha(80),
              onPressed: () => Get.to(const CouleursEtPolices(),
                  transition: Transition.downToUp),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomDesignModel({
    required String name,
    required String assetIcon,
    required VoidCallback onPressed,
    required borderColor,
    required color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(mq.aspectRatio * 30),
            margin: EdgeInsets.only(bottom: mq.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Image.asset(
              assetIcon,
              height: mq.aspectRatio * 80,
              isAntiAlias: true,
              color: color,
            ),
          ),
        ),
        normalText(text: name, fontSize: mq.aspectRatio * 40, color: color),
      ],
    );
  }
}
