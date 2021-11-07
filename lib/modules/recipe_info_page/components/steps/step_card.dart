import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page/controller/recipe_info_controller.dart';

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
          margin: const EdgeInsets.only(
            top: 30,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(5),
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
                    margin: const EdgeInsets.all(5.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        child: Text(
                          recipeInfoController.recipe.value.steps![widget.index]
                              .toDo!.capitalize!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        OrderButton(
            index: widget.index + 1,
            selected:
                recipeInfoController.recipe.value.steps![widget.index].selected)
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
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: CustomPaint(
              painter: ModalPainter(
                recipeInfoController
                            .recipe.value.steps![widget.index].selected ??
                        false
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).primaryColor,
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
                                    .onSecondary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary),
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
                                    .onSecondary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary),
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
                                      .onSecondary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary),
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
                                      .onSecondary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary),
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
  const OrderButton({Key? key, required this.index, this.selected})
      : super(key: key);
  final int index;
  final bool? selected;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      top: 0,
      child: Container(
        height: 60,
        width: 60,
        decoration: gradientDecoationRounded(context, selected: selected),
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