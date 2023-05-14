import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/models/step_pm_recipe.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';

class StepCard extends GetView<RecipeController> {
  const StepCard({Key? key, required this.step}) : super(key: key);
  final StepPMRecipe step;
  static const double borderWidth = 4;
  static const double borderRadius = 6.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (controller.selectionIsActive) {
            controller.selectStep(step);
            return;
          }
          controller.useStep(step);
        },
        onLongPress: () => controller.selectStep(step),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Get.theme.colorScheme.primaryContainer,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
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
                                color: Get.theme.colorScheme.onPrimaryContainer,
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
                        color: Get.theme.colorScheme.tertiary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          width: borderWidth,
                          color: Get.theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  ConditionalWidget(
                    condition: step.selected,
                    child: (context) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          width: borderWidth,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
