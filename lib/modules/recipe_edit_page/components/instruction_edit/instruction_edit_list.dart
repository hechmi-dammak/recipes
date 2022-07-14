import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/instruction_edit/instruction_edit_card.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class InstructionEditList extends StatefulWidget {
  const InstructionEditList({Key? key}) : super(key: key);

  @override
  InstructionEditListState createState() => InstructionEditListState();
}

class InstructionEditListState extends State<InstructionEditList> {
  final RecipeEditController recipeEditController = RecipeEditController.find;
  List<GlobalObjectKey<InstructionEditCardState>> instructionListKeys = [];
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
    instructionListKeys = List.generate(
        recipeEditController.recipe.instructions.length,
        (index) => GlobalObjectKey<InstructionEditCardState>(index));
    children = List.generate(
        recipeEditController.recipe.instructions.length,
        (index) => InstructionEditCard(
            key: instructionListKeys[index],
            index: index,
            isFirst: index == 0,
            isLast:
                index == recipeEditController.recipe.instructions.length - 1));

    return GetBuilder<RecipeEditController>(
      builder: (_) {
        return Column(
          children: (recipeEditController.recipe.instructions.isEmpty)
              ? []
              : [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Instructions',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 25, color: Get.theme.primaryColor),
                    ),
                  ),
                  if (recipeEditController.recipe.instructions.isNotEmpty)
                    ReorderableList(
                      onReorder: recipeEditController.reorderCallback,
                      child: ListView(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: children),
                    ),
                ],
        );
      },
    );
  }

  Future validate() async {
    for (var key in instructionListKeys) {
      if (key.currentState == null) {
        recipeEditController.validation = false;
      } else {
        await key.currentState!.validate();
      }
    }
  }
}
