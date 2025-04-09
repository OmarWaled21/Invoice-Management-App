import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget selectedDate(String title, VoidCallback onPressed, String date, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      boldText(text: title, color: color),
      GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: color.withAlpha(80)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              normalText(text: date, fontSize: mq.aspectRatio * 35, color: color),
              Icon(Icons.arrow_drop_down, color: color,),
            ],
          ),
        ),
      ),
    ],
  );
}


Future<void> selectDateTime(
    BuildContext context,
    State state,
    DateTime initialDate,
    Function(DateTime) onDateSelected,
    ) async {
  await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (_) => Container(
      height: 300,
      color: CupertinoColors.systemBackground,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: initialDate,
              onDateTimeChanged: (DateTime newDate) {
                onDateSelected(newDate);
              },
              use24hFormat: true,
            ),
          ),
          CupertinoButton(
            child: const Text('OK', style: TextStyle(color: CupertinoColors.activeBlue)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}
