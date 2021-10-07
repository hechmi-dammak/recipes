import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decorations/input_decoration.dart';
import 'package:recipes/components/utils/show_snack_bar.dart';
import 'package:recipes/controller/recipes_controller.dart';
import 'package:recipes/routes/recipe_create_page.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeListFloatingButton extends StatefulWidget {
  const RecipeListFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  _RecipeListFloatingButtonState createState() =>
      _RecipeListFloatingButtonState();
}

class _RecipeListFloatingButtonState extends State<RecipeListFloatingButton> {
  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  final _fileNameController = TextEditingController();

  double iconSize = 30;
  var isDialOpen = ValueNotifier<bool>(false);
  RecipeOperations recipeOperations = RecipeOperations.instance;
  RecipesController recipesController = RecipesController.find;
  @override
  Widget build(BuildContext context) {
    return Obx(() => SpeedDial(
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
              onTap: () {
                Get.to(() => const RecipeCreatePage());
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.upload_file_rounded, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Import From File',
              onTap: () => recipesController.importFromFile(context),
            ),
            SpeedDialChild(
              child: ImageIcon(const AssetImage('assets/export_file.png'),
                  size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Export to File',
              visible: recipesController.selectionIsActive.value,
              onTap: () async => exportToFile(context),
            ),
            SpeedDialChild(
              child: Icon(Icons.check_circle_rounded, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Check all',
              onTap: () => recipesController.setSelectAllValue(true),
            ),
            SpeedDialChild(
              child: Icon(Icons.radio_button_unchecked_rounded, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              label: 'Uncheck all',
              visible: recipesController.selectionIsActive.value,
              onTap: () => recipesController.setSelectAllValue(false),
            ),
            SpeedDialChild(
              child: Icon(Icons.delete_forever_rounded, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              label: 'Delete selected',
              visible: recipesController.selectionIsActive.value,
              onTap: () => recipesController.deleteSelectedRecipes(),
            ),
          ],
        ));
  }

  exportToFile(BuildContext context) async {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: const Text(
          'Pick a name for the file',
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Get.back();
                  _fileNameController.clear();
                },
              ),
              TextButton(
                child: const Text('confirm'),
                onPressed: () async {
                  if (_fileNameController.text == "") {
                    showInSnackBar("File name shouldn't be empty", context);
                    return;
                  }

                  String? result = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: "Select where to save to file");
                  if (result == null) {
                    showInSnackBar("You must choose a directory", context);
                    return;
                  }
                  String fileLocation =
                      result + "/" + _fileNameController.text + '.recipe';
                  recipesController.exportSelectedDataToFile(fileLocation);
                  Get.back();
                  _fileNameController.clear();
                },
              ),
            ],
          )
        ],
        content: TextField(
          controller: _fileNameController,
          decoration: getInputDecoration(context, 'File name'),
        ),
      ),
    ));
  }
}
