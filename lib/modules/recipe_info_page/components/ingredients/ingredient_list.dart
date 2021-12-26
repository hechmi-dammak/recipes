import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page/controller/recipe_info_controller.dart';

import 'ingredient_card.dart';
import 'package:expandable/expandable.dart';

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
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ExpandablePanel(
              controller: ExpandableController(initialExpanded: true),
              header: Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  key.capitalize!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25, color: Theme.of(context).primaryColor),
                ),
              ),
              theme: ExpandableThemeData(
                  tapBodyToExpand: false,
                  tapHeaderToExpand: true,
                  iconPadding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                  iconSize: 25,
                  iconColor: Theme.of(context).primaryColor,
                  collapseIcon: Icons.remove_circle_outline_rounded,
                  expandIcon: Icons.add_circle_outline_rounded),
              collapsed: Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.primary,
                indent: 5,
                endIndent: 5,
              ),
              expanded: GridView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.75,
                  crossAxisCount: value.length < 5
                      ? 1
                      : min(
                          2, (MediaQuery.of(context).size.width / 350).ceil()),
                  mainAxisExtent: 120,
                ),
                itemBuilder: (context, index) {
                  return IngredientCard(
                    ingredient: value[index],
                    servings: recipeInfoController.servings.value,
                    recipeServings: recipeInfoController.recipe.value.servings,
                  );
                },
                itemCount: value.length,
              ),
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
