import 'package:flutter/material.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/routes/recipe_info_page.dart';
import 'package:recipes/utils/string_extenstions.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          colors: [
            Theme.of(context).colorScheme.secondaryVariant,
            Theme.of(context).colorScheme.secondary,
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
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeInfoPage(recipe: recipe)),
          );
        },
        child: Center(
          child: Text(
            recipe.name.capitalize(),
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
