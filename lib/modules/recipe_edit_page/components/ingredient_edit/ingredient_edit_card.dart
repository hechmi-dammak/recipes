import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/selected_indicator.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_card_components.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

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
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5),
                  child: Ink(
                    decoration: GradientDecoration.secondary(
                        recipeEditController
                            .recipe.ingredients[widget.index].selected),
                    child: InkWell(
                      onTap: () {
                        if (recipeEditController.selectionIsActive) {
                          recipeEditController.setItemSelected(
                              recipeEditController
                                  .recipe.ingredients[widget.index]);
                        }
                      },
                      onLongPress: () {
                        recipeEditController.setItemSelected(
                            recipeEditController
                                .recipe.ingredients[widget.index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Get.theme.backgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 100),
                              margin: const EdgeInsets.only(
                                  top: 35, bottom: 15, left: 10, right: 10),
                              child: InsideIngredientCard(
                                  key: _ingredientCardKey,
                                  index: widget.index)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            EditButton(index: widget.index),
            if (recipeEditController.selectionIsActive)
              SelectIndicator(
                selected: recipeEditController
                    .recipe.ingredients[widget.index].selected,
              )
          ],
        ));
  }

  Future validate() async {
    if (_ingredientCardKey.currentState == null) {
      recipeEditController.validation = false;
    } else {
      await _ingredientCardKey.currentState!.validate();
    }
  }
}
