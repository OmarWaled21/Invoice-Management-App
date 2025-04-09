import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:flutter/material.dart';

Widget bottomButtonInScreen({String? text, required VoidCallback onPressed, required double horizontal,
  required double top, required double bottom, bool isText = true, Widget? widget,
  Color? bgColor, Color? txtColor, Color? borderColor}){
  return Padding(
    padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
    child: SizedBox(
      height: mq.height * 0.05,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor?? Colors.transparent),
          borderRadius: BorderRadius.circular(mq.aspectRatio * 20),
        ),
        color: bgColor ?? Colors.blueAccent,
        padding: EdgeInsets.only(top: mq.height*0.012),
        child: isText ? boldText(text: text!, color: Colors.white) : widget,
      ),
    ),
  );
}