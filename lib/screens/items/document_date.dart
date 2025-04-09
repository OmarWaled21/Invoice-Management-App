import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/client/custom_text_field.dart';
import 'package:facturation_intuitive/widgets/custom_choose_date.dart';
import 'package:facturation_intuitive/widgets/custom_drop_down.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentDate extends StatefulWidget {
  const DocumentDate({super.key});

  @override
  State<DocumentDate> createState() => _DocumentDateState();
}

final TextEditingController numController = TextEditingController(text: '2024 - ');
int _selectedConditions = 14;
final List<int> _conditions = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
final FactureController facture = FactureController();
final FocusNode _focusNode = FocusNode();
final ScrollController _scrollController = ScrollController();

class _DocumentDateState extends State<DocumentDate> {
  @override
  void initState() {
    super.initState();
    facture.loadFactureDetails();
    numController.text = facture.facture.value.invoiceNumber; // Initialize with current year and invoice number
    _initializeDateEchance();

    // Listen for focus changes to scroll into view
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToField();
      }
    });
  }

  // Scroll the text field into view
  void _scrollToField() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Détails',
        hasLeading: true,
        textLeading: 'Fermer',
        onPressedLeading: () => Get.back(),
        hasActions: true,
        textAction: 'Ok',
        onPressedAction: () {
          _saveFactureDetails(); // Save the details on "Ok" press
          Get.back();
        },
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextField(
                  title: 'Numéro du document',
                  controller: numController,
                  hint: '',
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Update dateEchance based on new conditions
                    facture.updateInvoiceNumber(value);
                    _updateDateEchance();
                  },
                ),
                CustomDropDown(
                  title: 'Condition de paiements',
                  selectedValue: 'Due dans $_selectedConditions jours',
                  options: _conditions.map((c) => 'Due dans $c jours').toList(),
                  onSelected: (value) {
                    setState(() {
                      _selectedConditions = int.parse(value
                        .replaceAll('Due dans ', '').replaceAll(' jours', '').trim());
                      _updateDateEchance();
                    });
                  },
                  color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                  bgColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
                  txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                ),

                // Select dateEmission
                Padding(
                  padding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
                  child: selectedDate(
                    "Date d'emission",
                        () => _selectDate(context, true),
                    FormattedDate(facture.facture.value.dateEmission)
                        .formattedDayShortMonth
                        .toString(),
                    isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  ),
                ),

                // Select dateEchance
                selectedDate(
                  "Date d'échéance",
                      () => _selectDate(context, false),
                  FormattedDate(facture.facture.value.dateEchance)
                      .formattedDayShortMonth
                      .toString(),
                  isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isEmissionDate) async {
    await selectDateTime(
      context,
      this,
      isEmissionDate
          ? facture.facture.value.dateEmission
          : facture.facture.value.dateEchance,
          (selectedDate) {
        setState(() {
          if (isEmissionDate) {
            facture.updateDateEmission(selectedDate);
            _updateDateEchance(); // Update dateEchance based on new dateEmission
          } else {
            facture.updateDateEchance(selectedDate);
            _updateSelectedConditions(); // Update selected conditions based on new dateEchance
          }
        });
      },
    );
  }

  // Method to initialize dateEchance based on initial dateEmission and selected conditions
  void _initializeDateEchance() {
    facture.updateDateEchance(facture.facture.value.dateEmission
        .add(Duration(days: _selectedConditions)));
  }

  // Method to update dateEchance based on dateEmission and selected conditions
  void _updateDateEchance() {
    DateTime newDateEchance = facture.facture.value.dateEmission
        .add(Duration(days: _selectedConditions));
    facture.updateDateEchance(newDateEchance);
  }

  // Method to update selectedConditions based on the difference between dateEmission and dateEchance
  void _updateSelectedConditions() {
    final int difference = facture.facture.value.dateEchance
        .difference(facture.facture.value.dateEmission)
        .inDays;
    setState(() {
      _selectedConditions = difference;
    });
  }

  // Method to save facture details
  void _saveFactureDetails() {
    // Save the current values to the facture controller
    facture.updateInvoiceNumber(numController.text); // Update invoice number
    facture.saveFactureDetails(); // Save facture details to SharedPreferences
  }
}
