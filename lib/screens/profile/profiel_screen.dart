import 'dart:developer';
import 'dart:io';
import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/profile/bank_information.dart';
import 'package:facturation_intuitive/screens/profile/bussiness_details.dart';
import 'package:facturation_intuitive/screens/profile/tva_screen.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/information_widget.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker

class ProfielScreen extends StatefulWidget {
  const ProfielScreen({super.key});

  @override
  State<ProfielScreen> createState() => _ProfielScreenState();
}

final ProfileController profileController = Get.find<ProfileController>();

String getInitials(String fullName) {
  if (fullName.isEmpty) return 'N/A'; // Return 'N/A' or a default value if the name is empty

  List<String> words = fullName.split(' ');
  String initials = '';

  // Safely get initials from the name parts
  if (words.isNotEmpty) {
    initials += words[0][0].toUpperCase(); // First letter of the first word
  }
  if (words.length > 1) {
    initials += words[1][0].toUpperCase(); // First letter of the second word, if it exists
  }
  return initials;
}

class _ProfielScreenState extends State<ProfielScreen> {
  // Create an instance of ImagePicker
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileController.loadProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'settings'.tr,
        hasLeading: true,
        onPressedLeading: () {
          Get.back(closeOverlays: true);
        },
        iconLeading: Icons.arrow_back_ios_new,
        hasActions: true,
        textAction: 'OK',
        onPressedAction: () {
          Get.back(closeOverlays: true);
        },
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: mq.height * 0.05),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() {
                        final profile = profileController.profileDetails.value;
                        final initials = getInitials(profile.name);

                        return GestureDetector(
                          onTap: () => _showImageOptions(),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent.withAlpha(40),
                            radius: mq.aspectRatio * 80,
                            child: profile.image != null &&
                                    profile.image!.isNotEmpty &&
                                    File(profile.image!).existsSync()
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(mq.aspectRatio * 80),
                                    // Make sure the border radius matches CircleAvatar
                                    child: Image.file(
                                      File(profile.image!),
                                      width: mq.width,
                                      height: mq.height,
                                      fit: BoxFit
                                          .cover, // This ensures the image covers the CircleAvatar completely
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(top: mq.height * 0.015),
                                    child: boldText(
                                      text: initials.isNotEmpty ? initials : 'N/A',
                                      fontSize: mq.aspectRatio * 100,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      }),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: CircleAvatar(
                          radius: mq.aspectRatio * 40,
                          backgroundColor:
                              isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.darkGreyColor,
                          child: Image.asset(
                            Assets.iconsNewImage,
                            height: mq.height * 0.03,
                            color: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.01),
                  child: Obx(() {
                    final profile = profileController.profileDetails.value;
                    return normalText(
                      text: profile.name.isNotEmpty ? profile.name : 'company_name',
                      fontSize: mq.aspectRatio * 50,
                      color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: mq.height * 0.01),
                  child: Obx(() {
                    final profile = profileController.profileDetails.value;
                    String address = profile.address;
                    return normalText(
                      text: address.isNotEmpty ? address : 'company_address'.tr,
                      fontSize: mq.aspectRatio * 40,
                      color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: mq.height * 0.02),
                  child: const Divider(),
                ),
                informationProfile(
                  title: 'professional_information'.tr,
                  text: 'Business details',
                  iconAsset: Assets.iconsBussinessCase,
                  onTap: () => Get.to(const BussinessDetails()),
                  secText: 'bank_information'.tr,
                  secIconAsset: Assets.iconsBank,
                  secOnTap: () => Get.to(const BankInformation()),
                  txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  iconColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                informationProfile(
                  title: 'tva_and_registration'.tr,
                  onTap: () => Get.to(const TvaScreen()),
                  text: 'tva_and_registration'.tr,
                  iconAsset: Assets.iconsTvaCer,
                  txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  iconColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final ThemeController themeController = Get.find<ThemeController>();
        final isLightTheme = themeController.themeMode.value == ThemeMode.light;

        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor,
                ),
                title: boldText(
                    text: 'choose_image'.tr,
                    color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor),
                onTap: () async {
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    // Update image path in the controller
                    profileController.profileDetails.value.image = pickedFile.path;

                    // Notify listeners
                    profileController.updateProfileDetails(profileController.profileDetails.value);

                    // Optionally, save the profile details after updating the image
                    await profileController
                        .saveProfileDetails(profileController.profileDetails.value);
                    log("Image selected: ${pickedFile.path}"); // Debug log
                  } else {
                    log("No image selected"); // Debug log
                  }
                  Get.back(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor,
                ),
                title: boldText(
                    text: 'delete_image'.tr,
                    color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor),
                onTap: () {
                  profileController.profileDetails.value.image = '';
                  // Save the updated profile details after deleting the image
                  profileController.saveProfileDetails(profileController.profileDetails.value);
                  Get.back(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor,
                ),
                title: boldText(
                    text: 'cancel'.tr,
                    color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor),
                onTap: () {
                  Get.back(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
