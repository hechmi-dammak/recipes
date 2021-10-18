import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page.dart/controller/recipe_info_controller.dart';

import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/modal_paint.dart';

class StepCard extends StatefulWidget {
  final int index;
  const StepCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<StepCard> createState() => StepCardState();
}

class StepCardState extends State<StepCard> {
  final RecipeInfoController recipeInfoController = RecipeInfoController.find;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 20),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: gradientDecoationSecondery(context,
                  selected: recipeInfoController
                          .recipe.value.steps![widget.index].selected ??
                      false),
              child: InkWell(
                onLongPress: () => _onLongPress(context),
                onTap: () {
                  setState(() {
                    recipeInfoController.recipe.value.steps![widget.index]
                        .selected = !(recipeInfoController
                            .recipe.value.steps![widget.index].selected ??
                        true);
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                  child: Text(
                    recipeInfoController
                        .recipe.value.steps![widget.index].toDo!.capitalize!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: recipeInfoController.recipe.value
                                    .steps![widget.index].selected ??
                                false
                            ? Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary
                            : Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onSecondary),
                  ),
                ),
              ),
            ),
          ),
        ),
        OrderButton(
          index: widget.index + 1,
        )
      ],
    );
  }

  _onLongPress(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: recipeInfoController
                            .recipe.value.steps![widget.index].selected ??
                        false
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: CustomPaint(
              painter: ModalPainter(
                recipeInfoController
                            .recipe.value.steps![widget.index].selected ??
                        false
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Text(
                        "To Do:",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: recipeInfoController.recipe.value
                                        .steps![widget.index].selected ??
                                    false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                      title: Text(
                        recipeInfoController.recipe.value.steps![widget.index]
                            .toDo!.capitalize!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: recipeInfoController.recipe.value
                                        .steps![widget.index].selected ??
                                    false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                    ),
                  ),
                  if (recipeInfoController
                          .recipe.value.steps![widget.index].order !=
                      null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "Step order:",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: recipeInfoController.recipe.value
                                          .steps![widget.index].selected ??
                                      false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                        title: Text(
                          (widget.index + 1).toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: recipeInfoController.recipe.value
                                          .steps![widget.index].selected ??
                                      false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      top: 0,
      child: Container(
        height: 60,
        width: 60,
        decoration: gradientDecoationRounded(context),
        child: Center(
          child: Text(
            index.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
