import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page.dart/controller/recipe_info_controller.dart';

import 'ingredient_card.dart';

class IngredientsList extends StatelessWidget {
  final RecipeInfoController recipeInfoController = RecipeInfoController.find;
  IngredientsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (_) {
        if (recipeInfoController.recipe.value.ingredientsByCategory == null) {
          return Container();
        }
        List<Widget> children = [];
        recipeInfoController.recipe.value.ingredientsByCategory!
            .forEach((key, value) {
          children.add(Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              key.capitalize!,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25, color: Theme.of(context).primaryColor),
            ),
          ));

          children.add(Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: value.length < 5 ? 150 : 300,
            child: GridView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: value.length < 5
                    ? 1
                    : min(2, (MediaQuery.of(context).size.width / 350).ceil()),
                mainAxisExtent: 250,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return IngredientCard(
                  ingredient: value[index],
                  servings: recipeInfoController.servings.value,
                  recipeServings: recipeInfoController.recipe.value.servings,
                );
              },
              itemCount: value.length,
            ),
          ));
        });
        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: children,
        );
      },
    );
  }
}
