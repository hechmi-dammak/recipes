import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page/components/steps/step_card.dart';
import 'package:recipes/modules/recipe_info_page/controller/recipe_info_controller.dart';

class StepsList extends StatelessWidget {
  final RecipeInfoController recipeInfoController = RecipeInfoController.find;
  StepsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (_) {
        if (recipeInfoController.recipe.value.steps == null ||
            recipeInfoController.recipe.value.steps!.isEmpty) {
          return Container();
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
                tapBodyToExpand: false,
                tapHeaderToExpand: true,
                iconPadding: EdgeInsets.only(right: 20, top: 8, bottom: 8),
                iconSize: 25,
                iconColor: Theme.of(context).primaryColor,
                collapseIcon: Icons.remove_circle_outline_rounded,
                expandIcon: Icons.add_circle_outline_rounded),
            controller: ExpandableController(initialExpanded: true),
            header: Container(
              height: 40,
              child: Text(
                "Steps",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            ),
            collapsed: Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.primary,
              indent: 5,
              endIndent: 5,
            ),
            expanded: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                return StepCard(
                  index: index,
                );
              },
              itemCount: recipeInfoController.recipe.value.steps!.length,
            ),
          ),
        );
      },
    );
  }
}
