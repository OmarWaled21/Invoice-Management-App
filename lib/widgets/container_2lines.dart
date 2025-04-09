import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';

Widget container2Lines({
  required String leftText,
  required String rightText,
  required Color rightColor,
  required Color leftColor,
  bool isExpanded = false,
}){
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
    width: mq.width,
    decoration: BoxDecoration(
      border: Border.symmetric(horizontal: BorderSide(color: Colors.black.withAlpha(20))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        normalText(text: leftText, fontSize: mq.aspectRatio * 40, color: leftColor),
        isExpanded ? Expanded(
          child: normalText(
            text: rightText,
            color: rightColor,
            fontSize: mq.aspectRatio * 35,
          ),
        ) : normalText(
          text: rightText,
          color: rightColor,
          fontSize: mq.aspectRatio * 35,
        ),
      ],
    ),
  );
}