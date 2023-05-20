import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/step_card.dart';
import 'package:mekla/widgets/project/add_element_card.dart';

class StepsTab extends GetView<RecipeController> {
  const StepsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchData,
      child: GetBuilder<RecipeController>(builder: (controller) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
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
                    height: Get.height * 0.2,
                  );
                }),
            ],
          ),
        );
      }),
    );
  }
}
