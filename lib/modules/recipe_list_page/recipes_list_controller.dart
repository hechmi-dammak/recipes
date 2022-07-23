import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:content_resolver/content_resolver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_page.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_page.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:share_plus/share_plus.dart';

class RecipesListController extends GetxController {
  static RecipesListController get find => Get.find<RecipesListController>();
  List<Recipe> _initialRecipes = [];
  List<Recipe> _recipes = [];
  bool _selectionIsActive = false;
  bool _allItemsSelected = false;
  bool _loading = false;
  final RxString _searchValue = ''.obs;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  List<Recipe> get recipes => _recipes;

  bool get selectionIsActive => _selectionIsActive;

  void updateSelectionIsActive() {
    _selectionIsActive = _initialRecipes.any((recipe) => recipe.selected);
    update();
  }

  void updateAllItemsSelected() {
    _allItemsSelected = !_recipes.any((recipe) => !recipe.selected);
    update();
  }

  bool get allItemsSelected => _allItemsSelected;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    update();
  }

  String get searchValue => _searchValue.value;

  set searchValue(value) {
    _searchValue(value);
    update();
  }

  final recipesScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    debounce(_searchValue, (_) => updateSearch(),
        time: const Duration(milliseconds: 200));
    initDeepLinks();
    loadRecipes();
  }

//-----------init  Data---------------
  Future<void> loadRecipes() async {
    loading = true;
    _initialRecipes = await RecipeRepository.find.readAll();
    _recipes = _initialRecipes.toList();
    updateSelectionIsActive();
    updateAllItemsSelected();
    loading = false;
    update();
  }

  void initDeepLinks() async {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      _openAppLink(uri);
    });

    final appLink = await appLinks.getInitialAppLink();
    if (appLink != null && appLink.hasFragment && appLink.fragment != '/') {
      _openAppLink(appLink);
    }
  }

  void _openAppLink(Uri uri) async {
    try {
      final uriStr = uri.toString().replaceFirst(
          'content://com.slack.fileprovider/',
          'content://com.Slack.fileprovider/');
      var content = '';
      try {
        final contentEncoded = await ContentResolver.resolveContent(uriStr);
        content = String.fromCharCodes(contentEncoded);
      } catch (e) {
        try {
          content = await File(uri.path).readAsString();
        } catch (e) {
          content = await File(uri.path.split('external').last).readAsString();
        }
      }

      await _saveRecipesFromFile(content);
    } catch (e) {
      CustomSnackBar.error('Failed to open to file $e');
    }
  }

//-----------Selection---------------
  void setRecipeSelected(Recipe recipe) {
    recipe.selected = !recipe.selected;
    updateSelectionIsActive();
    updateAllItemsSelected();
  }

  void setSelectAllValue([bool value = false]) {
    _recipes.forEach((recipe) {
      recipe.selected = value;
    });
    updateAllItemsSelected();
    updateSelectionIsActive();
  }

