import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
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
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(5),
        child: Ink(
          decoration: gradientDecorationSecondary(recipe.selected),
          child: InkWell(
            onTap: () => onTap(recipe),
            onLongPress: () => onLongPress(recipe),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: recipe.picture?.image != null
                      ? Row(
                          children: [
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
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: RecipeDetails(
                                          withPicture: true,
                                          recipe: recipe,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Ink(
                          decoration: BoxDecoration(
                              color: Get.theme.backgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: RecipeDetails(recipe: recipe),
                          ),
                        ),
                ),
                if (selectionIsActive) SelectIndicator(recipe: recipe)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectIndicator extends StatelessWidget {
  const SelectIndicator({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: (recipe.selected)
            ? Container(
                margin: const EdgeInsets.all(15),
                child: Icon(Icons.check_circle_outline_outlined,
                    size: 30, color: Get.theme.colorScheme.secondary),
              )
            : Container(
                margin: const EdgeInsets.all(15),
                child: Icon(Icons.radio_button_unchecked_rounded,
                    size: 30, color: Get.theme.colorScheme.primary),
              ));
  }
}

class RecipeDetails extends StatelessWidget {
  const RecipeDetails(
      {super.key, required this.recipe, this.withPicture = false});

  final Recipe recipe;
  final bool withPicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          withPicture ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
              bottom: 10, left: !withPicture ? 35 : 0.0, right: 35),
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
