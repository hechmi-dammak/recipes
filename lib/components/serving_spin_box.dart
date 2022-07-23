import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/spin_box.dart';
import 'package:recipes/decorations/custom_input_decoration.dart';

class ServingSpinBox extends StatelessWidget {
  final int servings;
  final Function(int value) changeServingFunction;

  const ServingSpinBox(
      {Key? key, required this.servings, required this.changeServingFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinBox(
      incrementIcon: Icon(Icons.keyboard_arrow_right_rounded,
          size: 40, color: Get.theme.colorScheme.onSecondary),
      decrementIcon: Icon(Icons.keyboard_arrow_left_rounded,
          size: 40, color: Get.theme.colorScheme.onSecondary),
      decoration: CustomInputDecoration('Servings',
          contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15)),
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Get.theme.colorScheme.onSecondary),
      keyboardType: TextInputType.number,
      min: 1,
      max: double.infinity,
      value: servings.toDouble(),
      onChanged: (double value) {
        changeServingFunction(value.toInt());
      },
    );
  }
}
