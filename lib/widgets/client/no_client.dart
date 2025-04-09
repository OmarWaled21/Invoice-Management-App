import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget NoClientData() {
  return Column(
    children: [
      Image.asset(
        'assets/no_client.png',
        height: mq.height * 0.2,
      ),
      boldText(text: 'Aucun client enregistré')
    ],
  );
}
