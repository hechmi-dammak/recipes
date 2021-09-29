import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipes/components/app_bar.dart';
import 'package:recipes/components/empty_recipe_list.dart';
import 'package:recipes/components/floating_action_button.dart';
import 'package:recipes/components/loading_widget.dart';
import 'package:recipes/components/recipe_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/show_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Directory? rootPath;
  List<Recipe>? _recipes;
  bool selectionIsActive = false;
  bool loading = true;
  RecipeOperations recipeOperations = RecipeOperations.instance;
  final _fileNameController = TextEditingController();
  Future<void> initRecipes() async {
    _recipes = await recipeOperations.readAll();
    updateSelectionIsActive();
    setState(() {
      loading = false;
    });
  }

  deinitRecipes() async {
    setState(() {
      loading = true;
      _recipes = null;
    });
  }

  Future<void> _reloadData() async {
    await initRecipes();
  }

  @override
  void initState() {
    loading = true;
    initRecipes();
    super.initState();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  bool _selectionIsActive() {
    if (_recipes == null) return false;
    for (var recipe in _recipes!) {
      if (recipe.selected ?? false) {
        return true;
      }
    }
    return false;
  }

  void updateSelectionIsActive([bool? selectionIsActive]) {
    setState(() {
      this.selectionIsActive = selectionIsActive ?? _selectionIsActive();
    });
  }

  void deleteSelected() async {
    if (_recipes == null) return;
    setState(() {
      loading = true;
    });
    var _copyRecipes = _recipes!.toList();
    for (Recipe recipe in _copyRecipes) {
      if ((recipe.selected ?? false) && (recipe.id != null)) {
        recipeOperations.delete(recipe.id!);
        _recipes!.remove(recipe);
      }
    }
    loading = false;
    updateSelectionIsActive();
    setState(() {});
  }

  void setSelectAllValue([bool value = false]) {
    if (_recipes == null) return;
    for (var recipe in _recipes!) {
      recipe.selected = value;
    }
    updateSelectionIsActive();
    setState(() {});
  }

  importFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['recipe'],
    );
    if (result == null || result.count == 0) {
      showInSnackBar(
          "you must pick a file that has the extension recipe", context);
      return;
    }
    setState(() {
      loading = true;
    });
    File file = File(result.files.single.path!);
    final response = await file.readAsString();
    final data = await json.decode(response);
    List<Recipe> recipes = [];
    data.forEach((item) {
      recipes.add(Recipe.fromJson(item));
    });

    await recipeOperations.createAll(recipes);

    initRecipes();
  }

  exportToFile() async {
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext dialogContext) {
          // holding this dialog context
          return Scaffold(
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
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        _fileNameController.clear();
                      },
                    ),
                    TextButton(
                      child: const Text('confirm'),
                      onPressed: () async {
                        if (_fileNameController.text == "") {
                          showInSnackBar(
                              "File name shouldn't be empty", dialogContext);
                          return;
                        }

                        String? result = await FilePicker.platform
                            .getDirectoryPath(
                                dialogTitle: "Select where to save to file");
                        if (result == null) {
                          showInSnackBar(
                              "You must choose a directory", dialogContext);
                          return;
                        }
                        String fileLocation =
                            result + "/" + _fileNameController.text + '.recipe';
                        exportSelectedDataToFile(fileLocation);

                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        _fileNameController.clear();
                      },
                    ),
                  ],
                )
              ],
              content: TextField(
                controller: _fileNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'File name'),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: customAppBar(context, title: 'Recipes List'),
        floatingActionButton: RecipeListFloatingButton(
            setSelectAllValue: setSelectAllValue,
            deleteSelected: deleteSelected,
            importFromFile: importFromFile,
            selectionIsActiveFunction: updateSelectionIsActive,
            selectionIsActive: selectionIsActive,
            exportToFile: exportToFile),
        body: RefreshIndicator(
          onRefresh: _reloadData,
          child: LoadingWidget(
              loading: loading,
              child: _recipes != null && _recipes!.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 3,
                        maxCrossAxisExtent: 500,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      shrinkWrap: true,
                      itemCount: _recipes!.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                            recipe: _recipes![index],
                            selectionIsActive: selectionIsActive,
                            selectionIsActiveFunction: updateSelectionIsActive);
                      },
                    )
                  : const EmptyRecipeList()),
        ),
      ),
    );
  }

  void exportSelectedDataToFile(String fileLocation) async {
    if (_recipes == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    List result = [];
    for (Recipe recipe in _recipes!) {
      if (recipe.selected ?? false) {
        result.add(recipe.toJson());
      }
    }

    File file = File(fileLocation);
    await file.writeAsString(json.encode(result));

    setState(() {
      loading = false;
    });
  }
}
