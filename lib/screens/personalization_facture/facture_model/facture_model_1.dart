import 'dart:io';

import 'package:facturation_intuitive/controller/color_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/models/facture_model.dart';
import 'package:facturation_intuitive/models/items_model.dart';
import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/widgets/grey_container.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FactureModel1 extends StatelessWidget {
  final FactureModel? facture;
  const FactureModel1({super.key, this.facture});

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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      profile,
                      fontSizeHeaderAndFooter,
                      constraints,
                      policeColor,
                      fontFamily,
                      facture
                    ),
                    _buildDivider(constraints.maxHeight * 0.01,
                        constraints.maxHeight * 0.02, marqueColor),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.03),
                      child: Column(
                        children: [
                          _buildBody(
                            client,
                            fontSizeMiddle,
                            constraints,
                            policeColor,
                            fontFamily,
                            factureController,
                            facture
                          ),
                          _buildDivider(constraints.maxHeight * 0.02, 0, marqueColor),
                          _buildItemsSection(
                            factureController,
                            fontSizeMiddle,
                            constraints,
                            marqueColor,
                            policeColor,
                            fontFamily,
                            facture
                          ),
                          _buildDivider(0, constraints.maxHeight * 0.02, marqueColor),
                        ],
                      ),
                    ),
                    _buildSummarySection(
                      factureController,
                      fontSizeMiddle,
                      constraints,
                      policeColor,
                      fontFamily,
                      facture
                    ),
                  ],
                ),
                const Spacer(),
                _buildBanckInfo(profile, constraints, policeColor, marqueColor, fontSizeHeaderAndFooter, fontFamily, facture)
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildHeader(
    profile,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
    FactureModel? facture,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProfileImage(profile, constraints, facture),
          Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.03),
            child: _buildProfileDetails(
              profile,
              fontSize,
              constraints,
              policeColor,
              fontFamily,
              facture,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(profile, BoxConstraints constraints, FactureModel? facture) {
    return Container(
      padding: (profile.image == '' || facture?.businessDetails.image == '')
          ? EdgeInsets.only(top: constraints.maxHeight * 0.05)
          : EdgeInsets.zero,
      child: facture != null ?
      facture.businessDetails.image != ''
          ? Image.file(
        File(facture.businessDetails.image!),
        width: constraints.maxWidth * 0.15,
        fit: BoxFit.cover,
      ) : boldText(text: facture.businessDetails.name, fontSize: constraints.maxWidth * 0.01)
          : profile.image != ''
          ? Image.file(
        File(profile.image!),
        width: constraints.maxWidth * 0.15,
        fit: BoxFit.cover,
      ) : Center(child: boldText(text: profile.name,  fontSize: constraints.maxWidth * 0.025)),
    );
  }

  Widget _buildProfileDetails(
    profile,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
    FactureModel? facture
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        boldText(
          text: facture != null ? facture.businessDetails.name : profile.name,
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,),
        _buildTextLine(
          '',
          '${facture != null ? facture.businessDetails.address : profile.address} '
              '- ${facture != null ? facture.businessDetails.postalCode : profile.postalCode} '
              '${facture != null ? facture.businessDetails.city : profile.city}',
          fontSize,
          constraints,
          policeColor,
          fontFamily,
        ),
        _buildTextLine(
          'N° SIREN / SIRET : ',
          facture != null ? facture.businessDetails.siret : profile.siret,
          fontSize,
          constraints,
          policeColor,
          fontFamily,
        ),
        _buildTextLine(
          'N° TVA UE : ',
          facture != null ? facture.businessDetails.tvaNumber : profile.tvaNumber,
          fontSize,
          constraints,
          policeColor,
          fontFamily,
        ),
        _buildContactInfo(
          profile,
          fontSize,
          constraints,
          policeColor,
          fontFamily,
          facture,
        ),
      ],
    );
  }

  Widget _buildContactInfo(
    profile,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
    FactureModel? facture
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        boldText(
          text: 'E-mail: ',
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,
        ),
        _buildTextOrGreyContainer(
          facture != null ? facture.businessDetails.email : profile.email,
          fontSize,
          constraints,
          policeColor,
          fontFamily,
        ),
        boldText(
          text: '  Téléphone: ',
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,
        ),
        _buildTextOrGreyContainer(
          facture != null ? facture.businessDetails.phone : profile.phone,
          fontSize,
          constraints,
          policeColor,
          fontFamily,
        ),
      ],
    );
  }

  Widget _buildBody(
    client,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
    FactureController factureController,
    FactureModel? facture,
  ) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDestinataireSection(
                client,
                fontSize,
                constraints,
                policeColor,
                fontFamily,
                facture,
              ),
              SizedBox(
                width: constraints.maxWidth * 0.35,
                child: _buildFactureInfo(
                  fontSize,
                  constraints,
                  client,
                  policeColor,
                  fontFamily,
                  factureController,
                  facture,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDestinataireSection(
    client,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
    FactureModel? facture
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        normalText(
          text: 'Destinataire:',
          fontSize: fontSize,
          color: policeColor,
          fontFamily: fontFamily,
        ),
        Container(
          margin: EdgeInsets.only(left: constraints.maxWidth * 0.03),
          height: constraints.maxHeight * 0.1,
          width: constraints.maxWidth * 0.5,
          child: facture != null
            ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              normalText(
                text: facture.clientDetails!.name.toString().toUpperCase(),
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ),
              normalText(
                text: facture.clientDetails!.address,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ),
              facture.clientDetails!.address2 != '' ?
              normalText(
                text: facture.clientDetails!.address2 ?? '',
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ) : const SizedBox(),
              normalText(
                text: '${facture.clientDetails!.postalCode ?? ''} - ${facture.clientDetails!.city ?? ''}',
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
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
              normalText(
                text: client.name.toString().toUpperCase(),
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ),
              normalText(
                text: client.address,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ),
              client.address2 != '' ?
              normalText(
                text: "${client.address2 ?? ''}",
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
              ) : const SizedBox(),
              normalText(
                text: '${client.postalCode ?? ''} - ${client.city ?? ''}',
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false,
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
        ),
      ],
    );
  }

  Widget _buildFactureInfo(
    double fontSize,
    BoxConstraints constraints,
    dynamic client,
    Color policeColor,
    String fontFamily,
    FactureController factureController,
    FactureModel? facture,
  ) {
    // Ensure client is not null before accessing its properties
    final clientId = client?.id?.toString() ?? 'N/A';

    String formattedDate(DateTime dateTime) {
      return FormattedDate(dateTime).originalFormattedDaySlash;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFactureDetailRow(
          'Facture: ',
          facture != null ? facture.invoiceNumber :
          factureController.facture.value.invoiceNumber,
          // Replace with the actual date if available
          fontSize,
          constraints,
          policeColor,
          fontFamily,
          right: constraints.maxWidth * 0.03,
        ),
        _buildFactureDetailRow(
          'Date de profile:',
          facture != null ? formattedDate(facture.dateEmission):
          formattedDate(factureController.facture.value.dateEmission),          // Replace with the actual date if available
          fontSize,
          constraints,
          policeColor,
          fontFamily,
          top: constraints.maxHeight * 0.01,
          right: constraints.maxWidth * 0.03,
        ),
        _buildFactureDetailRow(
          "Date d'échéance:",
          facture != null ?
          formattedDate(facture.dateEchance):          // Replace with the actual date if available
          formattedDate(factureController.facture.value.dateEchance),          // Replace with the actual date if available
          fontSize,
          constraints,
          policeColor,
          fontFamily,
          top: constraints.maxHeight * 0.01,
          right: constraints.maxWidth * 0.03,
        ),
        facture != null?
          _buildFactureDetailRow(
            "Numero de client:",
            facture.clientDetails!.id.toString(), // Use the checked clientId
            fontSize,
            constraints,
            policeColor,
            fontFamily,
            top: constraints.maxHeight * 0.02,
            right: constraints.maxWidth * 0.03,
          ) : client.id != 0 ?
          _buildFactureDetailRow(
            "Numero de client:",
            clientId, // Use the checked clientId
            fontSize,
            constraints,
            policeColor,
            fontFamily,
            top: constraints.maxHeight * 0.02,
            right: constraints.maxWidth * 0.03,
          ): const SizedBox(),
      ],
    );
  }

  Widget _buildFactureDetailRow(String label, String? value, double fontSize,
      BoxConstraints constraints, Color policeColor, String fontFamily,
      {double top = 0, double right = 0}) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: right),
            child: boldText(
              text: label,
              fontSize: fontSize,
              color: policeColor,
              fontFamily: fontFamily,
            ),
          ),
          _buildTextOrGreyContainer(
            value,
            fontSize,
            constraints,
            policeColor,
            fontFamily,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(
    FactureController factureController,
    double fontSize,
    BoxConstraints constraints,
    Color marqueColor,
    Color policeColor,
    String fontFamily,
    FactureModel? facture
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(
              'Description',
              constraints.maxWidth * 0.47,
              fontSize,
              policeColor,
              fontFamily,
              alignLeft: true,
            ),
            SizedBox(
              child: Row(
                children: [
                  _buildTableHeader(
                    'Quantité',
                    constraints.maxWidth * 0.1,
                    fontSize,
                    policeColor,
                    fontFamily,
                  ),
                ],
              ),
            ),
            _buildTableHeader(
              'Unité',
              constraints.maxWidth * 0.06,
              fontSize,
              policeColor,
              fontFamily,
            ),
            _buildTableHeader(
              'Prix',
              constraints.maxWidth * 0.06,
              fontSize,
              policeColor,
              fontFamily,
            ),
            _buildTableHeader(
              'TVA',
              constraints.maxWidth * 0.06,
              fontSize,
              policeColor,
              fontFamily,
            ),
            _buildTableHeader(
              'Montant',
              constraints.maxWidth * 0.089,
              fontSize,
              policeColor,
              fontFamily,
              alignRight: true,
            ),
          ],
        ),
        _buildDivider(0, 0, marqueColor),
        Padding(
          padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.00),
          child: facture != null ?
          Column(
            children: facture.items.map((item) {
              return _buildItemRow(
                  item, fontSize, constraints, policeColor, fontFamily);
            }).toList(),
          ) :
          Column(
            children: factureController.items.map((item) {
              return _buildItemRow(
                  item, fontSize, constraints, policeColor, fontFamily);
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildItemRow(ItemsModel items, double fontSize, BoxConstraints constraints, Color policeColor, String fontFamily,) {

    // Check if facture is not null before accessing its properties
    var prix = items.totalPrice != null && items.tva != null ? items.totalPrice! / (1 + (items.tva! / 100)) : 0.0;
    return Row(
      children: [
        if(items.description != null)
          Column(
            children: [
              _buildTableCell("${items.name?.toUpperCase()}", constraints.maxWidth * 0.5,
                fontSize, policeColor, fontFamily, alignLeft: true,
              ),
              _buildTableCell("${items.description}", constraints.maxWidth * 0.5,
                fontSize, policeColor, fontFamily, alignLeft: true,
              ),
            ],
          ),
        _buildTableCell(
          '${items.quantity ?? 0}',
          constraints.maxWidth * 0.1,
          fontSize,
          policeColor,
          fontFamily,
        ),
        _buildTableCell(
          items.unite ?? '',
          constraints.maxWidth * 0.08,
          fontSize,
          policeColor,
          fontFamily,
        ),
        _buildTableCell(
          prix.toStringAsFixed(2),
          constraints.maxWidth * 0.09,
          fontSize,
          policeColor,
          fontFamily,
        ),
        _buildTableCell(
          '${items.tva ?? 0}%',
          constraints.maxWidth * 0.08,
          fontSize,
          policeColor,
          fontFamily,
        ),
        _buildTableCell(items.totalPrice?.toStringAsFixed(2) ?? '0,00', constraints.maxWidth * 0.08, fontSize,
            policeColor, fontFamily, alignRight: true),
      ],
    );
  }

  Widget _buildSummarySection(FactureController factureController, double fontSize, BoxConstraints constraints, Color policeColor, String fontFamily, FactureModel? facture) {
    bool htSelected = factureController.isPrixHTSelected.value;

    // Calculate Sous-total
    double sousTotalHT = factureController.sousTotal.value;

    // Calculate average TVA
    final averageTVA = factureController.tvaAverage;
    final tvaSousTotalHT = (factureController.tvaAverage / 100) * sousTotalHT;

    double montantTotalHT = sousTotalHT + tvaSousTotalHT; // Assuming Montant Total includes Sous-total + TVA

    double montantTotalTTC = factureController.montantTotal.value;
    double sousTotalTTC = factureController.montantTotal / (1 + (factureController.tvaAverage / 100));
    double tvaSousTotalTTC = montantTotalTTC - sousTotalTTC;


    // Check if facture is not null before accessing its properties
    var sousTotalHistory = facture != null
        ? facture.montantTotal / (1 + (facture.tvaAverage / 100))
        : 0.0; // Provide a default value (e.g., 0.0) if facture is null
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: constraints.maxWidth * 0.45,),
        Padding(
          padding: EdgeInsets.only(right: constraints.maxWidth * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              facture!= null ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSummaryRow(constraints,
                      'Sous-total HT',
                      sousTotalHistory.toStringAsFixed(2),
                      constraints.maxWidth * 0.02, policeColor, fontFamily,
                      bottom: constraints.maxHeight * 0.01),
                  _buildSummaryRow(constraints,
                      'TVA ${facture.tvaAverage.toInt()}% de '
                      '${sousTotalHistory.toStringAsFixed(2)}',
                      ((facture.tvaAverage/100) * sousTotalHistory).toStringAsFixed(2),
                      constraints.maxWidth * 0.02, policeColor, fontFamily,
                      bottom: constraints.maxHeight * 0.02),
                  _buildSummaryRow(constraints,
                      'Montant Total EUR', facture.montantTotal.toStringAsFixed(2), constraints.maxWidth * 0.02, policeColor, fontFamily,
                      isBold: true),
                ],
              ) :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSummaryRow(constraints,
                      'Sous-total HT',
                      htSelected ? sousTotalHT.toStringAsFixed(2) : sousTotalTTC.toStringAsFixed(2),
                      constraints.maxWidth * 0.02, policeColor, fontFamily,
                      bottom: constraints.maxHeight * 0.01),
                  _buildSummaryRow(constraints,
                      'TVA ${averageTVA.toInt()}% de '
                      '${htSelected ? sousTotalHT.toStringAsFixed(2) : sousTotalTTC.toStringAsFixed(2)}',
                      htSelected ? tvaSousTotalHT.toStringAsFixed(2) : tvaSousTotalTTC.toStringAsFixed(2),
                      constraints.maxWidth * 0.02, policeColor, fontFamily, bottom: constraints.maxHeight * 0.02),
                  _buildSummaryRow(constraints,
                      'Montant Total EUR', htSelected ? montantTotalHT.toStringAsFixed(2) : montantTotalTTC.toStringAsFixed(2),
                      constraints.maxWidth * 0.02, policeColor, fontFamily, isBold: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String label, double width, double fontSize, Color policeColor, fontFamily, {bool alignLeft = false, bool alignRight = false}) {
    return SizedBox(
      width: width,
      child: alignLeft
          ? Align(
              alignment: Alignment.centerLeft,
              child: normalText(
                text: label,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false
              ))
          : alignRight
              ? Align(
                  alignment: Alignment.centerRight,
                  child: normalText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                    hasOverFlow: false
                  ))
              : Center(
                  child: normalText(
                  text: label,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                )),
    );
  }

  Widget _buildTableCell(String value, double width, double fontSize,
      Color policeColor, String fontFamily,
      {bool alignRight = false, bool alignLeft = false}) {
    return SizedBox(
      width: width,
      child: alignLeft
          ? Align(
              alignment: Alignment.centerLeft,
              child: normalText(
                text: value,
                fontSize: fontSize,
                color: policeColor,
                fontFamily: fontFamily,
                hasOverFlow: false
              ))
          : alignRight
              ? Align(
                  alignment: Alignment.centerRight,
                  child: normalText(
                    text: value,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                    hasOverFlow: false
                  ))
              : Center(
                  child: normalText(
                  text: value,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                )),
    );
  }

  Widget _buildSummaryRow(BoxConstraints constraints, String label, String value, double fontSize, policeColor, fontFamily,
      {bool isBold = false, double bottom = 0}) {
    return SizedBox(
      width: constraints.maxWidth * 0.45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only( bottom: bottom),
            child: isBold
                ? boldText(
                    text: label,
                    fontSize: fontSize,
                    color: policeColor,
                    fontFamily: fontFamily,
                    hasOverflow: false,
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

  Widget _buildTextOrGreyContainer(
    String? text,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
  ) {
    return text != null && text.isNotEmpty
        ? thinText(
            text: text,
            fontSize: fontSize,
            color: policeColor,
            fontFamily: fontFamily)
        : greyContainer(
            width: constraints.maxWidth * 0.1,
            height: constraints.maxHeight * 0.02);
  }

  Widget _buildTextLine(
    String? title,
    String? text,
    double fontSize,
    BoxConstraints constraints,
    Color policeColor,
    String fontFamily,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.003),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          boldText(
            text: title ?? '',
            fontSize: fontSize,
            color: policeColor,
            fontFamily: fontFamily,
          ),
          text != null && text.isNotEmpty
              ? thinText(
                  text: text,
                  fontSize: fontSize,
                  color: policeColor,
                  fontFamily: fontFamily,
                  hasOverFlow: false,
                  maxlines: null,
                )
              : greyContainer(
                  width: constraints.maxWidth * 0.25,
                  height: constraints.maxHeight * 0.02,
                ),
        ],
      ),
    );
  }

  Widget _buildDivider(double top, double bottom, Color marqueColor) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Divider(color: marqueColor, thickness: 1,),
    );
  }

  Widget _buildBanckInfo(ProfileModel profile, BoxConstraints constraints,Color policeColor, Color marqueColor, double fontSize, String fontFamily, FactureModel? facture){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDivider(0, 0, marqueColor),
        Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.02, left: constraints.maxWidth * 0.05, right: constraints.maxWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: 'Informations bancaires'.toUpperCase(), fontSize: fontSize * 1.25, color: policeColor, fontFamily: fontFamily),
              SizedBox(height: constraints.maxHeight * 0.005),
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
                child: _buildBankRowValues("Nom de l'entreprise: ".toUpperCase(),
                  facture!= null ? facture.businessDetails.name : profile.name,
                  policeColor, fontSize, fontFamily,
                ),
              ),
              _buildBankRowValues("IBAN: ",
                facture!= null ? facture.businessDetails.iban ?? '' : profile.iban ?? '',
                policeColor, fontSize, fontFamily,
              ),
              _buildBankRowValues("BIC-ADRESSE SWIFT: ",
                facture!= null ? facture.businessDetails.swift ?? '' : profile.swift ?? '',
                policeColor, fontSize, fontFamily,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankRowValues(String title, String value, Color policeColor, double fontSize, String fontFamily){
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
}
