import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';

import 'step_edit_card.dart';

class StepEditList extends StatefulWidget {
  const StepEditList({Key? key}) : super(key: key);

  @override
  StepEditListState createState() => StepEditListState();
}

class StepEditListState extends State<StepEditList> {
  final RecipeEditController recipeEditController = RecipeEditController.find;
  List<GlobalObjectKey<StepEditCardState>> stepListKeys = [];
  List<Widget> children = [];
  @override
  Widget build(BuildContext context) {
    if (recipeEditController.recipe.value.steps != null) {
      stepListKeys = List.generate(
          recipeEditController.recipe.value.steps!.length,
          (index) => GlobalObjectKey<StepEditCardState>(index));
      children = List.generate(
          recipeEditController.recipe.value.steps!.length,
          (index) => StepEditCard(
              key: stepListKeys[index],
              index: index,
              isFirst: index == 0,
              isLast: index ==
                  recipeEditController.recipe.value.steps!.length - 1));
    }

    return GetBuilder<RecipeEditController>(
      builder: (_) {
        return Column(
          children: !(recipeEditController.recipe.value.steps != null &&
                  recipeEditController.recipe.value.steps!.isNotEmpty)
              ? []
              : [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Steps",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 25, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  if (recipeEditController.recipe.value.steps != null &&
                      recipeEditController.recipe.value.steps!.isNotEmpty)
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

  Future<bool> validate() async {
    var valid = true;
    for (var key in stepListKeys) {
      if (key.currentState == null || !(await key.currentState!.validate())) {
        valid = false;
      }
    }
    return valid;
  }
}
