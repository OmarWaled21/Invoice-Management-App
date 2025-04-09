import 'package:facturation_intuitive/generated/assets.dart';
import 'package:flutter/material.dart';

Widget boldText({
  required String text,
  bool isUnderLine = false,
  double? endIndent,
  Color color = Colors.black,
  double fontSize = 18,
  String fontFamily = Assets.fontsArial,
  bool hasOverflow = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          height: isUnderLine ? 0.5 : kTextHeightNone,
          fontSize: fontSize,
          color: color,
          fontFamily: fontFamily
        ),
        overflow: hasOverflow ? TextOverflow.ellipsis : TextOverflow.visible,
        maxLines: hasOverflow ? 1 : null,
      ),
      isUnderLine
          ? Divider(
              color: color,
              thickness: 2,
              endIndent: endIndent,
            )
          : const SizedBox()
    ],
  );
}
