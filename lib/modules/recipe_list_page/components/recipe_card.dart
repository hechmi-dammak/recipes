import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_card.dart';
import 'package:recipes/components/selected_indicator.dart';
import 'package:recipes/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final void Function(Recipe recipe) onTap;
  final void Function(Recipe recipe) onLongPress;
  final bool selectionIsActive;

  const RecipeCard({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.recipe,
    required this.selectionIsActive,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        onTap: () => onTap(recipe),
        onLongPress: () => onLongPress(recipe),
        selected: recipe.selected,
        child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    if (recipe.picture?.image != null) ...[
                      Flexible(
                        flex: 3,
                        child: Ink(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(recipe.picture!.image!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                    Flexible(
                      flex: 5,
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Get.theme.backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            )),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: _RecipeDetails(
                                  recipe: recipe,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            if (selectionIsActive) SelectIndicator(selected: recipe.selected)
          ],
        ));
  }
}

class _RecipeDetails extends StatelessWidget {
  const _RecipeDetails({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: recipe.picture?.image != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
              bottom: 10,
              left: recipe.picture?.image == null ? 35 : 0,
              right: 35),
          child: Text(
            recipe.name.capitalize!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Get.theme.buttonTheme.colorScheme!.onBackground),
          ),
        ),
        if (recipe.category != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              recipe.category!.capitalize!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.buttonTheme.colorScheme!.onBackground),
            ),
          ),
      ],
    );
  }
}
