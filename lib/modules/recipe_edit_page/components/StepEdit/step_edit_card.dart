import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

import 'step_edit_card_components.dart';

class StepEditCard extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final int index;
  const StepEditCard({
    Key? key,
    required this.index,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  StepEditCardState createState() => StepEditCardState();
}

class StepEditCardState extends State<StepEditCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;
  final _stepCardKey = GlobalKey<InsideStepCardState>();
  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(5),
                      child: Ink(
                        decoration: gradientDecoationSecondery(context,
                            selected: recipeEditController
                                .recipe.value.steps![widget.index].selected),
                        child: InkWell(
                          onTap: () {
                            if (recipeEditController.selectionIsActive.value) {
                              recipeEditController.setItemSelected(
                                  recipeEditController
                                      .recipe.value.steps![widget.index]);
                            }
                          },
                          onLongPress: () {
                            recipeEditController.setItemSelected(
                                recipeEditController
                                    .recipe.value.steps![widget.index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Container(
                                width: double.infinity,
                                constraints:
                                    const BoxConstraints(minHeight: 100),
                                padding: const EdgeInsets.only(
                                    top: 40, left: 10, right: 10, bottom: 10),
                                child: InsideStepCard(
                                    key: _stepCardKey, index: widget.index),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                EditButton(index: widget.index),
                const DragButton(),
                if (recipeEditController.selectionIsActive.value)
                  SelectIndicator(
                    index: widget.index,
                  )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: recipeEditController.recipe.value.steps![widget.index].key ??
            ValueKey(widget.index), //
        childBuilder: _buildChild);
  }

  Future validate() async {
    if (_stepCardKey.currentState == null) {
      recipeEditController.validation = false;
    } else {
      await _stepCardKey.currentState!.validate();
    }
  }
}

class SelectIndicator extends StatelessWidget {
  SelectIndicator({
    Key? key,
    required this.index,
  }) : super(key: key);
  final RecipeEditController recipeEditController = RecipeEditController.find;

  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 50,
        right: 10,
        child:
            (recipeEditController.recipe.value.steps![index].selected ?? false)
                ? Container(
                    margin: const EdgeInsets.all(15),
                    child: Icon(Icons.check_circle_outline_outlined,
                        size: 30,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                : Container(
                    margin: const EdgeInsets.all(15),
                    child: Icon(Icons.radio_button_unchecked_rounded,
                        size: 30, color: Theme.of(context).colorScheme.primary),
                  ));
  }
}
