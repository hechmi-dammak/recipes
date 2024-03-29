import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/views/recipe/models/step_pm_recipe.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/selected_border.dart';

class StepCard extends StatelessWidget {
  const StepCard({Key? key, required this.step}) : super(key: key);
  final StepPMRecipe step;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.selectionIsActive) {
              controller.selectItem(step);
              return;
            }
            controller.useItem(step);
          },
          onLongPress: () => controller.selectItem(step),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
              color: Get.theme.colorScheme.primaryContainer,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(step.order.toString(),
                                  textAlign: TextAlign.start,
                                  style: Get.textTheme.titleLarge?.copyWith(
                                    color: Get
                                        .theme.colorScheme.onSecondaryContainer,
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                step.instruction,
                                textAlign: TextAlign.start,
                                style: Get.textTheme.bodyLarge?.copyWith(
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConditionalWidget(
                          condition: step.image != null,
                          child: (context) => AspectRatio(
                            aspectRatio: 2,
                            child: Image(
                              image: step.image!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ConditionalWidget(
                      condition: step.used,
                      child: (context) => Container(
                        decoration: BoxDecoration(
                          color:
                              Get.theme.colorScheme.tertiary.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(Constants.cardBorderRadius),
                          border: Border.all(
                            width: Constants.selectionBorderWidth,
                            color: Get.theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                    SelectedBorder(
                      height: null,
                      width: null,
                      selected: step.selected,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
