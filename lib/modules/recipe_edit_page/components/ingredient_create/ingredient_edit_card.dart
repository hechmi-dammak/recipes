import 'package:flutter/material.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_create/ingredient_edit_card_components.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

class IngredientEditCard extends StatefulWidget {
  final int index;
  const IngredientEditCard({Key? key, required this.index}) : super(key: key);

  @override
  IngredientEditCardState createState() => IngredientEditCardState();
}

class IngredientEditCardState extends State<IngredientEditCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;
  final GlobalKey<InsideIngredientCardState> _ingredientCardKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: gradientDecoationSecondery(context,
                      selected: recipeEditController
                          .recipe.value.ingredients![widget.index].selected),
                  child: InkWell(
                    onTap: () {
                      if (recipeEditController.selectionIsActive.value) {
                        recipeEditController.setItemSelected(
                            recipeEditController
                                .recipe.value.ingredients![widget.index]);
                      }
                    },
                    onLongPress: () {
                      recipeEditController.setItemSelected(recipeEditController
                          .recipe.value.ingredients![widget.index]);
                    },
                    child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 100),
                        margin: const EdgeInsets.only(
                            top: 35, bottom: 15, left: 10, right: 10),
                        child: InsideIngredientCard(
                            key: _ingredientCardKey, index: widget.index)),
                  ),
                ),
              ),
            ),
            EditButton(index: widget.index),
          ],
        ));
  }

  Future<bool> validate() async {
    return (_ingredientCardKey.currentState != null &&
        await _ingredientCardKey.currentState!.validate());
  }
}
