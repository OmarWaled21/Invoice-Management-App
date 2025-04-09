import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/client/custom_text_field.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankInformation extends StatelessWidget {
  const BankInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    // text controller
    final TextEditingController ibanController = TextEditingController();
    final TextEditingController swiftController = TextEditingController();

    profileController.loadProfileDetails();
    final profile = profileController.profileDetails.value;
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Informations bancaires',
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new_rounded,
        onPressedLeading: () {
          Get.back();
        },
        hasActions: true,
        textAction: 'OK',
        onPressedAction: () async {

          // Save the entered profile details when "OK" is pressed
          final updatedProfile = ProfileModel(
            name: profile.name,
            address: profile.address,
            address2: profile.address2,
            city: profile.city,
            email: profile.email,
            image: profile.image,
            phone: profile.phone,
            postalCode: profile.postalCode,
            siret: profile.siret,
            tvaNumber: profile.tvaNumber,
            country: profile.country,
            iban: ibanController.text.toUpperCase(),
            swift: swiftController.text.toUpperCase(),
          );

          await profileController.saveProfileDetails(updatedProfile);
          Get.back(); // Go back after saving
        },
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: mq.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mq.height * 0.05),
                normalText(text: "Ces informations apparaîtront sur votre rapport de transaction, "
                  "ainsi que sur vos reçus. Ces données vous permettent d'identifier vos coordonnées bancaires. "
                  "Nous vous invitons à contacter le service client si vous souhaitez les modifier."
                  ,hasOverFlow: false, fontSize: mq.aspectRatio * 40,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
                SizedBox(height: mq.height * 0.02),
                Obx(() {
                  ibanController.text = profileController.profileDetails.value.iban ?? '';
                  swiftController.text = profileController.profileDetails.value.swift ?? '';

                  return Column(
                    children: [
                      customTextField(
                        title: 'IBAN:',
                        controller: ibanController,
                        hint: '',
                      ),
                      customTextField(
                        title: 'BIC-ADRESSE SWIFT:',
                        controller: swiftController,
                        hint: '',
                      ),
                    ],
                  );
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
