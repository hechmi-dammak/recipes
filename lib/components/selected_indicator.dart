import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectIndicator extends StatelessWidget {
  const SelectIndicator({
    super.key,
    required this.selected,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: (selected)
            ? Container(
          margin: const EdgeInsets.all(15),
          child: Icon(Icons.check_circle_outline_outlined,
              size: 30, color: Get.theme.colorScheme.secondary),
        )
            : Container(
          margin: const EdgeInsets.all(15),
          child: Icon(Icons.radio_button_unchecked_rounded,
              size: 30, color: Get.theme.colorScheme.primary),
        ));
  }
}
