import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/models/recipe_category_page_model.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_controller.dart';
import 'package:recipes/views/recipe_categories/widgets/description_dialog.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';

class RecipeCategoryCard extends GetView<RecipeCategoriesController> {
  const RecipeCategoryCard({Key? key, required this.recipeCategory})
      : super(key: key);
  final RecipeCategoryPageModel recipeCategory;
  static const double borderWidth = 4;
  static const double borderRadius = 6.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.getSelectionIsActive()) {
          controller.selectCategory(recipeCategory);
          return;
        }
        controller.goToRecipes(recipeCategory);
      },
      onLongPress: () => controller.selectCategory(recipeCategory),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              ConditionalWidget(
                  condition: recipeCategory.picture.value != null,
                  child: (context) => Image.memory(
                        recipeCategory.picture.value!.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )),
              ConditionalWidget(
                  child: (context) => Positioned(
                        top: 0,
                        left: 0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            DescriptionDialog(
                                    title: recipeCategory.name,
                                    description: recipeCategory.description!)
                                .show();
                          },
                          child: SizedBox(
                            height: 34,
                            width: 32,
                            child: Align(
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Get.theme.colorScheme.primary),
                                child: SvgPicture.asset(
                                  'assets/icons/info_icon.svg',
                                  width: 2, height: 9, fit: BoxFit.scaleDown,
                                  // color: Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  condition: recipeCategory.description != null),
              LayoutBuilder(
                builder: (context, constrain) => Transform.translate(
                  offset: Offset(
                      constrain.maxWidth * 0.43, constrain.maxHeight * 0.16),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      width: constrain.maxWidth * 0.57,
                      decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      child: Text(recipeCategory.name,
                          style: Get.textTheme.headlineMedium?.copyWith(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              overflow: TextOverflow.ellipsis))),
                ),
              ),
              ConditionalWidget(
                  condition: recipeCategory.selected,
                  child: (context) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            width: borderWidth,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
