import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_card.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';

class IngredientCreateList extends StatefulWidget {
  const IngredientCreateList({Key? key}) : super(key: key);

  @override
  IngredientCreateListState createState() => IngredientCreateListState();
}

class IngredientCreateListState extends State<IngredientCreateList> {
  List<GlobalObjectKey<IngredientEditCardState>> ingredientListKeys = [];
  List<Widget> children = [];
  final RecipeEditController recipeEditController = RecipeEditController.find;
  @override
  Widget build(BuildContext context) {
    if (recipeEditController.recipe.value.ingredients != null) {
      ingredientListKeys = List.generate(
          recipeEditController.recipe.value.ingredients!.length,
          (index) => GlobalObjectKey<IngredientEditCardState>(index));
      children = List.generate(
          recipeEditController.recipe.value.ingredients!.length,
          (index) =>
              IngredientEditCard(index: index, key: ingredientListKeys[index]));
    }
    return GetBuilder<RecipeEditController>(builder: (_) {
      return Column(
        children: [
          if (recipeEditController.recipe.value.ingredients != null &&
              recipeEditController.recipe.value.ingredients!.isNotEmpty)
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Ingredients",
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            ),
          ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: children),
        ],
      );
    });
  }

  Future<bool> validate() async {
    var valid = true;
    for (var key in ingredientListKeys) {
      if (key.currentState == null || !(await key.currentState!.validate())) {
        valid = false;
      }
    }
    return valid;
  }
}
