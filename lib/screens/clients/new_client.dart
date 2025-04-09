import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:facturation_intuitive/controller/clients_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/contacts_model.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/client/custom_text_field.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewClient extends StatefulWidget {
  final List<ContactsModel> clientsList;
  final ContactsModel? existingClient; // The client to modify, if provided

  const NewClient({super.key, required this.clientsList, this.existingClient});

  @override
  State<NewClient> createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  final ClientsController clientsController = Get.find<ClientsController>();

  // Keeps track of the selected index for client type
  int _selectedIndex = 0;
  String selectedCountry = 'France'; // Default country
  int lastClientId = 0; // Variable to hold the last client ID

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController tvaNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If there is an existing client, populate the fields with its data
    if (widget.existingClient != null) {
      _populateFields(widget.existingClient!);
    }
  }

  // Function to populate fields with existing client data
  void _populateFields(ContactsModel client) {
    nameController.text = client.name;
    addressController.text = client.address;
    address2Controller.text = client.address2 ?? '';
    cityController.text = client.city ?? '';
    postCodeController.text = client.postalCode.toString();
    tvaNumberController.text = client.tvaNumber ?? '';
    emailController.text = client.email ?? '';
    phoneController.text = client.phone.toString();
    noteController.text = client.note ?? '';
    _selectedIndex = options.indexOf(client.clientType);
    selectedCountry = client.country; // Set the existing client's country
  }

  // List of options to display
  final List<String> options = ["private_company".tr, "particular".tr, "public_admin".tr];

  // Widget for building selectable containers
  Widget _buildSelectableContainer(int index, String text) {
    bool isSelected = _selectedIndex == index;
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: isSelected
              ? isLightTheme
                  ? ColorsTheme.blackColor.withAlpha(20)
                  : ColorsTheme.whiteColor.withAlpha(20)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? isLightTheme
                    ? ColorsTheme.blackColor
                    : ColorsTheme.orangeColor
                : isLightTheme
                    ? ColorsTheme.lightGreyColor
                    : ColorsTheme.darkGreyColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: normalText(
              text: text,
              fontSize: mq.aspectRatio * 45,
              color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
        ),
      ),
    );
  }

  // Function to create a ContactsModel from the input fields
  ContactsModel _createContact() {
    // Generate an ID for the new client if we are not editing an existing one
    int id = widget.existingClient != null
        ? widget.existingClient!.id // Keep the existing ID if we're modifying
        : clientsController.getNextClientId(); // Use the next available ID for a new client

    return ContactsModel(
        id: id, // Assign the ID here
        name: nameController.text,
        address: addressController.text,
        address2: address2Controller.text,
        city: cityController.text,
        postalCode: int.tryParse(postCodeController.text) ?? 0,
        tvaNumber: tvaNumberController.text,
        email: emailController.text,
        phone: int.tryParse(phoneController.text) ?? 0,
        note: noteController.text,
        clientType: options[_selectedIndex],
        country: selectedCountry);
  }

  // Add or update client based on whether we're editing or creating a new one
  void _saveClient() {
    if (nameController.text.isEmpty || addressController.text.isEmpty) {
      // Show an error message
      Get.snackbar('Error', 'Name and Address are required.');
      return;
    }

    ContactsModel newClient = _createContact();
    log("New client details: ${newClient.toJson()}"); // Add this line

    if (widget.existingClient != null) {
      // We are modifying an existing client
      int index = clientsController.clients.indexWhere(
        (client) => client.name == widget.existingClient!.name,
      );

      if (index != -1) {
        clientsController.clients[index] = newClient; // Update the client in the controller's list
        clientsController.saveClients(); // Persist the updated list
        log("Client updated: ${newClient.name}, ${newClient.clientType}");
      }
    } else {
      // Create a new client
      clientsController.addClient(newClient);
      log("Client added: ${newClient.name}, ${newClient.clientType}");
    }

    // After adding, log the updated clients list
    log("Current clients list: ${clientsController.clients}");

    // Clear the form after adding or updating
    _clearForm();
    // Navigate back to the clients screen
    Get.back();
    Get.back();
  }

  // Clear the form for new entries
  void _clearForm() {
    nameController.clear();
    addressController.clear();
    address2Controller.clear();
    cityController.clear();
    postCodeController.clear();
    tvaNumberController.clear();
    emailController.clear();
    phoneController.clear();
    noteController.clear();
    _selectedIndex = 0; // Reset client type selection
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: widget.existingClient != null ? 'edit_customer'.tr : 'add_customer'.tr,
        hasLeading: true,
        textLeading: 'cancel'.tr,
        onPressedLeading: () {
          Get.back();
        },
        hasActions: true,
        textAction: 'OK',
        onPressedAction: _saveClient,
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              normalText(
                  text: 'customer_type_selection'.tr,
                  fontSize: mq.aspectRatio * 40,
                  color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
              ...List.generate(
                options.length,
                (index) => _buildSelectableContainer(index, options[index]),
              ),
              SizedBox(height: mq.height * 0.01),
              customTextField(
                title: 'name'.tr,
                controller: nameController,
                hint: '${'name'.tr} officiel',
              ),
              customTextField(
                title: '${'address_line'.tr} 1',
                controller: addressController,
                hint: 'address_line'.tr,
              ),
              customTextField(
                title: '${'address_line'.tr} 2 (${'optional'.tr})',
                controller: address2Controller,
                hint: 'apartment_building_floor'.tr,
              ),
              customTextField(
                title: '${'city'.tr} (${'optional'.tr})',
                controller: cityController,
                hint: 'city'.tr,
              ),
              customTextField(
                title: '${'postal_code'.tr} (${'optional'.tr})',
                keyboardType: TextInputType.number,
                controller: postCodeController,
                hint: '75008',
              ),
              // TODO: Add country input here
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  normalText(
                    text: 'country'.tr,
                    fontSize: mq.aspectRatio * 40,
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  ),
                  Container(
                    width: mq.width,
                    margin: EdgeInsets.only(bottom: mq.height * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
                      border: Border.all(
                          color: isLightTheme
                              ? ColorsTheme.lightGreyColor
                              : ColorsTheme.darkGreyColor),
                    ),
                    child: CountryCodePicker(
                      initialSelection: selectedCountry, // Default to France
                      showCountryOnly: true,
                      showDropDownButton: true,
                      showFlagDialog: true,
                      showOnlyCountryWhenClosed: true,
                      alignLeft: true,
                      textStyle: TextStyle(
                          color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                          fontSize: mq.aspectRatio * 40,
                          fontFamily: Assets.fontsArial),
                      showFlag: false,
                      barrierColor: isLightTheme
                          ? ColorsTheme.whiteColor.withAlpha(150)
                          : ColorsTheme.blackColor.withAlpha(150),
                      dialogBackgroundColor:
                          isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.darkGreyColor,
                      dialogTextStyle: TextStyle(
                          color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                      onChanged: (CountryCode countryCode) {
                        setState(() {
                          selectedCountry = countryCode.name ?? 'France'; // Store selected country
                        });
                      },
                      searchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.01),
                        hintText: 'country'.tr,
                        hintStyle: TextStyle(
                          color: isLightTheme
                              ? ColorsTheme.blueColor
                              : ColorsTheme.orangeColor.withAlpha(150),
                          fontSize: mq.aspectRatio * 40,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(mq.aspectRatio * 30),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black.withAlpha(10),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                          size: mq.aspectRatio * 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              customTextField(
                title: '${'tva_num'.tr}(${'optional'.tr})',
                controller: tvaNumberController,
                hint: 'FR00111111111',
              ),
              customTextField(
                title: 'Email (${'optional'.tr})',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hint: 'email@example.fr',
              ),
              customTextField(
                title: '${'phone_number'.tr} (${'optional'.tr})',
                keyboardType: TextInputType.phone,
                controller: phoneController,
                hint: '+33 123456789',
              ),
              customTextField(
                title: '${'notes'.tr} (${'optional'.tr})',
                controller: noteController,
                maxLines: 3,
                hint: 'notes'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
