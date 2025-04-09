
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/material.dart';

Widget informationProfile({
  required String title,
  required VoidCallback onTap,
  IconData? icon,
  String? iconAsset,
  required String text,
  VoidCallback? secOnTap,
  String? secText,
  IconData? secIcon,
  String? secIconAsset,
  VoidCallback? thrdOnTap,
  String? thrdText,
  IconData? thrdIcon,
  String? thrdIconAsset,
  required Color txtColor,
  required Color iconColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * 0.05),
        child: boldText(text: title.toUpperCase(), color: iconColor),
      ),
      Container(
        width: mq.width,
        decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.black.withAlpha(20)))),
        child: ListTile(
          onTap: onTap,
          leading: icon != null ? Icon(icon, color: iconColor,)
            : Image.asset(iconAsset!, height: mq.aspectRatio * 50,isAntiAlias: true,color: iconColor,),
          title: normalText(text: text, fontSize: mq.aspectRatio * 40, color: txtColor),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: mq.aspectRatio * 30,
            color: iconColor,
          ),
        ),
      ),
      if(secText != null)
        Container(
          width: mq.width,
          // margin: EdgeInsets.symmetric(vertical: mq.height * .02),
          decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.black.withAlpha(20)))),
          child: ListTile(
            onTap: secOnTap,
            leading: secIcon != null ? Icon(secIcon, color: iconColor,)
              : Image.asset(secIconAsset!, height: mq.aspectRatio * 50,isAntiAlias: true, color: iconColor,),
            title: normalText(text: secText, fontSize: mq.aspectRatio * 40, color: txtColor),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: mq.aspectRatio * 30,
              color: iconColor,
            ),
          ),
        ),
    ],
  );
}