import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/utils/string_extenstions.dart';

import 'ingredient_card.dart';

class IngredientsList extends StatelessWidget {
  final int servings;
  final Map<String, List<Ingredient>>? ingredientsByCategory;
  const IngredientsList(
      {Key? key, this.ingredientsByCategory, required this.servings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ingredientsByCategory == null) {
      return Container();
    }
    List<Widget> children = [];
    ingredientsByCategory!.forEach((key, value) {
      children.add(Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(
          key.capitalize(),
          style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        ),
      ));
      if (key == "spices") {
        children.add(Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 150,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return IngredientCard(
                servings: servings,
                ingredient: value[index],
              );
            },
            itemCount: value.length,
          ),
        ));
      } else {
        children.add(Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 300,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.5,
              crossAxisCount:
                  min(2, (MediaQuery.of(context).size.width / 350).ceil()),
              mainAxisExtent: 300,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return IngredientCard(
                ingredient: value[index],
                servings: servings,
              );
            },
            itemCount: value.length,
          ),
        ));
      }
    });
    return Column(
      children: children,
    );
  }
}
