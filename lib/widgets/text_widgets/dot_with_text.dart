import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';

Widget dotWithText({required Color color, required String text}){
  return Row(
    children: [
      Container(
        margin: const EdgeInsets.only(right: 3),
        width: mq.aspectRatio * 20,
        height: mq.aspectRatio * 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      thinText(text: text, fontSize: mq.aspectRatio * 40, color: Colors.grey.shade600)
    ],
  );
}