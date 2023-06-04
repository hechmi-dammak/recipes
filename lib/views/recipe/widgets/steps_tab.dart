import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/step_card.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/add_element_card.dart';

class StepsTab extends StatelessWidget with GetBuilderView<RecipeController> {
  const StepsTab({Key? key}) : super(key: key);

  @override
  Widget getBuilder(BuildContext context, controller) {
    return RefreshIndicator(
      onRefresh: controller.fetchData,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            ...controller.stepList
                .map((step) => StepCard(
                      step: step,
                    ))
                .toList(),
            if (!controller.selectionIsActive)
              LayoutBuilder(builder: (context, _) {
                return AddElementCard(
                  onTap: controller.add,
                  height: Get.height * 0.2,
                );
              }),
          ],
        ),
      ),
    );
  }
}
