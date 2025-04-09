import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:facturation_intuitive/controller/color_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/screens/home_screen.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/widgets/grey_container.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/facture_model.dart';

class FactureModel2 extends StatelessWidget {
  final FactureModel? facture;
  const FactureModel2({super.key, this.facture});

  @override
  Widget build(BuildContext context) {
    FactureController factureController = Get.find<FactureController>();
    ColorController colorController = Get.find<ColorController>();
    factureController.loadFactureDetails();

    final profile = factureController.facture.value.businessDetails;
    var client = factureController.facture.value.clientDetails;

    return Obx(() {
      final Color policeColor = colorController.policeColor.value;
      final Color marqueColor = colorController.marqueColor.value;
      final String fontFamily = colorController.selectedFontFamily.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final double fontSizeHeaderAndFooter = constraints.maxWidth * 0.01458;
          final double fontSizeMiddle = constraints.maxWidth * 0.018;

          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                    profile, fontSizeMiddle, constraints, client, policeColor, fontFamily, facture),
                _buildBody(fontSizeMiddle, constraints, client, policeColor, marqueColor,
                    fontFamily, factureController, facture),
                _buildItemsSection(factureController, fontSizeMiddle, constraints, policeColor,
                    marqueColor, fontFamily, facture),
                _buildSummarySection(factureController, fontSizeMiddle, constraints, policeColor,
                    marqueColor, fontFamily, facture),
                const Spacer(),
                _buildBanckInfo(profile, constraints, policeColor, marqueColor,
                    fontSizeHeaderAndFooter, fontFamily, facture),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildHeader(profile, double fontSize, BoxConstraints constraints, client,
      Color policeColor, String fontFamily, FactureModel? facture) {
    return Padding(
      padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(profile, constraints, facture),
          _buildProfileDetails(
              profile, fontSize, constraints, client, policeColor, fontFamily, facture),
        ],
      ),
    );
  }

  Widget _buildProfileImage(profile, BoxConstraints constraints, FactureModel? facture) {
    return Container(
      padding: (profile.image == '' || facture?.businessDetails.image == '')
          ? EdgeInsets.only(top: constraints.maxHeight * 0.06)
          : EdgeInsets.only(top: constraints.maxHeight * 0.03),
      child: facture != null
          ? facture.businessDetails.image != ''
              ? Image.file(
                  File(facture.businessDetails.image!),
                  width: constraints.maxWidth * 0.15,
                  fit: BoxFit.cover,
                )
              : boldText(text: facture.businessDetails.name, fontSize: constraints.maxWidth * 0.01)
          : profile.image != ''
              ? Image.file(
                  File(profile.image!),
                  width: constraints.maxWidth * 0.15,
                  fit: BoxFit.cover,
                )
              : Center(child: boldText(text: profile.name, fontSize: constraints.maxWidth * 0.01)),
    );
  }

  Widget _buildProfileDetails(ProfileModel profile, double fontSize, BoxConstraints constraints,
      client, Color policeColor, String fontFamily, FactureModel? facture) {
    return Padding(
      padding: EdgeInsets.only(top: constraints.maxHeight * 0.1, left: constraints.maxWidth * 0.14),
      child: _buildDestinataireSection(
          client, fontSize, constraints, policeColor, fontFamily, facture),
    );
  }

