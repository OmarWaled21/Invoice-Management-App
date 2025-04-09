import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../controller/color_controller.dart';

class ColorPickerPage extends StatelessWidget {
  final ColorController colorController = Get.find<ColorController>();

  // Variable to track whether we are updating the police or marque color
  final bool isForPolice;

  ColorPickerPage({super.key, required this.isForPolice});

  @override
  Widget build(BuildContext context) {
    Color currentColor =
        isForPolice ? colorController.policeColor.value : colorController.marqueColor.value;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'font_color'.tr,
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new,
        onPressedLeading: () => Get.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Color picker widget
            Expanded(
              child: MaterialPicker(
                pickerColor: currentColor,
                onColorChanged: (Color color) {
                  // Update either police or marque color based on the page's purpose
                  if (isForPolice) {
                    colorController.changePoliceColor(color); // Update and save police color
                  } else {
                    colorController.changeMarqueColor(color); // Update and save marque color
                  }
                },
              ),
            ),
            // Button to confirm color selection
            ElevatedButton(
              onPressed: () {
                Get.back(); // Close the color picker page
              },
              child: Text('confirm'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
