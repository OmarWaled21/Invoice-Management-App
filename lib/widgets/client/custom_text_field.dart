import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customTextField({
  required String title,
  required TextEditingController controller,
  String hint = '',
  bool enabled = true,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  FocusNode? focusNode,
  Function(String) ? onChanged,
}) {
  final ThemeController themeController = Get.find<ThemeController>();
  final isLightTheme = themeController.themeMode.value == ThemeMode.light;

  return Padding(
    padding: EdgeInsets.only(bottom: mq.height * 0.03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalText(text: title, fontSize: mq.aspectRatio * 40, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
        TextFormField(
          onChanged: onChanged,
          enabled: enabled,
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(mq.width * 0.05, mq.height * 0.01, mq.width * 0.05, mq.height * 0.01),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
              borderSide: BorderSide(color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.darkGreyColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
              borderSide: BorderSide(color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.darkGreyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
              borderSide: BorderSide(color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.lightGreyColor, width: 2),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.orangeColor.withAlpha(100),
              fontFamily: Assets.fontsArial),
          ),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: mq.aspectRatio * 40,
            color: isLightTheme? ColorsTheme.blackColor : ColorsTheme.whiteColor,
          ),
        ),
      ],
    ),
  );
}
