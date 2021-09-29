import 'package:flutter/material.dart';

void showInSnackBar(String value, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        value,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
    ),
  );
}
