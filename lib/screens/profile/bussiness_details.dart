import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/client/custom_text_field.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BussinessDetails extends StatelessWidget {
  const BussinessDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    // Create text controllers
    final nameController = TextEditingController();
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final postalCodeController = TextEditingController();
    final countryController = TextEditingController();
    final tavNumberContriller = TextEditingController();
    final emailController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final siretController = TextEditingController();

    // Load the profile details from shared preferences when the screen is built
    profileController.loadProfileDetails();

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Bussiness details',
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new_rounded,
        onPressedLeading: () => Get.back(),
        hasActions: true,
        textAction: 'OK',
        onPressedAction: () async {
          // Preserve the existing image from profileController
          final currentImage = profileController.profileDetails.value.image;

          // Save the entered profile details when "OK" is pressed
          final updatedProfile = ProfileModel(
            name: nameController.text,
            address: addressLine1Controller.text,
            address2: addressLine2Controller.text,
            city: cityController.text,
            postalCode: postalCodeController.text,
            country: countryController.text,
            tvaNumber: tavNumberContriller.text,
            email: emailController.text,
            phone: phoneNumberController.text,
            siret: siretController.text,
            image: currentImage, // Keep the current image path
          );

          await profileController.saveProfileDetails(updatedProfile);
          Get.back(); // Go back after saving
        },
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
                  "Ces informations apparaîtront sur "
                  "le compte rendu de vos transactions, ainsi que sur les "
                  "récépissés. Ces données permettant "
                  "d'identifier votre entreprise, nous vous invitons "
                  "à contacter le service client si vous souhaitez "
                  "les modifier.",
                  style: TextStyle(fontSize: mq.aspectRatio * 36, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
                ),
                Obx(
                  () {
                    // Load existing data from the controller if available
                    final profileDetails = profileController.profileDetails.value;

                    // Populate text controllers with existing profile details
                    nameController.text = profileDetails.name;
                    addressLine1Controller.text = profileDetails.address;
                    addressLine2Controller.text = profileDetails.address2 ?? '';
                    cityController.text = profileDetails.city ?? '';
                    postalCodeController.text = profileDetails.postalCode ?? '';
                    countryController.text = profileDetails.country;
                    tavNumberContriller.text = profileDetails.tvaNumber ?? '';
                    emailController.text = profileDetails.email ?? '';
                    phoneNumberController.text = profileDetails.phone ?? '';
                    siretController.text = profileDetails.siret ?? '';

                    return Column(
                      children: [
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        customTextField(
                          title: 'Nom de l\'entrepise',
                          controller: nameController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Adresse ligne 1',
                          controller: addressLine1Controller,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Adresse ligne 2',
                          controller: addressLine2Controller,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Ville',
                          controller: cityController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Code de postal',
                          controller: postalCodeController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Siren / Siret',
                          controller: siretController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Pays',
                          controller: countryController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Numéro de TVA (facultatif)',
                          controller: tavNumberContriller,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Email',
                          controller: emailController,
                          hint: '',
                        ),
                        customTextField(
                          title: 'Numéro de téléphone (facultatif)',
                          controller: phoneNumberController,
                          hint: '',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
