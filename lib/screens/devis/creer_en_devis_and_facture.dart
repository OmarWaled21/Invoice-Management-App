import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/clients/clients_screen.dart';
import 'package:facturation_intuitive/screens/devis/apercu_screen.dart';
import 'package:facturation_intuitive/screens/devis/finaliser_screen.dart';
import 'package:facturation_intuitive/screens/devis/settings_facture/format_du_prix.dart';
import 'package:facturation_intuitive/screens/items/document_date.dart';
import 'package:facturation_intuitive/screens/home_screen.dart';
import 'package:facturation_intuitive/screens/items/ajouter_un_article_screen.dart';
import 'package:facturation_intuitive/screens/personalization_facture/personalization_screen.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/devis/container_devis.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/contacts_model.dart';

class CreerUnDevisAndFacture extends StatefulWidget {
  final bool isDevis;

  const CreerUnDevisAndFacture({super.key, required this.isDevis});

  @override
  State<CreerUnDevisAndFacture> createState() => _CreerUnDevisAndFactureState();
}

class _CreerUnDevisAndFactureState extends State<CreerUnDevisAndFacture> {

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FactureModelController(), fenix: true);
    return Obx(() {
      final FactureController factureController = Get.find<FactureController>();
      factureController.loadFactureDetails(); // Load once in initState

      final client = factureController.facture.value.clientDetails;
      bool htSelected = factureController.isPrixHTSelected.value;

      // Calculate Sous-total
      double sousTotalHT = factureController.sousTotal.value;

      // Calculate average TVA
      final averageTVA = factureController.tvaAverage.value;
      final tvaSousTotalHT = (factureController.tvaAverage / 100) * sousTotalHT;

      double montantTotalHT = sousTotalHT + tvaSousTotalHT; // Assuming Montant Total includes Sous-total + TVA

      double montantTotalTTC = factureController.montantTotal.value;
      double sousTotalTTC = factureController.montantTotal / (1 + (factureController.tvaAverage / 100));
      double tvaSousTotalTTC = montantTotalTTC - sousTotalTTC;

      final ThemeController themeController = Get.find<ThemeController>();
      final isLightTheme = themeController.themeMode.value == ThemeMode.light;

      return Scaffold(
        appBar: DefaultAppbar(
          title: widget.isDevis ? 'Créer un devis' : 'Créer une facture',
          hasLeading: true,
          textLeading: 'Annuler',
          onPressedLeading: () => Get.offAll(const HomeScreen()),
          hasActions: true,
          iconAssets: Assets.iconsMore,
          onPressedAction: () {
            _showBottomSheet(factureController);
          },
        ),
        body: Container(
          width: mq.width,
          height: mq.height,
          color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.02,),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDocumentSection(factureController),
                _buildClientSection(client),
                _buildItemList(factureController),
                _buildAddItemButton(),
                htSelected
                    ? _buildSummary(sousTotalHT, tvaSousTotalHT, montantTotalHT, factureController, averageTVA)
                    : _buildSummary(sousTotalTTC, tvaSousTotalTTC, montantTotalTTC, factureController, averageTVA),
                SizedBox(height: mq.height * 0.04),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    });
  }

  Widget _buildDocumentSection(FactureController factureController){
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Obx(() {
      return containerDevis(
        onPressed: () => Get.to(() => const DocumentDate(), transition: Transition.downToUp),
        title: 'Document n° ${factureController.facture.value.invoiceNumber}',
        hasSubTitle: true,
        subTitle1: FormattedDate(factureController.facture.value.dateEmission).formattedDayShortMonth,
        subTitle2:
        'Due dans ${FormattedDate(factureController.facture.value.dateEmission).daysBetween(factureController.facture.value.dateEchance)} jours',
        titleColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
        iconColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
        subTitleColor: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor
      );
    },);
  }

  Widget _buildClientSection(ContactsModel? client) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return containerDevis(
      onPressed: () =>
          Get.to(const ClientsScreen(), transition: Transition.downToUp),
      title: client?.name.isEmpty ?? true
          ? 'Ajouter un client'
          : "${client!.name.toUpperCase()} - ${client.address.toUpperCase()}",
      isUnderLine: client?.name.isEmpty ?? true,
      endIndent: mq.width * 0.34,
      titleColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
      iconColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
      subTitleColor: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor
    );
  }

  Widget _buildItemList(FactureController factureController) {
    return Obx(() {
      if (factureController.items.isEmpty) {
        return const SizedBox.shrink(); // Empty widget when no items
      }
      final ThemeController themeController = Get.find<ThemeController>();
      final isLightTheme = themeController.themeMode.value == ThemeMode.light;

      return Column(
        children: factureController.items.asMap().entries.map((entry) {
          final index = entry.key; // Correct index of the item in the list
          final item = entry.value;

          return GestureDetector(
            onTap: () {
              Get.to(() => AjouterUnArticleScreen(item: item, index: index), // Pass correct index here
                  transition: Transition.downToUp);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
              width: mq.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
              ),
              child: ListTile(
                title: boldText(text: item.name!.toUpperCase(), color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                trailing: boldText(text: "${item.totalPrice?.toStringAsFixed(2)} €", color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                subtitle: normalText(
                  text: "${item.quantity} x ${item.price!.toStringAsFixed(2)} € (dont taxes ${(item.tva! / 100)})",
                  fontSize: mq.aspectRatio * 30, color: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.orangeColor
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildAddItemButton() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return containerDevis(
      onPressed: () {
        Get.to(() => const AjouterUnArticleScreen(), transition: Transition.downToUp);
      },
      title: 'Ajouter un article',
      isUnderLine: true,
      endIndent: mq.width * 0.33,
      titleColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
      iconColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
      subTitleColor: isLightTheme ? ColorsTheme.darkGreyColor : ColorsTheme.lightGreyColor
    );
  }

  Widget _buildSummary(double sousTotal, double tvaValue, double montantTotal, FactureController factureController, double averageTva) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Column(
      children: [
        _buildRow('Sous-total', '${sousTotal.toStringAsFixed(2)} €',
          txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
          valueColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
        ),
        SizedBox(height: mq.height * 0.02),
        SizedBox(height: mq.height * 0.01),
        _buildRow('Tva ${averageTva.toStringAsFixed(2)}%', '${tvaValue.toStringAsFixed(2)} €',
          txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
          valueColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
        ),
        SizedBox(height: mq.height * 0.02),
        _buildRow('Montant total', '${montantTotal.toStringAsFixed(2)} €', isBold: true, fontSize: mq.aspectRatio * 50,
          txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
          valueColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value,
      {bool isBold = false, double? fontSize, bool hasUnderLine = false, required Color txtColor, required Color valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        !isBold
            ? normalText(text: label, fontSize: fontSize ?? mq.aspectRatio * 40, color: txtColor)
            : Expanded(
                child: boldText(
                  text: label,
                  fontSize: fontSize ?? mq.aspectRatio * 40,
                  isUnderLine: hasUnderLine,
                  color: txtColor,
                  endIndent: hasUnderLine ? mq.width * 0.41 : 0,
                ),
              ),
        !isBold
            ? normalText(text: value, fontSize: fontSize ?? mq.aspectRatio * 40, color: valueColor)
            : boldText(text: value, fontSize: fontSize ?? mq.aspectRatio * 40, color: valueColor)
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Container(
      width: mq.width,
      height: mq.height * 0.2,
      decoration: BoxDecoration(
        border: Border.all(color: isLightTheme ? ColorsTheme.lightGreyColor : ColorsTheme.darkGreyColor),
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: mq.height * 0.02),
            width: 50,
            height: 7,
            decoration: BoxDecoration(
              color: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.05, horizontal: mq.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(() => const ApercuScreen()),
                    child: Padding(
                      padding: EdgeInsets.only(left: mq.width * 0.08),
                      child: boldText(
                        text: 'Aperçu',
                        isUnderLine: true,
                        fontSize: mq.aspectRatio * 40,
                        endIndent: mq.width * 0.13,
                        color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mq.width * 0.6,
                  height: mq.height * 0.06,
                  child: bottomButtonInScreen(
                    text: widget.isDevis ? 'Continuer' : 'Finaliser',
                    onPressed: () {
                      Get.to(() => const FinaliserScreen());
                    },
                    horizontal: mq.width * 0.05,
                    bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                    top: 0,
                    bottom: mq.height * 0.005,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(FactureController factureController) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(mq.aspectRatio * 40)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.darkGreyColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bottomSheetItems(
                Assets.iconsArticles,
                'Format du prix',
                () {
                  Get.back();
                  Get.to(() => const FormatDuPrix());
                },
                isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor
              ),
              _bottomSheetItems(
                Assets.iconsPersonnaliser,
                'Personnaliser la facture',
                () {
                  Get.back();
                  Get.to(() => const PersonalizationScreen());
                },
                isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor
              ),
              _bottomSheetItems(
                Assets.iconsClear,
                'Effacer les éléments',
                () {
                  factureController.clearItems();
                  factureController.resetSelectedClient();
                  Get.back();
                },
                isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetItems(String icon, String text, VoidCallback onTap, Color color) {
    return ListTile(
      leading: Image.asset(icon, height: mq.height * 0.028, color: color,),
      title: normalText(text: text, color: color, fontSize: mq.aspectRatio *40),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: mq.aspectRatio * 40, color: color,),
      onTap: onTap,
    );
  }
}
