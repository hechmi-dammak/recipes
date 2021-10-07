import 'package:flutter/material.dart';

InputDecoration getInputDecoration(BuildContext context, String label) {
  return InputDecoration(
    label: Text(label,
        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Theme.of(context).backgroundColor,
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderSide:
          BorderSide(width: 3, color: Theme.of(context).colorScheme.secondary),
    ),
  );
}
