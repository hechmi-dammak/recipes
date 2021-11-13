import 'package:flutter/material.dart';
import 'package:recipes/utils/components/spin_box.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

class ServingSpinBox extends StatelessWidget {
  final int servings;
  final Function changeServingFunction;
  const ServingSpinBox(
      {Key? key, required this.servings, required this.changeServingFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinBox(
      incrementIcon: Icon(Icons.keyboard_arrow_right_rounded,
          size: 40, color: Theme.of(context).colorScheme.onSecondary),
      decrementIcon: Icon(Icons.keyboard_arrow_left_rounded,
          size: 40, color: Theme.of(context).colorScheme.onSecondary),
      decoration: getInputDecoration("Servings",
          contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15)),
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Theme.of(context).colorScheme.onSecondary),
      keyboardType: TextInputType.number,
      min: 1,
      max: double.infinity,
      value: servings.toDouble(),
      onChanged: (double value) {
        changeServingFunction(value);
      },
    );
  }
}
