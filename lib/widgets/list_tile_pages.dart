import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget functionsPages(BuildContext context,
    {required Widget route, required String assetsIcon, required String title}) {
  final ThemeController themeController = Get.find<ThemeController>();
  final isLightTheme = themeController.themeMode.value == ThemeMode.light;
  return InkWell(
    onTap: () => Get.to(() => route),
    child: ListTile(
      leading: Image.asset(
        assetsIcon,
        height: mq.aspectRatio * 70,
        color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
      ),
      title: normalText(
        text: title,
        fontSize: mq.aspectRatio * 40,
        color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.orangeColor.withAlpha(150),),
    ),
  );
}