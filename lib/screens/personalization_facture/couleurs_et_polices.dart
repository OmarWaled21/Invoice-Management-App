import 'package:facturation_intuitive/controller/color_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/personalization_facture/color_picker.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouleursEtPolices extends StatefulWidget {
  const CouleursEtPolices({super.key});

  @override
  State<CouleursEtPolices> createState() => _CouleursEtPolicesState();
}

class _CouleursEtPolicesState extends State<CouleursEtPolices> {
  final ColorController colorController = Get.put(ColorController());

  // List of available font families
  final List<String> _fontFamilies = ['Courier New', 'Arial', 'Roboto', 'Times New Roman', 'Verdana'];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Couleurs et polices',
        hasLeading: true,
        textLeading: 'Fermer',
        onPressedLeading: () => Get.back(),
        hasActions: true,
        textAction: 'Appliquer',
        onPressedAction: () => Get.back(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: mq.height * 0.02, horizontal: mq.width * 0.05),
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            normalText(
              text: 'Choisissez les couleurs et polices de votre modèle',
              fontSize: mq.aspectRatio * 40,
              hasOverFlow: false,
              color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: mq.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldText(text: 'Couleur de la police', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                  GestureDetector(
                    onTap: () => Get.to(() => ColorPickerPage(isForPolice: true,), transition: Transition.downToUp),
                    child: Obx(() => Container(
                      width: mq.aspectRatio * 100,
                      height: mq.aspectRatio * 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
                        border: Border.all(color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                        color: colorController.policeColor.value, // Bind color
                      ),
                    )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mq.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldText(text: 'Couleur de la marque', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                  GestureDetector(
                    onTap: () => Get.to(() => ColorPickerPage(isForPolice: false,)),
                    child: Obx(() => Container(
                      width: mq.aspectRatio * 100,
                      height: mq.aspectRatio * 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
                        border: Border.all(color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                        color: colorController.marqueColor.value, // Bind color
                      ),
                    )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mq.height * 0.05),
              child: boldText(text: 'Type de police', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
            ),
            // Font type dropdown
            Padding(
              padding: EdgeInsets.only(top: mq.height * 0.02),
              child: Container(
                padding: EdgeInsets.all(mq.aspectRatio * 30),
                decoration: BoxDecoration(
                  border: Border.all(color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor),
                  borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
                ),
                child: Obx(() => DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  dropdownColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
                  value: colorController.selectedFontFamily.value, // Bind font family
                  icon: Icon(Icons.keyboard_arrow_down, color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                    fontSize: mq.aspectRatio * 40),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    colorController.changeFontFamily(newValue!); // Update font family in controller
                  },
                  items: _fontFamilies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
