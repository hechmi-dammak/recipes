import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipes/controller/recipe_info_controller.dart';
import 'package:get/get.dart';

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
            height: 30,
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              key.capitalize!,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
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
                    servings: recipeInfoController.servings.value,
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
                    servings: recipeInfoController.servings.value,
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
      },
    );
  }
}
