import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_1.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_2.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseModel extends StatelessWidget {
  const ChooseModel({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the FactureController instance
    final factureController = Get.find<FactureModelController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return PopScope(
      onPopInvokedWithResult: (val, dynamic) async {
        await factureController.resetToSavedModel();
      },
      child: Scaffold(
        appBar: DefaultAppbar(
          title: 'model'.tr,
          hasLeading: true,
          onPressedLeading: () async {
            // Reset to the saved model before going back
            await factureController.resetToSavedModel();
            Get.back();
          },
          textLeading: 'close'.tr,
          hasActions: true,
          onPressedAction: () {
            // Save the selected model when "Appliquer" is pressed
            factureController.saveSelectedModel();
            Get.back();
          },
          textAction: 'apply'.tr,
        ),
        body: Container(
          width: mq.width,
          height: mq.height,
          color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'select_template_note'.tr,
                    style: TextStyle(
                        fontSize: mq.aspectRatio * 40,
                        color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
                  ),
                  SizedBox(height: mq.height * 0.01),
                  Column(
                    children: [
                      Center(
                        child: _buildModelOption(
                          context,
                          '${'invoice'.tr} Model 1',
                          const FactureModel1(),
                          1,
                          factureController,
                        ),
                      ),
                      _buildModelOption(
                        context,
                        '${'invoice'.tr} Model 2',
                        const FactureModel2(),
                        2,
                        factureController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModelOption(BuildContext context, String label, Widget model, int modelId,
      FactureModelController factureController) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return GestureDetector(
      onTap: () => factureController.setSelectedModel(modelId),
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(bottom: mq.height * 0.05),
          decoration: BoxDecoration(
            border: Border.all(
                color: factureController.selectedModel.value == modelId
                    ? isLightTheme
                        ? ColorsTheme.blackColor
                        : ColorsTheme.orangeColor
                    : isLightTheme
                        ? ColorsTheme.blackColor.withAlpha(30)
                        : ColorsTheme.orangeColor.withAlpha(60),
                width: 2),
            borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
          ),
          width: mq.width * 0.5,
          height: mq.height * 0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
            child: model,
          ),
        ),
      ),
    );
  }
}
