import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/expandable.dart';
import 'package:recipes/modules/recipe_info_page/components/instructions/instruction_card.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

class InstructionsList extends StatelessWidget {
  const InstructionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (recipeInfoController) {
        if (recipeInfoController.recipe.instructions.isEmpty) {
          return Container();
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ExpandablePanel(
            initialExpanded: true,
            theme: ExpandableThemeData(
                tapBodyToExpand: false,
                tapHeaderToExpand: true,
                iconPadding:
                    const EdgeInsets.only(right: 20, top: 8, bottom: 8),
                iconSize: 25,
                iconColor: Get.theme.primaryColor,
                collapseIcon: Icons.remove_circle_outline_rounded,
                expandIcon: Icons.add_circle_outline_rounded),
            header: SizedBox(
              height: 40,
              child: Text(
                'Instructions',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Get.theme.primaryColor),
              ),
            ),
            collapsed: Divider(
              thickness: 2,
              color: Get.theme.colorScheme.primary,
              indent: 5,
              endIndent: 5,
            ),
            expanded: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                return InstructionCard(
                  index: index,
                  instruction: recipeInfoController.recipe.instructions[index],
                );
              },
              itemCount: recipeInfoController.recipe.instructions.length,
            ),
          ),
        );
      },
    );
  }
}
