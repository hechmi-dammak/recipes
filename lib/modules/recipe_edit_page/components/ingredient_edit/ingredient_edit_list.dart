import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_card.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientEditList extends StatefulWidget {
  const IngredientEditList({Key? key}) : super(key: key);

  @override
  IngredientEditListState createState() => IngredientEditListState();
}

class IngredientEditListState extends State<IngredientEditList> {
  List<GlobalObjectKey<IngredientEditCardState>> ingredientListKeys = [];
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
    ingredientListKeys = List.generate(
        RecipeEditController.find.recipe.ingredients.length,
        (index) => GlobalObjectKey<IngredientEditCardState>(index));
    return GetBuilder<RecipeEditController>(builder: (recipeEditController) {
      return Column(
        children: [
          if (recipeEditController.recipe.ingredients.isNotEmpty)
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 25),
              child: Text(
                'Ingredients',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 25, color: Get.theme.primaryColor),
              ),
            ),
          ListView(
              key: recipeEditController.ingredientListKey,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                  recipeEditController.recipe.ingredients.length,
                  (index) => IngredientEditCard(
                      index: index, key: ingredientListKeys[index]))),
        ],
      );
    });
  }

  Future validate() async {
    for (var key in ingredientListKeys) {
      if (key.currentState == null) {
        RecipeEditController.find.validation = false;
      } else {
        await key.currentState!.validate();
      }
    }
  }
}
