import 'package:flutter/material.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/routes/recipe_info_page.dart';
import 'package:recipes/utils/string_extenstions.dart';
import 'package:flutter/services.dart';

class RecipeCard extends StatefulWidget {
  final bool selectionIsActive;
  final Function selectionIsActiveFunction;
  final Recipe recipe;
  const RecipeCard(
      {Key? key,
      required this.recipe,
      required this.selectionIsActive,
      required this.selectionIsActiveFunction})
      : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.selectionIsActive) {
          setState(() {
            widget.recipe.selected = !(widget.recipe.selected ?? true);
            widget.selectionIsActiveFunction();
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecipeInfoPage(recipeId: widget.recipe.id)),
          );
        }
      },
      onLongPress: () {
        HapticFeedback.vibrate();
        setState(() {
          widget.recipe.selected = !(widget.recipe.selected ?? true);
          widget.selectionIsActiveFunction();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
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
            colors: (widget.recipe.selected ?? false)
                ? [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryVariant
                  ]
                : [
                    Theme.of(context).colorScheme.secondaryVariant,
                    Theme.of(context).colorScheme.secondary
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.recipe.name.capitalize(),
            style: TextStyle(

                // overflow: TextOverflow.ellipsis,
                fontSize: 18,
                color: Theme.of(context).buttonTheme.colorScheme!.onPrimary),
          ),
        ),
      ),
    );
  }
}
