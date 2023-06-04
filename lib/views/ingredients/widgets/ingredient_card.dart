import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/views/ingredients/ingredients_controller.dart';
import 'package:mekla/views/ingredients/models/ingredient_pm_ingredients.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/conditional_image.dart';
import 'package:mekla/widgets/project/selected_border.dart';

class IngredientCard extends StatelessWidget
    with GetBuilderView<IngredientsController> {
  const IngredientCard({Key? key, required this.ingredient}) : super(key: key);

  final IngredientPMIngredients ingredient;

  @override
  Widget getBuilder(BuildContext context, controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.selectItem(ingredient),
      onLongPress: () => controller.selectItem(ingredient),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        child: Stack(
          children: [
            Stack(
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
                          borderRadius:
                              BorderRadius.circular(Constants.cardBorderRadius),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.tertiary),
                              ),
                              ConditionalImage(image: ingredient.image),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                      child: Text(
                        ingredient.name,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineMedium?.copyWith(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
                SelectedBorder(
                  selected: ingredient.selected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
