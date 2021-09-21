// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recipes/service/json_operations.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeListFloatingButton extends StatefulWidget {
  final bool deleteIsActive;
  final Function readFromFile;

  final Function deleteIsActiveFunction;
  final Function deleteSelected;

  final Function setSelectAllValue;
  const RecipeListFloatingButton(
      {Key? key,
      required this.deleteIsActive,
      required this.readFromFile,
      required this.deleteIsActiveFunction,
      required this.deleteSelected,
      required this.setSelectAllValue})
      : super(key: key);

  @override
  _RecipeListFloatingButtonState createState() =>
      _RecipeListFloatingButtonState();
}

class _RecipeListFloatingButtonState extends State<RecipeListFloatingButton> {
  double iconSize = 30;
  var isDialOpen = ValueNotifier<bool>(false);
  RecipeOperations recipeOperations = RecipeOperations.instance;
  JsonOperations jsonOperations = JsonOperations.instance;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: widget.deleteIsActive
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.primary,
      icon: widget.deleteIsActive ? Icons.delete : Icons.note_add,
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
          child: Icon(Icons.delete_forever, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          label: 'Delete selected',
          visible: widget.deleteIsActive,
          onTap: () => widget.deleteSelected(),
        ),
        SpeedDialChild(
          child: Icon(Icons.check_circle_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          label: 'Check all',
          visible: widget.deleteIsActive,
          onTap: () => widget.setSelectAllValue(true),
        ),
        SpeedDialChild(
          child: Icon(Icons.radio_button_unchecked_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Uncheck all',
          visible: widget.deleteIsActive,
          onTap: () => widget.setSelectAllValue(false),
        ),
        SpeedDialChild(
          child: Icon(Icons.note_add, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Add',
          visible: widget.deleteIsActive,
          onTap: () {
            widget.deleteIsActiveFunction(false);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.post_add_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Create new',
          visible: !widget.deleteIsActive,
          onTap: () {},
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Import From File',
          visible: !widget.deleteIsActive,
          onTap: () async => await widget.readFromFile(),
        ),
        SpeedDialChild(
          child: Icon(Icons.delete, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          label: 'Delete',
          visible: !widget.deleteIsActive,
          onTap: () {
            widget.deleteIsActiveFunction(true);
          },
        ),
      ],
    );
  }
}