  Widget _buildDestinataireSection(client, double fontSize, BoxConstraints constraints,
      Color policeColor, String fontFamily, FactureModel? facture) {
    return Container(
      margin: EdgeInsets.only(top: constraints.maxHeight * 0.01),
      height: constraints.maxHeight * 0.1,
      width: constraints.maxWidth * 0.4,
      child: facture != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(
                  text: facture.clientDetails!.name.toString().toUpperCase(),
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                  hasOverflow: false,
                ),
                Wrap(
                  children: [
                    normalText(
                      text: facture.clientDetails!.address.toString().toUpperCase(),
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                    normalText(
                      text: " - ${facture.clientDetails!.postalCode}",
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                    normalText(
                      text: " ${facture.clientDetails!.city.toString().toUpperCase()}",
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                  ],
                ),
                normalText(
                  text: facture.clientDetails!.country,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                  hasOverFlow: false,
                ),
                client.tvaNumber != null
                    ? normalText(
                        text: 'N° TVA ${facture.clientDetails!.tvaNumber ?? ''}',
                        fontSize: fontSize,
                        color: policeColor,
                        fontFamily: fontFamily,
                        hasOverFlow: false,
                      )
                    : const SizedBox(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(
                  text: client.name.toString().toUpperCase(),
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                  hasOverflow: false,
                ),
                Wrap(
                  children: [
                    normalText(
                      text: client.address.toString().toUpperCase(),
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                    normalText(
                      text: " - ${client.postalCode} ",
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                    normalText(
                      text: client.city.toString().toUpperCase(),
                      fontSize: fontSize,
                      color: policeColor,
                      fontFamily: fontFamily,
                      hasOverFlow: false,
                    ),
                  ],
                ),
                normalText(
                  text: client.country,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                  hasOverFlow: false,
                ),
                client.tvaNumber != null
                    ? normalText(
                        text: 'N° TVA ${client.tvaNumber ?? ''}',
                        fontSize: fontSize,
                        color: policeColor,
                        fontFamily: fontFamily,
                        hasOverFlow: false,
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }

  Widget _buildBody(
      double fontSize,
      BoxConstraints constraints,
      dynamic client,
      Color policeColor,
      Color marqueColor,
      String fontFamily,
      FactureController factureController,
      FactureModel? facture) {
    // Ensure client is not null before accessing its properties
    final clientId = client?.id?.toString() ?? 'N/A';

    String formattedDate(DateTime dateTime) {
      return FormattedDate(dateTime).originalFormattedDaySlash;
    }

    return SizedBox(
      width: constraints.maxWidth * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFactureDetailRow(
            'invoice'.tr,
            facture != null ? facture.invoiceNumber : factureController.facture.value.invoiceNumber,
            fontSize,
            constraints,
            policeColor,
            fontFamily,
          ),
          _buildDivider(0, 0, marqueColor),
          _buildFactureDetailRow(
            '${'profile_date'.tr}:',
            facture != null
                ? formattedDate(facture.dateEmission)
                : formattedDate(factureController.facture.value.dateEmission),
            // Replace with the actual date if available
            fontSize,
            constraints,
            policeColor,
            fontFamily,
            right: constraints.maxWidth * 0.03,
          ),
          _buildFactureDetailRow(
            "${'due_date'.tr}:",
            facture != null
                ? formattedDate(facture.dateEchance)
                : formattedDate(factureController.facture.value.dateEchance),
            fontSize,
            constraints,
            policeColor,
            fontFamily,
            isBold: true,
            top: constraints.maxHeight * 0.01,
            right: constraints.maxWidth * 0.03,
          ),
          facture != null
              ? _buildFactureDetailRow(
                  "${'client_num'.tr}:",
                  "${facture.clientDetails!.id}", // Use the checked clientId
                  fontSize,
                  constraints,
                  policeColor,
                  fontFamily,
                  top: constraints.maxHeight * 0.02,
                  right: constraints.maxWidth * 0.03,
                )
              : client.id != 0
                  ? _buildFactureDetailRow(
                      "${'client_num'.tr}:",
                      clientId, // Use the checked clientId
                      fontSize,
                      constraints,
                      policeColor,
                      fontFamily,
                      top: constraints.maxHeight * 0.02,
                      right: constraints.maxWidth * 0.03,
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildFactureDetailRow(String label, String? value, double fontSize,
      BoxConstraints constraints, Color policeColor, String fontFamily,
      {double top = 0, double right = 0, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: right),
            child: isBold
                ? boldText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                  )
                : normalText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                  ),
          ),
          _buildTextOrGreyContainer(value, fontSize, constraints, policeColor, fontFamily,
              isBold: isBold),
        ],
      ),
    );
  }

  // Your modified _buildItemsSection function
  Widget _buildItemsSection(
      FactureController factureController,
      double fontSize,
      BoxConstraints constraints,
      Color policeColor,
      Color marqueColor,
      String fontFamily,
      FactureModel? facture) {
    return Container(
      constraints: BoxConstraints.expand(height: constraints.maxHeight * 0.2),
      padding: EdgeInsets.only(top: constraints.maxHeight * 0.05),
      child: DataTable2(
          headingRowHeight: constraints.maxHeight * 0.03,
          fixedColumnsColor: marqueColor,
          headingRowColor: WidgetStatePropertyAll(marqueColor),
          border: TableBorder.all(color: marqueColor),
          columnSpacing: 12,
          horizontalMargin: 1,
          minWidth: constraints.maxWidth,
          columns: [
            _buildTableHeader(constraints, fontSize, fontFamily, policeColor,
                text: 'Description', hasFixedWidth: true),
            _buildTableHeader(constraints, fontSize, fontFamily, policeColor, text: 'quantity'.tr),
            _buildTableHeader(constraints, fontSize, fontFamily, policeColor, text: 'unite'.tr),
            _buildTableHeader(constraints, fontSize, fontFamily, policeColor, text: 'price'.tr),
            _buildTableHeader(constraints, fontSize, fontFamily, policeColor, text: 'amount'.tr),
          ],
          rows: facture != null
              ? facture.items.map((item) {
                  return DataRow(
                    cells: [
                      _buildTableBody(
                        text: item.name!.toUpperCase(),
                        value: item.description,
                        isDescription: true,
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.quantity.toString(),
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.unite ?? '',
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.price?.toStringAsFixed(2) ?? '0,00',
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                          text: item.totalPrice?.toStringAsFixed(2) ?? '0,00',
                          constraints,
                          fontSize,
                          fontFamily,
                          policeColor,
                          isTotalPrice: true),
                    ],
                  );
                }).toList()
              : factureController.items.map((item) {
                  return DataRow(
                    cells: [
                      _buildTableBody(
                        text: item.name!.toUpperCase(),
                        value: item.description,
                        isDescription: true,
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.quantity.toString(),
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.unite ?? '',
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                        text: item.price?.toStringAsFixed(2) ?? '0,00',
                        constraints,
                        fontSize,
                        fontFamily,
                        policeColor,
                      ),
                      _buildTableBody(
                          text: item.totalPrice?.toStringAsFixed(2) ?? '0,00',
                          constraints,
                          fontSize,
                          fontFamily,
                          policeColor,
                          isTotalPrice: true),
                    ],
                  );
                }).toList()),
    );
  }

  DataColumn2 _buildTableHeader(
      BoxConstraints constraints, double fontSize, String fontFamily, Color policeColor,
      {required String text, bool hasFixedWidth = false}) {
    return DataColumn2(
      label: normalText(
        text: text,
        fontSize: fontSize,
        color: policeColor,
        hasOverFlow: false,
        fontFamily: fontFamily,
      ),
      fixedWidth: hasFixedWidth ? constraints.maxWidth * 0.5 : null,
    );
  }

  DataCell _buildTableBody(
      BoxConstraints constraints, double fontSize, String fontFamily, Color policeColor,
      {required String text,
      String? value,
      bool isDescription = false,
      bool isTotalPrice = false}) {
    return isDescription
        ? DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min to avoid expanding vertically
              children: [
                normalText(
                  text: text,
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  color: policeColor,
                  hasOverFlow: false,
                ),
                if (value != null)
                  Wrap(
                    children: [
                      normalText(
                          text: value,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          color: policeColor,
                          hasOverFlow: false),
                    ],
                  ),
              ],
            ),
          )
        : DataCell(
            Container(
              alignment: isTotalPrice ? Alignment.centerRight : Alignment.center,
              child: normalText(
                  text: text,
                  fontSize: fontSize,
                  hasOverFlow: false,
                  color: policeColor,
                  fontFamily: fontFamily),
            ),
          );
  }

  Widget _buildSummarySection(
      FactureController factureController,
      double fontSize,
      BoxConstraints constraints,
      Color policeColor,
      Color marqueColor,
      String fontFamily,
      FactureModel? facture) {
    bool htSelected = factureController.isPrixHTSelected.value;

    // Calculate Sous-total
    double sousTotalHT = factureController.sousTotal.value;

    // Calculate average TVA
    final averageTVA = factureController.tvaAverage;
    final tvaSousTotalHT = (factureController.tvaAverage / 100) * sousTotalHT;

    double montantTotalHT =
        sousTotalHT + tvaSousTotalHT; // Assuming Montant Total includes Sous-total + TVA

    double montantTotalTTC = factureController.montantTotal.value;
    double sousTotalTTC =
        factureController.montantTotal / (1 + (factureController.tvaAverage / 100));
    double tvaSousTotalTTC = montantTotalTTC - sousTotalTTC;

    // Check if facture is not null before accessing its properties
    var sousTotalHistory = facture != null
        ? facture.montantTotal / (1 + (facture.tvaAverage / 100))
        : 0.0; // Provide a default value (e.g., 0.0) if facture is null

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.4,
        ),
        Padding(
          padding: EdgeInsets.only(top: constraints.maxHeight * 0.03),
          child: Row(
            children: [
              facture != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSummaryRow('Sous-total HT', constraints,
                            sousTotalHistory.toStringAsFixed(2), fontSize, policeColor, fontFamily,
                            bottom: constraints.maxHeight * 0.01),
                        _buildSummaryRow(
                            'TVA ${facture.tvaAverage.toInt()}% de '
                            '${sousTotalHistory.toStringAsFixed(2)}',
                            constraints,
                            ((facture.tvaAverage / 100) * sousTotalHistory).toStringAsFixed(2),
                            fontSize,
                            policeColor,
                            fontFamily,
                            bottom: constraints.maxHeight * 0.02),
                        Container(
                          padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.01,
                              constraints.maxHeight * 0.01, 0, constraints.maxHeight * 0.01),
                          color: marqueColor,
                          child: _buildSummaryRow(
                            '${'amount'.tr} Total EUR',
                            constraints,
                            facture.montantTotal.toStringAsFixed(2),
                            fontSize,
                            policeColor,
                            fontFamily,
                            isBold: true,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildSummaryRow(
                            'Sous-total HT',
                            constraints,
                            htSelected
                                ? sousTotalHT.toStringAsFixed(2)
                                : sousTotalTTC.toStringAsFixed(2),
                            fontSize,
                            policeColor,
                            fontFamily,
                            bottom: constraints.maxHeight * 0.01),
                        _buildSummaryRow(
                            'TVA ${averageTVA.toInt()}% de '
                            '${htSelected ? sousTotalHT.toStringAsFixed(2) : sousTotalTTC.toStringAsFixed(2)}',
                            constraints,
                            htSelected
                                ? tvaSousTotalHT.toStringAsFixed(2)
                                : tvaSousTotalTTC.toStringAsFixed(2),
                            fontSize,
                            policeColor,
                            fontFamily,
                            bottom: constraints.maxHeight * 0.02),
                        Container(
                          padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.01,
                              constraints.maxHeight * 0.01, 0, constraints.maxHeight * 0.01),
                          color: marqueColor,
                          child: _buildSummaryRow(
                            '${'amount'.tr} Total EUR',
                            constraints,
                            htSelected
                                ? montantTotalHT.toStringAsFixed(2)
                                : montantTotalTTC.toStringAsFixed(2),
                            fontSize,
                            policeColor,
                            fontFamily,
                            isBold: true,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, BoxConstraints constraints, String value, double fontSize,
      Color policeColor, String fontFamily,
      {bool isBold = false, double bottom = 0}) {
    return SizedBox(
      width: constraints.maxWidth * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: isBold
                ? boldText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                  )
                : thinText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                  ),
          ),
          isBold
              ? boldText(
                  text: value,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                )
              : thinText(
                  text: value,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                ),
        ],
      ),
    );
  }

  Widget _buildTextOrGreyContainer(String? text, double fontSize, BoxConstraints constraints,
      Color policeColor, String fontFamily,
      {bool isBold = false}) {
    return text != null && text.isNotEmpty
        ? isBold
            ? boldText(
                text: text,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
              )
            : normalText(
                text: text,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
              )
        : greyContainer(width: constraints.maxWidth * 0.1, height: constraints.maxHeight * 0.02);
  }

  Widget _buildDivider(double top, double bottom, Color marqueColor) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Divider(color: marqueColor),
    );
  }

