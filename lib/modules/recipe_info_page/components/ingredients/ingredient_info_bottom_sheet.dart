import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_bottom_sheet.dart';
import 'package:recipes/decorations/modal_paint.dart';
import 'package:recipes/models/ingredient.dart';

class IngredientInfoBottomSheet extends CustomBottomSheet {
  final Ingredient ingredient;
  final int servings;
  final int? recipeServings;

  const IngredientInfoBottomSheet(
      {required this.ingredient,
      required this.servings,
      this.recipeServings,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ingredient.selected
              ? Get.theme.colorScheme.secondary
              : Get.theme.primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: CustomPaint(
        painter: ModalPainter(
          ingredient.selected
              ? Get.theme.colorScheme.secondary
              : Get.theme.primaryColor,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListTile(
                leading: Text(
                  'Name:',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ingredient.selected
                        ? Get.theme.buttonTheme.colorScheme!.onSecondary
                        : Get.theme.buttonTheme.colorScheme!.onPrimary,
                  ),
                ),
                title: Text(
                  ingredient.name.capitalize!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ingredient.selected
                          ? Get.theme.buttonTheme.colorScheme!.onSecondary
                          : Get.theme.buttonTheme.colorScheme!.onPrimary),
                ),
              ),
            ),
            if (ingredient.category != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Text(
                    'Category:',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                  title: Text(
                    ingredient.category!.capitalize!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                ),
              ),
            if (ingredient.getQuantity(servings, recipeServings) != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Text(
                    'Quantity:',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                  title: Text(
                    ingredient
                        .getQuantity(servings, recipeServings)!
                        .capitalize!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                ),
              ),
            if (ingredient.method != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Text(
                    'Method:',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                  title: Text(
                    ingredient.method!.capitalize!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: ingredient.selected
                            ? Get.theme.buttonTheme.colorScheme!.onSecondary
                            : Get.theme.buttonTheme.colorScheme!.onPrimary),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
