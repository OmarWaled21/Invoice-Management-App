import 'package:facturation_intuitive/generated/assets.dart';
import 'package:flutter/material.dart';

Widget thinText(
    {required String text,
    required double fontSize,
    required Color color,
    bool hasOverFlow = false,
    TextOverflow overFlow = TextOverflow.visible,
    int? maxlines = 3,
    String fontFamily = Assets.fontsArial}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      overflow: overFlow,
    ),
    maxLines: hasOverFlow ? 1 : maxlines,
  );
}
