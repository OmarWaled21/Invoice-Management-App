import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io'; // Add this import
import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/generated/assets.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/facture_model.dart';
import 'package:facturation_intuitive/screens/home_screen.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_1.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_2.dart';
import 'package:facturation_intuitive/utils/formatted_date.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import "package:path/path.dart" as path;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinaliserScreen extends StatefulWidget {
  const FinaliserScreen({super.key});

  @override
  State<FinaliserScreen> createState() => _FinaliserScreenState();
}

class _FinaliserScreenState extends State<FinaliserScreen> {
  final FactureModelController factureModelController = Get.find<FactureModelController>();
  final FactureController factureController = Get.find<FactureController>();

  final GlobalKey _globalKey = GlobalKey();
  String? filePath; // Class variable to hold the file path

  // Widget to show the selected model
  Widget getSelectedModel(int selectedModel) {
    switch (selectedModel) {
      case 2:
        return const FactureModel2();
      default:
        return const FactureModel1();
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

  void printFactureHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? factureHistory = prefs.getStringList('factureHistory') ?? [];

    if (factureHistory.isNotEmpty) {
      for (var facture in factureHistory) {
        // Assuming you have a fromJson method in your FactureModel to parse the JSON string
        FactureModel factureModel = FactureModel.fromJson(json.decode(facture));
        log("Facture: ${factureModel.invoiceNumber}, Client: ${factureModel.clientDetails!.address}, Total: ${factureModel.montantTotal} €");
      }
    } else {
      log("No facture history found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Document n° ${factureController.facture.value.invoiceNumber}',
        hasLeading: true,
        onPressedLeading: () => Get.back(),
        textLeading: 'Fremer',
        hasActions: true,
        onPressedAction: () async{
          // Save facture details when OK is pressed
          await factureController.saveFactureDetails();
          factureController.incrementInvoiceNumber();
          factureController.resetDocumentDate();
          factureController.clearItems();
          factureController.clearSelectedClientId();
          Get.snackbar('Success', 'Facture saved successfully!');
          log("Current montantTotal: ${factureController.montantTotal.value} €");

          Get.offAll(() => const HomeScreen());
          printFactureHistory();
        },
        textAction: 'OK',
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: mq.height * 0.65,
                width: mq.width * 0.9,
                child: Container(
                  margin: EdgeInsets.only(top: mq.height * 0.02),
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
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Obx(() => getSelectedModel(factureModelController.selectedModel.value)), // Wrap with Obx
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: mq.width,
        height: mq.height * 0.3,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    thinText(text: 'Montant total', fontSize: mq.aspectRatio * 35, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                    boldText(text: '${factureController.montantTotal.toStringAsFixed(2)} €', fontSize: mq.aspectRatio * 45, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    thinText(text: "Date d'échéance", fontSize: mq.aspectRatio * 35, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor),
                    boldText(text: FormattedDate(factureController.facture.value.dateEchance).originalFormattedDayLine, color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                        fontSize: mq.aspectRatio * 45)
                  ],
                ),
              ],
            ),
            Positioned(
              top: mq.height * 0.1,
              child: SizedBox(
                width: mq.width,
                height: mq.height * 0.17,
                child: _buildbottomButton(
                  iconString: Assets.iconsSend,
                  bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                  text: ' Envoyer',
                  onTap: () async{
                    factureController.clearFactureDetails();
                    _printPdf();
                    await factureController.saveFactureDetails();
                    Get.snackbar('Success', 'Facture saved successfully!');
                    factureController.incrementInvoiceNumber();
                    factureController.clearItems();
                    factureController.clearSelectedClientId();
                    factureController.resetDocumentDate();
                    Get.offAll(() => const HomeScreen());
                  },
                  iconColor: Colors.white,
                  txtColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: -mq.height * 0.08,
              child: SizedBox(
                width: mq.width,
                height: mq.height * 0.17,
                child: _buildbottomButton(
                  iconString: Assets.iconsShare,
                  text: ' Paratger',
                  onTap: () async{
                    _generatePdf().then((_) => _sharePdf());
                  },
                  bgColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
                  borderColor: isLightTheme ? ColorsTheme.blackColor.withAlpha(80) : ColorsTheme.orangeColor.withAlpha(150),
                  iconColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                  txtColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildbottomButton({required String iconString, required String text, required VoidCallback onTap,
    Color? bgColor, Color? borderColor, required Color txtColor, required Color iconColor}){
    return bottomButtonInScreen(
      isText: false,
      bgColor: bgColor,
      borderColor: borderColor,
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconString, height: mq.height * 0.04, color: iconColor,),
          Padding(
            padding: EdgeInsets.only(top: mq.height *0.01 ),
            child: boldText(text: text, color: txtColor, fontSize: mq.aspectRatio * 50),
          )
        ],
      ),
      onPressed: onTap,
      horizontal: mq.width * 0.05,
      top: 0,
      bottom: mq.height * 0.1,
    );
  }
}