//-----------get /delete /import /export  Data---------------
  List<Map<String, dynamic>> get selectedRecipes {
    return _initialRecipes
        .where((recipe) => recipe.selected)
        .map((recipe) => recipe.toJson())
        .toList();
  }

  void deleteSelectedRecipes() async {
    loading = true;
    _initialRecipes
      ..where((recipe) => (recipe.selected) && (recipe.id != null))
          .forEach((recipe) {
        RecipeRepository.find.delete(recipe.id!);
        _recipes.remove(recipe);
      })
      ..removeWhere((recipe) => (recipe.selected) && (recipe.id != null));
    updateSelectionIsActive();
    loading = false;
    CustomSnackBar.success('Selected Recipe were deleted.');
  }

  void exportToFile() {
    InputDialog(
        title: 'Pick a name for the file',
        label: 'File name',
        validate: (value) {
          if (value?.isEmpty ?? true) {
            return "File name shouldn't be empty.";
          }
          return null;
        },
        confirm: (formKey, controller) async {
          try {
            if (!(formKey.currentState?.validate() ?? false)) return;
            await requestStoragePermissions();
            final String? fileDirectory = await FilePicker.platform
                .getDirectoryPath(dialogTitle: 'Select where to save to file');
            if (fileDirectory == null) {
              CustomSnackBar.warning('You must choose a directory');
              return;
            }
            await File('$fileDirectory/${controller.text}.recipe')
                .writeAsString(json.encode(selectedRecipes), flush: true);
            Get.back();
            CustomSnackBar.success(
                'Recipes are exported to file ${controller.text}.');
          } catch (e) {
            CustomSnackBar.error('Failed to  export to file $e');
          }
        }).show();
  }

  void shareAsFile() {
    InputDialog(
        title: 'Pick a name for the file',
        label: 'File name',
        validate: (value) {
          if (value?.isEmpty ?? true) {
            return "File name shouldn't be empty.";
          }
          return null;
        },
        confirm: (formKey, controller) async {
          try {
            if (!(formKey.currentState?.validate() ?? false)) return;
            await requestStoragePermissions();
            final tempDir = await getTemporaryDirectory();
            final fileLocation = '${tempDir.path}/${controller.text}.recipe';
            await File(fileLocation)
                .writeAsString(json.encode(selectedRecipes), flush: true);
            Get.back();
            await Share.shareFiles([fileLocation],
                subject: 'Share your Recipes');
            CustomSnackBar.success(
              'Recipes file ${controller.text} were shared.',
            );
          } catch (e) {
            CustomSnackBar.error('Failed to share file$e');
          }
        }).show();
  }

  Future<void> importFromFile() async {
    try {
      loading = true;
      await requestStoragePermissions();
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null || result.count == 0) {
        loading = false;
        CustomSnackBar.error(
            'You must pick a file that has the extension recipe.');
        return;
      }
      await _saveRecipesFromFile(
          await File(result.files.single.path!).readAsString());
    } catch (e) {
      CustomSnackBar.error('Failed to import from file $e');
    }
    loading = false;
  }

  Future<void> importFromLibrary() async {
    try {
      _saveRecipesFromFile(await rootBundle.loadString('assets/recipes.json'));
    } catch (e) {
      CustomSnackBar.error('Failed to import from library $e');
    }
    loading = false;
  }

  Future<void> _saveRecipesFromFile(String content) async {
    try {
      loading = true;
      await RecipeRepository.find.createAll((await json.decode(content) as List)
          .map((map) => Recipe.fromJson(map))
          .toList());
      await loadRecipes();
      CustomSnackBar.success('Recipes are imported.');
    } catch (e) {
      CustomSnackBar.error('Failed to import from file $e');
    }
    loading = false;
  }

//--------------SEARCH---------------------

  void updateSearch() {
    _recipes = _initialRecipes.toList();
    _recipes.removeWhere((recipe) => !recipe.name
        .toLowerCase()
        .trim()
        .startsWith(searchValue.toLowerCase().trim()));
    update();
  }

  void selectedItemMenu(item) {
    switch (item) {
      case 0:
        importFromFile();
        break;
      case 1:
        importFromLibrary();
        break;
    }
  }

  Future<void> requestStoragePermissions() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void onRecipeTap(Recipe recipe) {
    if (selectionIsActive) {
      setRecipeSelected(recipe);
    } else {
      Get.toNamed(RecipeInfoPage.routeName, arguments: recipe.id);
    }
  }

  Future<void> addRecipe() async {
    final result = await Get.to(() => RecipeEditPage());
    if (result != null && result) {
      if (recipesScrollController.hasClients) {
        recipesScrollController.animateTo(
          recipesScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
        );
      }
    }
  }

  void clearSearch() {
    searchFocusNode.unfocus();
    searchController.clear();
    searchValue = '';
    updateSearch();
  }
}
