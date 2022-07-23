import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_bottom_sheet.dart';
import 'package:recipes/decorations/modal_paint.dart';
import 'package:recipes/models/instruction.dart';

class InstructionInfoBottomSheet extends CustomBottomSheet {
  final Instruction instruction ;
final int index;

  const InstructionInfoBottomSheet(
      {required this.instruction,
      required this.index,

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: instruction.selected
              ? Get.theme.colorScheme.secondary
              : Get.theme.primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0))),
      child: CustomPaint(
        painter: ModalPainter(
          instruction.selected
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
                      color: instruction.selected
                          ? Get.theme.buttonTheme.colorScheme!
                          .onSecondary
                          : Get.theme.buttonTheme.colorScheme!
                          .onPrimary),
                ),
                title: Text(
                  instruction.toDo.capitalize!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: instruction.selected
                          ? Get.theme.buttonTheme.colorScheme!
                          .onSecondary
                          : Get.theme.buttonTheme.colorScheme!
                          .onPrimary),
                ),
              ),
            ),
            if (instruction.order != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Text(
                    'Instruction order:',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: instruction.selected
                            ? Get.theme.buttonTheme.colorScheme!
                            .onSecondary
                            : Get.theme.buttonTheme.colorScheme!
                            .onPrimary),
                  ),
                  title: Text(
                    (index + 1).toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: instruction.selected
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
  }

}
