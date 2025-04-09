import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/controller/tva_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/container_2lines.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/default_appbar.dart';

class TvaScreen extends StatefulWidget {
  const TvaScreen({super.key});

  @override
  State<TvaScreen> createState() => _TvaScreenState();
}

class _TvaScreenState extends State<TvaScreen> {
  final TvaController tvaController = Get.put(TvaController()); // Initialize controller
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    profileController.loadProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = profileController.profileDetails.value;

    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'tva_and_registration'.tr,
        hasLeading: true,
        onPressedLeading: () {
          Get.back(closeOverlays: true);
        },
        iconLeading: Icons.arrow_back_ios_new,
        hasActions: true,
        textAction: 'OK',
        // Save the switch value when "OK" is pressed
        onPressedAction: () {
          tvaController.saveSwitchState(); // Save the current switch value to SharedPreferences
          Get.back(); // Navigate back after saving
        },
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.height * 0.05),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
                width: mq.width,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    color: isLightTheme
                        ? ColorsTheme.blackColor.withAlpha(20)
                        : ColorsTheme.orangeColor.withAlpha(60),
                  )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    normalText(
                      text: '${'apply'.tr} TVA',
                      fontSize: mq.aspectRatio * 40,
                      color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                    ),
                    Obx(
                      () => Switch(
                        value: tvaController.switchTVA.value,
                        activeColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                        onChanged: (val) => tvaController.switchTVA.value = val,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                child: thinText(
                  text: 'change_tva_desc'.tr,
                  fontSize: mq.aspectRatio * 35,
                  color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,
                ),
              ),
              SizedBox(height: mq.height * 0.02),
              container2Lines(
                  leftText: "regestiration_num".tr,
                  rightText: profile.siret ?? '',
                  isExpanded: true,
                  leftColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  rightColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
              container2Lines(
                  leftText: "tva_num_intra".tr,
                  rightText: profile.country,
                  isExpanded: true,
                  leftColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  rightColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
              container2Lines(
                  leftText: "trade_number".tr,
                  rightText: 'HRB 123456',
                  isExpanded: true,
                  leftColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  rightColor: isLightTheme
                      ? ColorsTheme.blackColor.withAlpha(50)
                      : ColorsTheme.orangeColor.withAlpha(150)),
            ],
          ),
        ),
      ),
    );
  }
}
