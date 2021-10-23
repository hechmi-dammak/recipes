import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(5),
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
                  recipesController.setRecipeSelected(widget.index);
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: recipesController.recipes[widget.index].picture !=
                                  null &&
                              recipesController
                                      .recipes[widget.index].picture!.image !=
                                  null
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Ink(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(recipesController
                                            .recipes[widget.index]
                                            .picture!
                                            .image!),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  flex: 5,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: SizedBox(
                                            height: double.infinity,
                                            width: double.infinity,
                                            child: RecipeDetails(
                                              recipesController:
                                                  recipesController,
                                              index: widget.index,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Ink(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: RecipeDetails(
                                    recipesController: recipesController,
                                    index: widget.index),
                              ),
                            ),
                    ),
                    if (recipesController.selectionIsActive.value)
                      SelectIndicator(
                          recipesController: recipesController,
                          index: widget.index)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelectIndicator extends StatelessWidget {
  const SelectIndicator({
    Key? key,
    required this.recipesController,
    required this.index,
  }) : super(key: key);

  final RecipesController recipesController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: (recipesController.recipes[index].selected ?? false)
            ? Container(
                margin: const EdgeInsets.all(15),
                child: Icon(Icons.check_circle_outline_outlined,
                    size: 30, color: Theme.of(context).colorScheme.secondary),
              )
            : Container(
                margin: const EdgeInsets.all(15),
                child: Icon(Icons.radio_button_unchecked_rounded,
                    size: 30, color: Theme.of(context).colorScheme.primary),
              ));
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
                color: Theme.of(context).buttonTheme.colorScheme!.onBackground),
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
                  color:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground),
            ),
          ),
      ],
    );
  }
}
