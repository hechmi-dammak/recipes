import 'package:flutter/material.dart';
import 'package:recipes/controller/recipe_create_controller.dart';

class IngredientEditCard extends StatefulWidget {
  final int index;
  const IngredientEditCard({Key? key, required this.index}) : super(key: key);

  @override
  _IngredientEditCardState createState() => _IngredientEditCardState();
}

class _IngredientEditCardState extends State<IngredientEditCard> {
  RecipeCreateController recipeCreateController = RecipeCreateController.find;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          recipeCreateController
              .recipe.value.ingredients![widget.index].inEditing = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).buttonTheme.colorScheme!.primary,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.9,
            ],
            colors: [
              Theme.of(context).colorScheme.secondaryVariant,
              Theme.of(context).colorScheme.secondary
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  recipeCreateController
                      .recipe.value.ingredients![widget.index].name,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                ),
              ),
              if (recipeCreateController.recipe.value.ingredients![widget.index]
                      .getQuantity(1) !=
                  null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    recipeCreateController
                        .recipe.value.ingredients![widget.index]
                        .getQuantity(1)!,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                ),
              if (recipeCreateController
                      .recipe.value.ingredients![widget.index].method !=
                  null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    recipeCreateController
                        .recipe.value.ingredients![widget.index].method!,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
