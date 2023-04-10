import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/step_card.dart';
import 'package:recipes/widgets/project/add_element_card.dart';

class StepsTab extends StatelessWidget {
  const StepsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            ...controller.recipe!.stepList
                .map((step) => StepCard(
                      step: step,
                    ))
                .toList(),
            if (!controller.selectionIsActive)
              LayoutBuilder(builder: (context, _) {
                return AddElementCard(
                  onTap: controller.addStep,
                  semanticsLabel: 'Add Step'.tr,
                  height: Get.height * 0.2,
                );
              }),
          ],
        ),
      );
    });
  }
}
