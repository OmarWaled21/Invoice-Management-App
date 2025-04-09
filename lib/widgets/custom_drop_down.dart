import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:facturation_intuitive/widgets/text_widgets/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final double pickerHeight;
  final Color color;
  final Color txtColor;
  final Color bgColor;

  const CustomDropDown({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
    required this.color,
    required this.txtColor,
    required this.bgColor,
    this.pickerHeight = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boldText(text: title, color: txtColor),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with "OK" button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      color: bgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          boldText(text: title, color: color, fontSize: 16),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: boldText(text: 'OK', color: color, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // CupertinoPicker for selecting options
                    SizedBox(
                      height: MediaQuery.of(context).size.height * pickerHeight,
                      child: CupertinoPicker(
                        backgroundColor: bgColor,
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: options.indexOf(selectedValue),
                        ),
                        onSelectedItemChanged: (int index) {
                          onSelected(options[index]);
                        },
                        children: options.map((String option) {
                          return boldText(text: option, color: color);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: txtColor.withAlpha(80)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                normalText(text: selectedValue, fontSize: mq.aspectRatio * 35, color: txtColor),
                Icon(Icons.arrow_drop_down, color: color,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
