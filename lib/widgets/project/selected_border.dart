import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';

class SelectedBorder extends StatelessWidget {
  const SelectedBorder(
      {Key? key,
      required this.selected,
      this.height = double.infinity,
      this.width = double.infinity})
      : super(key: key);
  final bool selected;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        condition: selected,
        child: (context) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                border: Border.all(
                  width: Constants.selectionBorderWidth,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
            ));
  }
}
