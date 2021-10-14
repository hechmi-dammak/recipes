import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/services.dart';
import 'package:recipes/modules/recipe_info_page.dart/page/recipe_info_page.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

class RecipeCard extends StatefulWidget {
  final int index;
  const RecipeCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final RecipesController recipesController = RecipesController.find;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: Ink(
            decoration: gradientDecoationSecondery(context,
                selected: (recipesController.recipes[widget.index].selected ??
                    false)),
            child: InkWell(
              onTap: () {
                if (recipesController.selectionIsActive.value) {
                  recipesController.setRecipeSelected(widget.index);
                } else {
                  Get.to(() => RecipeInfoPage(
                      recipeId: recipesController.recipes[widget.index].id));
                }
              },
              onLongPress: () {
                HapticFeedback.vibrate();
                recipesController.setRecipeSelected(widget.index);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    recipesController.recipes[widget.index].name.capitalize!,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
