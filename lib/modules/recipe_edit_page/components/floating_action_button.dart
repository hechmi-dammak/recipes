import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';

class RecipeCreateFloatingButton extends StatefulWidget {
  const RecipeCreateFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  _RecipeCreateFloatingButtonState createState() =>
      _RecipeCreateFloatingButtonState();
}

class _RecipeCreateFloatingButtonState
    extends State<RecipeCreateFloatingButton> {
  double iconSize = 30;
  RecipeEditController recipeEditController = RecipeEditController.find;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icons.add_rounded,
      renderOverlay: false,
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: recipeEditController.isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: 60,
      iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary, size: iconSize + 5),
      childrenButtonSize: 65,
      elevation: 8.0,
      isOpenOnStart: false,
      animationSpeed: 200,
      children: [
        SpeedDialChild(
          child: Icon(Icons.fastfood_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Create new ingredient',
          onTap: () => recipeEditController.addNewIngredient(),
        ),
        SpeedDialChild(
          child: Icon(Icons.format_list_numbered, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Create new step',
          onTap: () => recipeEditController.addNewStep(),
        ),
      ],
    );
  }
}
