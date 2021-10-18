import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/Page/recipe_edit_page.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/components/dialog_input.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class RecipeListFloatingButton extends StatefulWidget {
  const RecipeListFloatingButton({Key? key}) : super(key: key);
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
  RecipesController recipesController = RecipesController.find;
  @override
  Widget build(BuildContext context) {
    return Obx(() => SpeedDial(
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icons.insert_drive_file_rounded,
          renderOverlay: false,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: recipesController.isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          buttonSize: 60,
          iconTheme: IconThemeData(
            size: iconSize + 5,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          childrenButtonSize: 65,
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
                recipesController.setDialOpen(false);

                Get.to(() => const RecipeEditPage());
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
              child: ImageIcon(
                  const AssetImage('assets/images/export_file.png'),
                  size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Export to File',
              visible: recipesController.selectionIsActive.value,
              onTap: () async => showDialogInput(
                  title: 'Pick a name for the file',
                  label: 'File name',
                  controller: _fileNameController,
                  confirm: () async {
                    try {
                      if (_fileNameController.text == "") {
                        showInSnackBar("File name shouldn't be empty.");
                        return;
                      }
                      String? fileDirectory = await FilePicker.platform
                          .getDirectoryPath(
                              dialogTitle: "Select where to save to file");
                      if (fileDirectory == null) {
                        showInSnackBar("You must choose a directory");
                        return;
                      }
                      var fileLocation =
                          "$fileDirectory/${_fileNameController.text}.recipe";
                      var recipes = recipesController.getSelectedRecipes();
                      File file = File(fileLocation);
                      await file.writeAsString(json.encode(recipes));
                      Get.back();
                      showInSnackBar(
                          "Recipes are exported to file ${_fileNameController.text}.",
                          status: true);
                      _fileNameController.clear();
                    } catch (e) {
                      showInSnackBar(
                          "Failed to  export to file" + e.toString());
                    }
                  }),
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
              child: Icon(Icons.check, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Select',
              visible: !recipesController.selectionIsActive.value,
              onTap: () => recipesController.updateSelectionIsActive(true),
            ),
            SpeedDialChild(
              child: Icon(Icons.download, size: iconSize),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              label: 'Import from library',
              visible: recipesController.recipes.isEmpty,
              onTap: () => recipesController.importFromLibrary(),
            )
          ],
        ));
  }
}
