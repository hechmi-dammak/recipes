// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recipes/service/json_operations.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeListFloatingButton extends StatefulWidget {
  final bool selectionIsActive;
  final Function exportToFile;
  final Function importFromFile;
  final Function selectionIsActiveFunction;
  final Function deleteSelected;

  final Function setSelectAllValue;
  const RecipeListFloatingButton(
      {Key? key,
      required this.selectionIsActive,
      required this.exportToFile,
      required this.importFromFile,
      required this.selectionIsActiveFunction,
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icons.insert_drive_file_rounded,
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
          label: 'Create new',
          onTap: () {},
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Import From File',
          onTap: () async => await widget.importFromFile(),
        ),
        SpeedDialChild(
          child: ImageIcon(const AssetImage('assets/export_file.png'),
              size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Export to File',
          visible: widget.selectionIsActive,
          onTap: () async => await widget.exportToFile(),
        ),
        SpeedDialChild(
          child: Icon(Icons.check_circle_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: 'Check all',
          onTap: () => widget.setSelectAllValue(true),
        ),
        SpeedDialChild(
          child: Icon(Icons.radio_button_unchecked_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          label: 'Uncheck all',
          visible: widget.selectionIsActive,
          onTap: () => widget.setSelectAllValue(false),
        ),
        SpeedDialChild(
          child: Icon(Icons.delete_forever_rounded, size: iconSize),
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          label: 'Delete selected',
          visible: widget.selectionIsActive,
          onTap: () => widget.deleteSelected(),
        ),
      ],
    );
  }
}
