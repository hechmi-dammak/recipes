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
        return Container(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(3),
              child: Ink(
                decoration: gradientDecoationSecondery(context,
                    selected:
                        (recipesController.recipes[widget.index].selected ??
                            false)),
                child: InkWell(
                  onTap: () {
                    if (recipesController.selectionIsActive.value) {
                      recipesController.setRecipeSelected(widget.index);
                    } else {
                      recipesController.setDialOpen(false);
                      Get.to(() => RecipeInfoPage(
                          recipeId:
                              recipesController.recipes[widget.index].id));
                    }
                  },
                  onLongPress: () {
                    HapticFeedback.vibrate();
                    recipesController.setRecipeSelected(widget.index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: recipesController.recipes[widget.index].picture !=
                                null &&
                            recipesController
                                    .recipes[widget.index].picture!.image !=
                                null
                        ? Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  width: 120,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: recipesController
                                                      .recipes[widget.index]
                                                      .selected ??
                                                  false
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                          width: 4),
                                      borderRadius: BorderRadius.circular(8),
                                      // shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(recipesController
                                              .recipes[widget.index]
                                              .picture!
                                              .image!)))),
                              Expanded(
                                child: RecipeDetails(
                                    recipesController: recipesController,
                                    index: widget.index,
                                    withPicture: true),
                              ),
                            ],
                          )
                        : RecipeDetails(
                            recipesController: recipesController,
                            index: widget.index),
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

class RecipeDetails extends StatelessWidget {
  const RecipeDetails(
      {Key? key,
      required this.recipesController,
      required this.index,
      this.withPicture = false})
      : super(key: key);

  final RecipesController recipesController;
  final int index;
  final bool withPicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          withPicture ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            recipesController.recipes[index].name.capitalize!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: (recipesController.recipes[index].selected ?? false)
                    ? Theme.of(context).buttonTheme.colorScheme!.onPrimary
                    : Theme.of(context).buttonTheme.colorScheme!.onSecondary),
          ),
        ),
        if (recipesController.recipes[index].category != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              recipesController.recipes[index].category!.capitalize!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: (recipesController.recipes[index].selected ?? false)
                      ? Theme.of(context).buttonTheme.colorScheme!.onPrimary
                      : Theme.of(context).buttonTheme.colorScheme!.onSecondary),
            ),
          ),
      ],
    );
  }
}