  Widget _buildBanckInfo(ProfileModel profile, BoxConstraints constraints, Color policeColor,
      Color marqueColor, double fontSize, String fontFamily, FactureModel? facture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDivider(0, 0, marqueColor),
        Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.only(
            bottom: constraints.maxHeight * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                      text: 'bank_information'.tr.toUpperCase(),
                      fontSize: fontSize * 1.25,
                      color: policeColor,
                      fontFamily: fontFamily),
                  SizedBox(height: constraints.maxHeight * 0.005),
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
                    child: _buildBankRowValues(
                      "${'company_name'.tr}: ".toUpperCase(),
                      facture != null ? facture.businessDetails.name : profile.name,
                      policeColor,
                      fontSize,
                      fontFamily,
                    ),
                  ),
                  _buildBankRowValues(
                    "IBAN: ",
                    facture != null ? facture.businessDetails.iban ?? '' : profile.iban ?? '',
                    policeColor,
                    fontSize,
                    fontFamily,
                  ),
                  _buildBankRowValues(
                    "BIC-ADRESSE SWIFT: ",
                    facture != null ? facture.businessDetails.swift ?? '' : profile.swift ?? '',
                    policeColor,
                    fontSize,
                    fontFamily,
                  )
                ],
              ),
              Container(
                width: constraints.maxWidth * 0.67,
                padding: EdgeInsets.only(left: constraints.maxWidth * 0.04),
                child: _buildBusinessInfo(facture, profile, fontSize, fontFamily, policeColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankRowValues(
    String title,
    String value,
    Color policeColor,
    double fontSize,
    String fontFamily,
  ) {
    return Row(
      children: [
        boldText(text: title, fontSize: fontSize, color: policeColor, fontFamily: fontFamily),
        thinText(
          text: value,
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,
        ),
      ],
    );
  }

  Widget _buildBusinessInfo(FactureModel? facture, ProfileModel profile, double fontSize,
      String fontFamily, Color policeColor) {
    ProfileModel factureProfile = factureController.facture.value.businessDetails;
    return facture != null
        ? Wrap(
            alignment: WrapAlignment.center,
            children: [
              _buildRowBusinessInfo(
                  facture.businessDetails.name,
                  " ${facture.businessDetails.address}-${facture.businessDetails.postalCode}"
                  " ${factureProfile.city}",
                  fontSize,
                  fontFamily,
                  policeColor),
              _buildRowBusinessInfo(
                  "Email: ", "${facture.businessDetails.email}", fontSize, fontFamily, policeColor),
              _buildRowBusinessInfo("${'phone'.tr}: ", "${facture.businessDetails.phone}", fontSize,
                  fontFamily, policeColor),
              _buildRowBusinessInfo("N°SIREN/SIRET: ", "${facture.businessDetails.siret}", fontSize,
                  fontFamily, policeColor),
              _buildRowBusinessInfo("N°TVA UE: ", "${facture.businessDetails.tvaNumber}", fontSize,
                  fontFamily, policeColor),
            ],
          )
        : Wrap(children: [
            _buildRowBusinessInfo(
                factureProfile.name,
                " ${factureProfile.address}-${factureProfile.postalCode}"
                " ${factureProfile.city}",
                fontSize,
                fontFamily,
                policeColor),
            _buildRowBusinessInfo(
                "Email: ", "${factureProfile.email}", fontSize, fontFamily, policeColor),
            _buildRowBusinessInfo(
                "${'phone'.tr}: ", "${factureProfile.phone}", fontSize, fontFamily, policeColor),
            _buildRowBusinessInfo(
                "N°SIREN/SIRET: ", "${factureProfile.siret}", fontSize, fontFamily, policeColor),
            _buildRowBusinessInfo(
                "N°TVA UE: ", "${factureProfile.tvaNumber}", fontSize, fontFamily, policeColor),
          ]);
  }

  Widget _buildRowBusinessInfo(
      String text, String value, double fontSize, String fontFamily, Color policeColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        boldText(text: text, fontSize: fontSize, fontFamily: fontFamily, color: policeColor),
        thinText(
          text: value,
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,
        ),
      ],
    );
  }
}
