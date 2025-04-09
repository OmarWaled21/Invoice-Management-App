import 'dart:typed_data';
import 'dart:ui';

import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_1.dart';
import 'package:facturation_intuitive/screens/personalization_facture/facture_model/facture_model_2.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class ApercuScreen extends StatefulWidget {
  const ApercuScreen({super.key});

  @override
  State<ApercuScreen> createState() => _ApercuScreenState();
}
final GlobalKey _globalKey = GlobalKey();

Future<void> _printPdf() async {
  // Ensure the widget is built before accessing context
  final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    debugPrint("RenderRepaintBoundary is null, cannot capture image.");
    return;
  }

  final image = await boundary.toImage(pixelRatio: 10);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  // Create PDF
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.symmetric(horizontal: mq.width * 0.05),
      clip: true,
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

class _ApercuScreenState extends State<ApercuScreen> {
  @override
  Widget build(BuildContext context) {
    final FactureModelController factureModelController = Get.find<FactureModelController>();
    final FactureController factureController = Get.find<FactureController>();

    // Widget to show the selected model
    Widget getSelectedModel(int selectedModel) {
      switch (selectedModel) {
        case 2:
          return const FactureModel2();
        default:
          return const FactureModel1();
      }
    }
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Document n° ${factureController.facture.value.invoiceNumber}',
        hasLeading: true,
        onPressedLeading: () => Get.back(),
        textLeading: 'Fremer',
        hasActions: true,
        onPressedAction: () => _printPdf(),
        iconActions: Icons.print,
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
                  // Wrap the selected model with InteractiveViewer for zooming
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Obx(() => getSelectedModel(factureModelController.selectedModel.value)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
