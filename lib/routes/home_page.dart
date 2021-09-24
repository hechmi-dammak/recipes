import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipes/components/floating_action_button.dart';
import 'package:recipes/components/recipe_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:recipes/service/json_operations.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

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
  JsonOperations jsonOperations = JsonOperations.instance;

  Future<void> initRecipes() async {
    _recipes = await recipeOperations.readAllForList();
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

  readFromFile() async {
    deinitRecipes();
    List<Recipe> recipes = await jsonOperations.readJson();
    await recipeOperations.createAll(recipes);
    initRecipes();
  }

  importFromFile() async {
    // deinitRecipes();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['recipe'],
    );

    // initRecipes();
  }

  exportToFile() async {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          // holding this dialog context
          return AlertDialog(
            title: const Text(
              'Pick a name for the file',
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('cancel'),
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .pop('dialog'),
                  ),
                  TextButton(
                    child: const Text('confirm'),
                    onPressed: () => {},
                  ),
                ],
              )
            ],
            content: const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'File name'),
            ),
          );
        });
    // deinitRecipes();
    // setState(() {
    //   loading = true;
    // });
    String? result = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "Select where to save to file");

    // print(result!);

    // initRecipes();
  }

  saveToFile() async {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.6,
            ],
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryVariant,
            ],
          ),
          centerTitle: true,
          title: const Text(
            'Recipes List',
          ),
        ),
        floatingActionButton: RecipeListFloatingButton(
            setSelectAllValue: setSelectAllValue,
            deleteSelected: deleteSelected,
            importFromFile: importFromFile,
            selectionIsActiveFunction: updateSelectionIsActive,
            selectionIsActive: selectionIsActive,
            exportToFile: exportToFile),
        body: RefreshIndicator(
          onRefresh: _reloadData,
          child: _recipes != null && !loading
              ? _recipes!.isNotEmpty
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
                  : ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 6,
                                  left: 10,
                                  right: 10),
                              child: const Center(
                                  child: Text(
                                "No recipes exists yet.\nPress import to load new recipes or you can  create your own.",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ],
                        )
                      ],
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
