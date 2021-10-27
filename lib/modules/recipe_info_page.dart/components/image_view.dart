import 'package:flutter/material.dart';
import 'package:recipes/modules/recipe_info_page.dart/controller/recipe_info_controller.dart';

class ImageView extends StatelessWidget {
  ImageView({
    Key? key,
  }) : super(key: key);

  final RecipeInfoController recipeInfoController = RecipeInfoController.find;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
        image: DecorationImage(
          image: MemoryImage(recipeInfoController.recipe.value.picture!.image!),
          fit: BoxFit.cover,
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
      width: double.infinity,
      height: (MediaQuery.of(context).size.width - 40) * 0.7,
    );
  }
}
