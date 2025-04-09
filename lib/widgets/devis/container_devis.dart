import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/thin_text.dart';
import 'package:flutter/material.dart';

Widget containerDevis({
  required String title,
  bool hasSubTitle = false,
  String? subTitle1,
  String? subTitle2,
  bool isUnderLine = false,
  double? endIndent,
  double fontSize = 18,
  VoidCallback? onPressed,
  required Color titleColor,
  required Color subTitleColor,
  required Color iconColor,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: EdgeInsets.only(bottom: mq.height * 0.03),
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: mq.height * 0.02),
      width: mq.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(mq.aspectRatio * 30),
      ),
      child: hasSubTitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(text: title, isUnderLine: isUnderLine, endIndent: endIndent, color: titleColor),
                Row(
                  children: [
                    thinText(
                      text: subTitle1!,
                      fontSize: mq.aspectRatio * 30,
                      color: subTitleColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                      child: Container(
                        width: mq.aspectRatio * 10,
                        height: mq.aspectRatio * 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    thinText(
                      text: subTitle2!,
                      fontSize: mq.aspectRatio * 30,
                      color: subTitleColor,
                    ),
                  ],
                )
              ],
            )
          : Row(
              children: [
                isUnderLine ? Icon(
                  Icons.add_circle,
                  color: iconColor,
                ): const SizedBox(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: mq.width * 0.03,
                        right: mq.width * 0.03,
                        top: mq.height * 0.01),
                    child: boldText(
                      fontSize: fontSize,
                      text: title,
                      isUnderLine: isUnderLine,
                      endIndent: endIndent,
                      color: titleColor
                    ),
                  ),
                )
              ],
            ),
    ),
  );
}
