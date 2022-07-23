import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/modules/recipe_info_page/components/instructions/instruction_info_bottom_sheet.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

class InstructionCard extends StatelessWidget {
  final Instruction instruction;
  final int index;

  const InstructionCard({
    Key? key,
    required this.index,
    required this.instruction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(builder: (recipeInfoController) {
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
                  decoration:
                      GradientDecoration.secondary(instruction.selected),
                  child: InkWell(
                    onLongPress: () => InstructionInfoBottomSheet(
                            instruction: instruction, index: index)
                        .show(),
                    onTap: () {
                      recipeInfoController
                          .toggleInstructionSelected(instruction);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Get.theme.backgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: Text(
                            instruction.toDo.capitalize!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.buttonTheme.colorScheme!
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
          _OrderButton(index: index + 1, selected: instruction.selected)
        ],
      );
    });
  }
}

class _OrderButton extends StatelessWidget {
  const _OrderButton({required this.index, required this.selected});

  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      top: 0,
      child: Container(
        height: 60,
        width: 60,
        decoration: GradientDecoration.rounded(selected),
        child: Center(
          child: Text(
            index.toString(),
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: Get.theme.colorScheme.onPrimary, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
