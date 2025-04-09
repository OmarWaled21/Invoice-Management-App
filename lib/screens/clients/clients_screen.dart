import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:facturation_intuitive/controller/clients_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/screens/clients/new_client.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/client/no_client.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:get/get.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/contacts_model.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final RxList<ContactsModel> _contacts = <ContactsModel>[].obs;
  Map<String, List<ContactsModel>> _groupedContacts = SplayTreeMap();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final ClientsController clientsController = Get.find<ClientsController>();
  late final StreamSubscription _clientSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSearchListener();
    _initializeClientListener();
  }

  void _initializeSearchListener() {
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
      _filterContacts();
    });
  }

  void _initializeClientListener() {
    ever(clientsController.clients, _groupContacts);
    _clientSubscription = clientsController.clients.listen(_groupContacts);

    // Initialize with current client data
    _contacts.addAll(clientsController.clients);
    _groupContacts(clientsController.clients);
  }

  @override
  void dispose() {
    _clientSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Group contacts by the first letter of their name
  void _groupContacts(List<ContactsModel> contacts) {
    if (!mounted) return;
    final grouped = SplayTreeMap<String, List<ContactsModel>>();

    for (var contact in contacts) {
      String firstLetter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(firstLetter, () => []).add(contact);
    }

    if (mounted) {
      setState(() {
        _groupedContacts = grouped;
      });
    }
  }

  // Filter contacts based on search input
  void _filterContacts() {
    if (_searchText.isEmpty) {
      _groupContacts(_contacts);
    } else {
      List<ContactsModel> filtered = _contacts
          .where((c) => c.name.toLowerCase().startsWith(_searchText.toLowerCase()))
          .toList();
      _groupContacts(filtered);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Clients',
        hasLeading: true,
        textLeading: 'close'.tr,
        onPressedLeading: () => Get.back(),
      ),
      backgroundColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
      body: Obx(() => _buildBody()),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBody() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(),
          Divider(
            color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.darkGreyColor,
          ),
          SizedBox(height: mq.height * 0.02),
          _contacts.isEmpty ? _buildNoClientWidget() : _buildContactList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Container(
      width: mq.width,
      color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.01),
          hintText: 'research'.tr,
          hintStyle: TextStyle(
              color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,
              fontSize: mq.aspectRatio * 45),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(mq.aspectRatio * 30)),
          filled: true,
          fillColor: isLightTheme ? Colors.grey.shade200 : ColorsTheme.darkGreyColor,
          prefixIcon: Icon(CupertinoIcons.search,
              color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,
              size: mq.aspectRatio * 60),
        ),
      ),
    );
  }

  Widget _buildNoClientWidget() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Container(
      width: mq.width,
      color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
      padding: EdgeInsets.only(top: mq.height * 0.15),
      child: NoClientData(),
    );
  }

  Widget _buildContactList() {
    return _groupedContacts.isEmpty
        ? _buildNoResultsWidget()
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _groupedContacts.keys.length,
            itemBuilder: (context, index) {
              String firstLetter = _groupedContacts.keys.elementAt(index);
              List<ContactsModel> contacts = _groupedContacts[firstLetter]!;
              return _buildContactSection(firstLetter, contacts);
            },
          );
  }

  Widget _buildNoResultsWidget() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: mq.height * 0.2),
        child: Text(
          'No results found',
          style: TextStyle(
              fontSize: mq.aspectRatio * 45,
              color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
        ),
      ),
    );
  }

  Widget _buildContactSection(String letter, List<ContactsModel> contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(letter),
        ...contacts.map(_buildContactTile),
      ],
    );
  }

  Widget _buildSectionHeader(String letter) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
      width: mq.width,
      color: isLightTheme ? Colors.grey.shade300 : ColorsTheme.darkGreyColor,
      child: boldText(
          text: letter,
          fontSize: mq.aspectRatio * 45,
          color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
    );
  }

  Widget _buildContactTile(ContactsModel contact) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return GestureDetector(
      onTap: () => _selectClient(contact), // Update to include the selection callback
      child: ListTile(
        leading: CircleAvatar(child: Text(contact.name[0])),
        title: boldText(
            text: contact.name.toUpperCase(),
            fontSize: mq.aspectRatio * 42,
            color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
        subtitle: thinText(
            text: contact.address,
            fontSize: mq.aspectRatio * 35,
            color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor),
        trailing: IconButton(
          onPressed: () => _showContactOptions(contact),
          icon: Icon(
            Icons.more_horiz_rounded,
            color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,
          ),
        ),
      ),
    );
  }

  // New method to handle client selection
  void _selectClient(ContactsModel contact) {
    final factureController = Get.find<FactureController>();
    factureController.updateClient(contact); // Update the client in FactureController
    factureController.selectedClientId.value = contact.id; // Update the ID for persistence
    log("Selected client: ${contact.name}");
    Get.back(); // Navigate back if necessary
  }

  Widget _buildBottomButton() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return bottomButtonInScreen(
      text: 'add_customer'.tr,
      onPressed: () => Get.to(NewClient(clientsList: _contacts)),
      horizontal: mq.width * 0.05,
      top: mq.height * 0.01,
      bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
      bottom: mq.height * 0.05,
    );
  }

  // Show bottom sheet with modify and delete options
  void _showContactOptions(ContactsModel contact) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => _buildOptionsSheet(contact),
    );
  }

  Widget _buildOptionsSheet(ContactsModel contact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOptionContainer(contact),
        _buildCancelButton(),
      ],
    );
  }

  Widget _buildOptionContainer(ContactsModel contact) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
      decoration: BoxDecoration(
          color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.darkGreyColor,
          borderRadius: BorderRadius.circular(mq.aspectRatio * 20)),
      child: Column(
        children: [
          _buildOption('edit'.tr, () {
            Get.back();
            _modifyContact(contact);
          }, textColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
          Divider(
            color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor,
          ),
          _buildOption('delete'.tr, () {
            Get.back();
            _deleteContact(contact);
          }, textColor: Colors.red),
        ],
      ),
    );
  }

  Widget _buildOption(String text, VoidCallback onTap, {required Color textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: mq.height * 0.02),
        alignment: Alignment.center,
        width: mq.width,
        child: boldText(text: text, fontSize: mq.aspectRatio * 50, color: textColor),
      ),
    );
  }

  Widget _buildCancelButton() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: mq.width * 0.03, vertical: mq.height * 0.01),
        decoration: BoxDecoration(
            color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.darkGreyColor,
            borderRadius: BorderRadius.circular(mq.aspectRatio * 20)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: mq.height * 0.02),
            alignment: Alignment.center,
            width: mq.width,
            child: boldText(
                text: 'cancel'.tr,
                fontSize: mq.aspectRatio * 50,
                color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor)),
      ),
    );
  }

  void _modifyContact(ContactsModel contact) {
    Get.to(NewClient(clientsList: _contacts, existingClient: contact));
    log("${'edit'.tr} ${contact.name}");
  }

  void _deleteContact(ContactsModel contact) {
    clientsController.removeClient(contact);
    clientsController.saveClients();
    setState(() {
      _contacts.remove(contact);
      _filterContacts();
    });
    log("Deleted ${contact.name}");
  }
}
