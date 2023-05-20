import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/services/asset_service.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/info_button.dart';

class RecipeIngredientCard extends GetView<RecipeController> {
  const RecipeIngredientCard({Key? key, required this.ingredient})
      : super(key: key);

  final RecipeIngredientPMRecipe ingredient;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (controller.selectionIsActive) {
            controller.selectItem(ingredient);
            return;
          }
          controller.useIngredient(ingredient);
        },
        onLongPress: () => controller.selectItem(ingredient),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          child: Stack(
            children: [
              Opacity(
                opacity: ingredient.used ? 0.3 : 1,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Constants.cardBorderRadius),
                        color: Get.theme.colorScheme.primaryContainer,
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Constants.cardBorderRadius),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.tertiary),
                                  ),
                                  ConditionalWidget(
                                    condition: ingredient.image != null,
                                    child: (context) => Image(
                                      image: ingredient.image!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ConditionalWidget(
                                    condition: ingredient
                                            .getAmount(controller.servings) !=
                                        null,
                                    child: (context) => Positioned(
                                      left: 0,
                                      top: 14,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Get.theme.colorScheme.primary,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        child: Text(
                                          ingredient
                                              .getAmount(controller.servings)!,
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InfoButton(
                                      name: ingredient.ingredient.value?.name ??
                                          '',
                                      description: ingredient.description,
                                      isRight: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 8, left: 10, right: 10),
                          child: Text(
                            ingredient.ingredient.value?.name ?? '',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headlineMedium?.copyWith(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                    ConditionalWidget(
                      condition: ingredient.selected,
                      child: (context) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Constants.cardBorderRadius),
                          border: Border.all(
                            width: Constants.selectionBorderWidth,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConditionalWidget(
                condition: ingredient.used,
                child: (context) => Column(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Image(
                            image: AssetService.assets['used_icon']!,
                            height: 70,
                            width: 70,
                            color: Get.theme.colorScheme.tertiary,
                          )),
                    ),
                    Container(
                      height: Get.textTheme.headlineMedium!.height! +
                          8 +
                          Get.textTheme.headlineMedium!.fontSize!,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
