import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class ServingSpinBox extends StatelessWidget {
  final int servings;
  final Function changeServingFunction;
  const ServingSpinBox(
      {Key? key, required this.servings, required this.changeServingFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinBox(
      incrementIcon: const Icon(Icons.keyboard_arrow_right_rounded, size: 50),
      decrementIcon: const Icon(Icons.keyboard_arrow_left_rounded, size: 50),
      decoration: InputDecoration(
          label: Text("Servings",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor))),
      textStyle: TextStyle(
          fontSize: 18, color: Theme.of(context).colorScheme.secondary),
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
