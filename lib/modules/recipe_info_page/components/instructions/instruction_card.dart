import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/modal_paint.dart';

class InstructionCard extends StatefulWidget {
  final Instruction instruction;
  final int index;

  const InstructionCard({
    Key? key,
    required this.index,
    required this.instruction,
  }) : super(key: key);

  @override
  State<InstructionCard> createState() => InstructionCardState();
}

class InstructionCardState extends State<InstructionCard> {
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
                      gradientDecorationSecondary(widget.instruction.selected),
                  child: InkWell(
                    onLongPress: () => _onLongPress(context),
                    onTap: () {
                      setState(() {
                        widget.instruction.selected =
                            !(widget.instruction.selected);
                      });
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
                            widget.instruction.toDo.capitalize!,
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
          OrderButton(
              index: widget.index + 1, selected: widget.instruction.selected)
        ],
      );
    });
  }

  void _onLongPress(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return GetBuilder<RecipeInfoController>(
              builder: (recipeInfoController) {
            return Container(
              decoration: BoxDecoration(
                  color: widget.instruction.selected
                      ? Get.theme.colorScheme.secondary
                      : Get.theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: CustomPaint(
                painter: ModalPainter(
                  widget.instruction.selected
                      ? Get.theme.colorScheme.secondary
                      : Get.theme.primaryColor,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          'To Do:',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.instruction.selected
                                  ? Get.theme.buttonTheme.colorScheme!
                                      .onSecondary
                                  : Get.theme.buttonTheme.colorScheme!
                                      .onPrimary),
                        ),
                        title: Text(
                          widget.instruction.toDo.capitalize!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.instruction.selected
                                  ? Get.theme.buttonTheme.colorScheme!
                                      .onSecondary
                                  : Get.theme.buttonTheme.colorScheme!
                                      .onPrimary),
                        ),
                      ),
                    ),
                    if (widget.instruction.order != null)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          leading: Text(
                            'Instruction order:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: widget.instruction.selected
                                    ? Get.theme.buttonTheme.colorScheme!
                                        .onSecondary
                                    : Get.theme.buttonTheme.colorScheme!
                                        .onPrimary),
                          ),
                          title: Text(
                            (widget.index + 1).toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.instruction.selected
                                    ? Get.theme.buttonTheme.colorScheme!
                                        .onSecondary
                                    : Get.theme.buttonTheme.colorScheme!
                                        .onPrimary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
        });
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key, required this.index, required this.selected})
      : super(key: key);
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
        decoration: gradientDecorationRounded(selected),
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
