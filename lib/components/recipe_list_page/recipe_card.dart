import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/controller/recipes_controller.dart';
import 'package:recipes/routes/recipe_info_page.dart';
import 'package:flutter/services.dart';

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
      builder: (recipesController) {
        return GestureDetector(
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).buttonTheme.colorScheme!.primary,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [
                  0.1,
                  0.9,
                ],
                colors:
                    (recipesController.recipes[widget.index].selected ?? false)
                        ? [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primaryVariant
                          ]
                        : [
                            Theme.of(context).colorScheme.secondaryVariant,
                            Theme.of(context).colorScheme.secondary
                          ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                recipesController.recipes[widget.index].name.capitalize!,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        Theme.of(context).buttonTheme.colorScheme!.onPrimary),
              ),
            ),
          ),
        );
      },
    );
  }
}
