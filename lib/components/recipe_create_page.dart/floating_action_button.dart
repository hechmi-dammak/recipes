import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recipes/controller/recipe_create_controller.dart';

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
  var isDialOpen = ValueNotifier<bool>(false);
  RecipeCreateController recipeCreateController = RecipeCreateController.find;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icons.add_rounded,
      renderOverlay: false,
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: 60,
      iconTheme: IconThemeData(size: iconSize + 5),
      childrenButtonSize: 65,
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      isOpenOnStart: false,
      animationSpeed: 200,
      children: [
        SpeedDialChild(
          child: Icon(Icons.note_add_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Create new ingredient',
          onTap: () => recipeCreateController.addNewIngredient(),
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Create new step',
          onTap: () => recipeCreateController.addNewStep(),
        ),
      ],
    );
  }
}
