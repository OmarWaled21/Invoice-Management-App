import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/facture_model.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_1.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_2.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import "package:path/path.dart" as path;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';


class FactureHistoryDetails extends StatefulWidget {
  final FactureModel facture;

  const FactureHistoryDetails({super.key, required this.facture});

  @override
  State<FactureHistoryDetails> createState() => _FactureHistoryDetailsState();
}

class _FactureHistoryDetailsState extends State<FactureHistoryDetails> {
  final GlobalKey _globalKey = GlobalKey();

  // Widget to show the selected model
  Widget _getSelectedModel(int selectedModel) {
    switch (selectedModel) {
      case 2:
        return FactureModel2(facture: widget.facture,);
      default:
        return FactureModel1(facture: widget.facture,);
    }
  }

  Future<void> _generatePdf() async {
    // Render widget to image
    RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 10);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Create PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(pngBytes)),
          );
        },
      ),
    );

    // Get the device's documents directory
    final directory = await getApplicationDocumentsDirectory(); // Default directory for app documents
    // You can choose a path inside the app's document directory or another one if needed
    final documentsDirectory = Directory(path.join(directory.path, 'MyInvoices'));
    if (!await documentsDirectory.exists()) {
      await documentsDirectory.create(recursive: true); // Create the directory if it doesn't exist
    }

    // Save the PDF in the documents directory
    final filePath = path.join(directory.path, 'invoice.pdf'); // Modify the file path
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show a confirmation message or do something with the saved file
    Get.snackbar('PDF Created', 'Your PDF has been saved at $filePath');
  }

  Future<void> _printPdf() async {
    // Render widget to image
    RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 10);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Create PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(pngBytes)),
          );
        },
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _sharePdf() async {
    // Define the directory path where the PDF is saved
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'invoice.pdf'); // Ensure it matches the path used to save the PDF

    // Check if the file exists
    final file = File(filePath);
    if (await file.exists()) {
      // Share the PDF using Share Plus
      await Share.shareXFiles([XFile(file.path)], text: 'Here is your invoice!');
    } else {
      // Show an error message if the file is not found
      Get.snackbar('Error', 'PDF file not found for sharing');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Document n° ${widget.facture.invoiceNumber}',
        hasLeading: true,
        iconLeading: Icons.arrow_back_ios_new,
        onPressedLeading: () {
          Get.back();
        },
        hasActions: true,
        iconActions: CupertinoIcons.printer_fill,
        onPressedAction: () => _printPdf(),
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Column(
          children: [
            Center(
              child: Container(
                height: mq.height * 0.65,
                width: mq.width * 0.9,

                margin: EdgeInsets.only(top: mq.height * 0.05),
                // Adjust padding
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                // Show the selected facture model based on the controller's selectedModel
                child: InteractiveViewer(
                  maxScale: 4.0,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: _getSelectedModel(widget.facture.selectedModel),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: mq.width,
        height: mq.height * 0.17,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: bottomButtonInScreen(
          isText: false,
          bgColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.orangeColor,
          borderColor: Colors.black.withAlpha(80),
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.iconsShare, height: mq.height * 0.04,
                color: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.whiteColor,),
              Padding(
                padding: EdgeInsets.only(top: mq.height *0.01 ),
                child: boldText(text: ' Paratger', color: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.whiteColor,
                  fontSize: mq.aspectRatio * 50,),
              )
            ],
          ),
          onPressed: () async{
            _generatePdf().then((_) => _sharePdf());
          },
          horizontal: mq.width * 0.05,
          top: 0,
          bottom: mq.height * 0.1,
        ),
      ),
    );
  }

  Widget bottomDesignModel({
    required String name,
    required String assetIcon,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(mq.aspectRatio * 30),
            margin: EdgeInsets.only(bottom: mq.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
              border: Border.all(
                color: Colors.black.withAlpha(40),
              ),
            ),
            child: Image.asset(
              assetIcon,
              height: mq.aspectRatio * 80,
              isAntiAlias: true,
            ),
          ),
        ),
        normalText(text: name, fontSize: mq.aspectRatio * 40),
      ],
    );
  }
}
