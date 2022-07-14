import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/modules/recipe_edit_page/components/instruction_edit/instruction_edit_card_components.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class InstructionEditCard extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final int index;

  const InstructionEditCard({
    Key? key,
    required this.index,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  InstructionEditCardState createState() => InstructionEditCardState();
}

class InstructionEditCardState extends State<InstructionEditCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;
  final _instructionCardKey = GlobalKey<InsideInstructionCardState>();

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
                        decoration: gradientDecorationSecondary(
                            recipeEditController
                                .recipe.instructions[widget.index].selected),
                        child: InkWell(
                          onTap: () {
                            if (recipeEditController.selectionIsActive) {
                              recipeEditController.setItemSelected(
                                  recipeEditController
                                      .recipe.instructions[widget.index]);
                            }
                          },
                          onLongPress: () {
                            recipeEditController.setItemSelected(
                                recipeEditController
                                    .recipe.instructions[widget.index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: Get.theme.backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Container(
                                width: double.infinity,
                                constraints:
                                    const BoxConstraints(minHeight: 100),
                                padding: const EdgeInsets.only(
                                    top: 40, left: 10, right: 10, bottom: 10),
                                child: InsideInstructionCard(
                                    key: _instructionCardKey,
                                    index: widget.index),
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
                if (recipeEditController.selectionIsActive)
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
        key: recipeEditController.recipe.instructions[widget.index].key ??
            ValueKey(widget.index), //
        childBuilder: _buildChild);
  }

  Future validate() async {
    if (_instructionCardKey.currentState == null) {
      recipeEditController.validation = false;
    } else {
      await _instructionCardKey.currentState!.validate();
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
        child: (recipeEditController.recipe.instructions[index].selected)
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
