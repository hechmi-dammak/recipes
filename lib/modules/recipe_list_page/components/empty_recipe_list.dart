import 'package:flutter/material.dart';

class EmptyRecipeList extends StatelessWidget {
  const EmptyRecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Center(
          child: Text(
        'No recipes exists yet.\nPress import to load new recipes or you can  create your own.',
        style: TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      )),
    );
  }
}
