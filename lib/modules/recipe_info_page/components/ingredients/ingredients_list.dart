import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page/components/ingredients/ingredient_card.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

class IngredientsList extends StatelessWidget {
  const IngredientsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (recipeInfoController) {
        if (recipeInfoController.recipe.ingredientsByCategory == null) {
          return Container();
        }
        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: recipeInfoController.recipe.ingredientsByCategory!.entries
              .map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ExpandablePanel(
                controller: ExpandableController(initialExpanded: true),
                header: Container(
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    entry.key.capitalize!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25, color: Get.theme.primaryColor),
                  ),
                ),
                theme: ExpandableThemeData(
                    tapBodyToExpand: false,
                    tapHeaderToExpand: true,
                    iconPadding:
                        const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                    iconSize: 25,
                    iconColor: Get.theme.primaryColor,
                    collapseIcon: Icons.remove_circle_outline_rounded,
                    expandIcon: Icons.add_circle_outline_rounded),
                collapsed: Divider(
                  thickness: 2,
                  color: Get.theme.colorScheme.primary,
                  indent: 5,
                  endIndent: 5,
                ),
                expanded: GridView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: entry.value.length < 5
                        ? 1
                        : min(2,
                            (MediaQuery.of(context).size.width / 350).ceil()),
                    mainAxisExtent: 120,
                  ),
                  itemBuilder: (context, index) {
                    return IngredientCard(
                      ingredient: entry.value[index],
                      servings: recipeInfoController.servings,
                      recipeServings: recipeInfoController.recipe.servings,
                    );
                  },
                  itemCount: entry.value.length,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
