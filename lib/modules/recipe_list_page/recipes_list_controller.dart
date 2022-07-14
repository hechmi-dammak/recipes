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
  final Rx<List<Recipe>> _recipes = Rx<List<Recipe>>([]);
  final RxBool _selectionIsActive = false.obs;
  final RxBool _allItemsSelected = false.obs;
  final RxBool _loading = false.obs;
  final RxString _searchValue = ''.obs;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  List<Recipe> get recipes => _recipes.value;

  bool get selectionIsActive => _selectionIsActive.value;

  set selectionIsActive(bool? value) =>
      _selectionIsActive(value ?? _selectionIsActiveFallBack());

  bool get allItemsSelected => _allItemsSelected.value;

  set allItemsSelected(bool? value) =>
      _allItemsSelected(value ?? _allItemsSelectedFallBack());

  bool get loading => _loading.value;

  set loading(value) => _loading(value);

  String get searchValue => _searchValue.value;

  set searchValue(value) => _searchValue(value);

  final recipesScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    debounce(_searchValue, (_) => updateSearch(),
        time: const Duration(milliseconds: 200));
  }

//-----------init  Data---------------
  Future<void> loadRecipes() async {
    loading = true;
    _recipes(await RecipeRepository.find.readAll());
    selectionIsActive = null;
    allItemsSelected = null;
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

      await saveRecipesFromFile(content);
    } catch (e) {
      CustomSnackBar.error('Failed to open to file $e');
    }
  }

//-----------Selection---------------
  void setRecipeSelected(Recipe recipe) {
    recipe.selected = !recipe.selected;
    selectionIsActive = null;
    allItemsSelected = null;
    update();
  }

  bool _selectionIsActiveFallBack() {
    for (var recipe in recipes) {
      if (recipe.selected) {
        return true;
      }
    }
    return false;
  }

  bool _allItemsSelectedFallBack() {
    for (var recipe in recipes) {
      if (!(recipe.selected)) {
        return false;
      }
    }
    return true;
  }

  void setSelectAllValue([bool value = false]) {
    for (var recipe in recipes) {
      recipe.selected = value;
    }
    allItemsSelected = value;
    selectionIsActive = value;
    update();
  }

//-----------get /delete /import /export  Data---------------
  List<Map<String, dynamic>> getSelectedRecipes() {
    final List<Map<String, dynamic>> result = [];
    for (Recipe recipe in recipes) {
      if (recipe.selected) {
        result.add(recipe.toJson(true));
      }
    }
    return result;
  }

  void deleteSelectedRecipes() async {
    loading = true;
    final List<Recipe> recipesCopy = recipes.toList();
    for (Recipe recipe in recipes) {
      if ((recipe.selected) && (recipe.id != null)) {
        RecipeRepository.find.delete(recipe.id!);
        recipesCopy.remove(recipe);
      }
      _recipes(recipesCopy);
    }
    selectionIsActive = null;
    loading = false;
    update();
    CustomSnackBar.success('Selected Recipe were deleted.');
  }

  final _fileNameController = TextEditingController();

  Future<void> exportToFile() async {
    InputDialog(
        title: 'Pick a name for the file',
        label: 'File name',
        controller: _fileNameController,
        confirm: () async {
          try {
            if (_fileNameController.text == '') {
              CustomSnackBar.warning("File name shouldn't be empty.");
              return;
            }
            await requestStoragePermissions();
            final String? fileDirectory = await FilePicker.platform
                .getDirectoryPath(dialogTitle: 'Select where to save to file');
            if (fileDirectory == null) {
              CustomSnackBar.warning('You must choose a directory');
              return;
            }
            final fileLocation =
                '$fileDirectory/${_fileNameController.text}.recipe';
            final recipes = getSelectedRecipes();
            File file = File(fileLocation);
            file = await file.writeAsString(json.encode(recipes), flush: true);
            Get.back();
            CustomSnackBar.success(
                'Recipes are exported to file ${_fileNameController.text}.');
            _fileNameController.clear();
          } catch (e) {
            CustomSnackBar.error('Failed to  export to file $e');
          }
        }).show();
  }

  Future<void> shareAsFile() async {
    InputDialog(
        title: 'Pick a name for the file',
        label: 'File name',
        controller: _fileNameController,
        confirm: () async {
          try {
            if (_fileNameController.text == '') {
              CustomSnackBar.warning("File name shouldn't be empty.");
              return;
            }
            await requestStoragePermissions();
            final tempDir = await getTemporaryDirectory();
            final fileLocation =
                '${tempDir.path}/${_fileNameController.text}.recipe';
            final file = File(fileLocation);
            final recipes = getSelectedRecipes();
            await file.writeAsString(json.encode(recipes), flush: true);
            Get.back();
            await Share.shareFiles([fileLocation],
                subject: 'Share your Recipes');
            CustomSnackBar.success(
              'Recipes file ${_fileNameController.text} were shared.',
            );
            _fileNameController.clear();
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
      final response = await File(result.files.single.path!).readAsString();
      final data = await json.decode(response);
      final List<Recipe> recipes = [];
      data.forEach((item) {
        recipes.add(Recipe.fromJson(item));
      });

      await RecipeRepository.find.createAll(recipes);
      await loadRecipes();
      CustomSnackBar.success('Recipes are imported.');
    } catch (e) {
      CustomSnackBar.error('Failed to  import from file$e');
    }
    loading = false;
    update();
  }

  Future<void> saveRecipesFromFile(String content) async {
    try {
      loading = true;

      final data = await json.decode(content);
      final List<Recipe> recipes = [];
      data.forEach((item) {
        recipes.add(Recipe.fromJson(item));
      });

      await RecipeRepository.find.createAll(recipes);
      await loadRecipes();
      CustomSnackBar.success('Recipes are imported.');
    } catch (e) {
      CustomSnackBar.error('Failed to  import from file$e');
    }
    loading = false;
    update();
  }

  Future<void> importFromLibrary() async {
    try {
      loading = true;

      final String response =
          await rootBundle.loadString('assets/recipes.json');
      final data = await json.decode(response);
      final List<Recipe> recipes = [];
      data.forEach((item) {
        recipes.add(Recipe.fromJson(item));
      });

      await RecipeRepository.find.createAll(recipes);
      await loadRecipes();
      CustomSnackBar.success('Recipes are imported.');
    } catch (e) {
      CustomSnackBar.error('Failed to  import from file$e');
    }
    loading = false;
    update();
  }

//--------------SEARCH---------------------

  void updateSearch() {
    final List<Recipe> recipesCopy = recipes.toList();
    for (Recipe recipe in recipesCopy) {
      if (!recipe.name
          .toLowerCase()
          .trim()
          .startsWith(searchValue.toLowerCase().trim())) {
        recipes.remove(recipe);
      }
    }
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
