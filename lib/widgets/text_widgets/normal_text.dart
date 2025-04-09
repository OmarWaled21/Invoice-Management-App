import 'package:facturation_intuitive/generated/assets.dart';
import 'package:flutter/material.dart';

Widget normalText({required String text, required double fontSize, Color color = Colors.black, bool hasOverFlow = true, String fontFamily = Assets.fontsArial}) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize, color: color, fontFamily: fontFamily),
    maxLines: hasOverFlow ? 1 : 4,
    overflow: hasOverFlow ? TextOverflow.ellipsis : TextOverflow.visible,
  );
}
