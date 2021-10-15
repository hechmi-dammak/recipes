import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_info_page.dart/components/steps/step_card.dart';
import 'package:recipes/modules/recipe_info_page.dart/controller/recipe_info_controller.dart';

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

        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Steps",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
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
            )
          ],
        );
      },
    );
  }
}
