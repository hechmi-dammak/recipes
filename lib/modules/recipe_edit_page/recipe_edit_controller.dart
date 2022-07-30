import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/instruction_edit/instruction_edit_list.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';
import 'package:recipes/modules/recipe_list_page/recipes_list_controller.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';

class RecipeEditController extends GetxController {
  static const int _defaultServingValue = 4;
  final int? recipeId;

  final ScrollController mainScrollController = ScrollController();
  final GlobalKey ingredientListKey = GlobalKey();

  List<String> _recipeCategories = [];
  List<String> _ingredientCategories = [];
  List<String> _ingredientMeasuring = [];
  List<String> _ingredientSizes = [];
  final ValueNotifier<bool> _isDialOpen = ValueNotifier<bool>(false);
  final bool _selectionIsActive = false;
  final bool _allItemsSelected = false;
  final RxBool _validation = true.obs;
  Recipe _recipe = Recipe();
  int _servings = _defaultServingValue;
  bool _loading = false;
  final ingredientsListKey = GlobalKey<IngredientEditListState>();
  final instructionsListKey = GlobalKey<InstructionEditListState>();
  final recipeFormKey = GlobalKey<FormState>();

  RecipeEditController({this.recipeId}) {
    _initRecipe();
  }

  List<String> get recipeCategories => _recipeCategories;

  List<String> get ingredientCategories => _ingredientCategories;

  List<String> get ingredientMeasuring => _ingredientMeasuring;

  List<String> get ingredientSizes => _ingredientSizes;

  bool get isDialOpen => _isDialOpen.value;

  ValueNotifier<bool> get isDialOpenNotifier => _isDialOpen;

  set isDialOpen(bool value) {
    _isDialOpen.value = value;
    update();
  }

  bool get selectionIsActive => _selectionIsActive;

  // set selectionIsActive(bool value) => _selectionIsActive(value);

  bool get allItemsSelected => _allItemsSelected;

  // set allItemsSelected(bool value) => _allItemsSelected(value);

  bool get validation => _validation.value;

  set validation(bool value) => _validation(value);

  Recipe get recipe => _recipe;

  set recipe(Recipe value) {
    _recipe = value;
    update();
  }

  int get servings => _servings;

  set servings(int? value) {
    _servings = (value) ?? _defaultServingValue;
  }

  bool get loading => _loading;

  set loading(value) {
    _loading = value;
    update();
  }

  static RecipeEditController get find => Get.find<RecipeEditController>();

//-----------init/save  Data---------------
  Future<void> _initRecipe() async {
    final recipeRepository = RecipeRepository.find;
    final ingredientRepository = IngredientRepository.find;
    loading = true;
    if (recipeId != null) {
      recipe = await recipeRepository.read(recipeId) ?? Recipe();
      servings = recipe.servings;
    }
    _recipeCategories = await recipeRepository.getAllCategories();
    _ingredientCategories = await ingredientRepository
        .getAllValuesOfAttribute(IngredientFields.category);
    _ingredientMeasuring = await ingredientRepository
        .getAllValuesOfAttribute(IngredientFields.measuring);
    _ingredientSizes = await ingredientRepository
        .getAllValuesOfAttribute(IngredientFields.size);
    loading = false;
  }

  Future<void> saveRecipe() async {
    final recipeRepository = RecipeRepository.find;

    recipe.instructions
        .asMap()
        .forEach((index, element) => {element.order = index});
    recipe.servings = servings;
    if (recipe.id == null) {
      await recipeRepository.create(recipe);
    } else {
      await recipeRepository.update(recipe);
    }
    await RecipesListController.find.loadRecipes();
    update();
  }

//-----------Selection---------------

  void setItemSelected(item) {
    item.selected = !(item.selected ?? false);

    updateSelectionIsActive();
    updateAllItemsSelected();
    update();
  }

  bool _selectionIsActiveFallBack() {
    for (var ingredient in recipe.ingredients) {
      if (ingredient.selected) {
        return true;
      }
    }
    for (var instruction in recipe.instructions) {
      if (instruction.selected) {
        return true;
      }
    }
    return false;
  }

  void updateSelectionIsActive([bool? selectionIsActive]) {
    final bool newValue = selectionIsActive ?? _selectionIsActiveFallBack();
    if (newValue != selectionIsActive) {
      double height = 0;
      final double oldHeight = mainScrollController.position.maxScrollExtent;
      double newHeight = mainScrollController.position.maxScrollExtent;

      height += recipe.ingredients.length * 25;

      height += recipe.instructions.length * 25;

      if (newValue) {
        newHeight += height;
      } else {
        newHeight -= height;
      }
      mainScrollController.jumpTo(
          (newHeight * mainScrollController.position.pixels) / oldHeight);
    }

    selectionIsActive = newValue;
    update();
  }

  bool _allItemsSelectedFallBack() {
    for (var ingredient in recipe.ingredients) {
      if (!(ingredient.selected)) {
        return false;
      }
    }

    for (var instruction in recipe.instructions) {
      if (!(instruction.selected)) {
        return false;
      }
    }

    return true;
  }

  void updateAllItemsSelected([bool? allItemsSelected]) {
    allItemsSelected = allItemsSelected ?? _allItemsSelectedFallBack();
    update();
  }

  void setSelectAllValue([bool value = false]) {
    for (var element in _recipe.instructions) {
      element.selected = value;
    }
    for (var element in _recipe.ingredients) {
      element.selected = value;
    }
    updateSelectionIsActive(value);
    updateAllItemsSelected(value);
    update();
  }

//-----------delete  Data---------------
  void deleteSelectedItems() async {
    loading = true;
    final instructionRepository = InstructionRepository.find;
    final ingredientRepository = IngredientRepository.find;
    //todo review deletion without copy
    final instructions = recipe.instructions.toList();
    instructions.removeWhere((instruction) {
      if (instruction.selected) {
        instructionRepository.delete(instruction.id);
      }
      return instruction.selected;
    });
    recipe.instructions = instructions;

    final ingredients = recipe.ingredients.toList();
    ingredients.removeWhere((ingredient) {
      if (ingredient.selected) {
        ingredientRepository.delete(ingredient.id);
      }
      return ingredient.selected;
    });
    recipe.ingredients = ingredients;
    updateSelectionIsActive();
    loading = false;
    CustomSnackBar.success('Selected items were deleted.');
  }

  void setInEditing(dynamic editable, {bool value = true}) {
    if (value == false) {
      editable.inEditing = false;
      return;
    }
    for (var ingredient in recipe.ingredients) {
      ingredient.inEditing = false;
    }
    for (var instruction in recipe.instructions) {
      instruction.inEditing = false;
    }
    editable.inEditing = true;
    update();
  }

  Future setInEditingWithNoPropagation(dynamic editable,
      {bool value = true}) async {
    editable.inEditing = value;
    update();
  }

//-----------new Elements---------------
  void addNewRecipeCategory(String category) {
    _recipeCategories.add(category);
    update();
  }

  void addNewIngredientCategory(String category) {
    _ingredientCategories.add(category);
    update();
  }

  void addNewIngredientMeasuring(String measuring) {
    _ingredientMeasuring.add(measuring);
    update();
  }

  void addNewIngredientSize(String size) {
    _ingredientSizes.add(size);
    update();
  }

  Future<void> addNewInstruction() async {
    final instructions = recipe.instructions.toList();
    instructions.add(Instruction(key: ValueKey(instructions.length)));
    recipe.instructions = instructions;
    setInEditing(recipe.instructions.last);
    update();
  }

  Future<void> addNewIngredient() async {
    recipe.ingredients.add(Ingredient());
    setInEditing(recipe.ingredients.last);
    update();
  }

//-----------order instructions---------------
  int _indexOfKey(Key key) {
    return (recipe.instructions)
        .indexWhere((Instruction instruction) => instruction.key == key);
  }

  bool reorderCallback(Key item, Key newPosition) {
    final instructions = recipe.instructions.toList();
    final int draggingIndex = _indexOfKey(item);
    final int newPositionIndex = _indexOfKey(newPosition);
    final draggedItem = instructions.removeAt(draggingIndex);
    instructions.insert(newPositionIndex, draggedItem);
    recipe.instructions = instructions;
    update();
    return true;
  }

//-----------image fetch--------------
  Future<void> getImage(ImageSource source) async {
    final Picture? picture = await ImageOperations.find.getImage(source);
    if (picture != null) {
      recipe.picture = picture;
    }
    update();
  }

  Future<void> submit() async {
    loading = true;

    await _validateRecipe();
    if (validation) {
      await saveRecipe();
      isDialOpen = false;

      if (Get.isSnackbarOpen) {
        Get.back();
      }
      if (recipe.id != null) {
        RecipeInfoController.find.initRecipe();
      }
      Get.back(result: true);
    } else {
      CustomSnackBar.error('Failed to save recipe');
      loading = false;
    }
  }

  Future<void> _validateRecipe() async {
    validation = true;
    if (recipeFormKey.currentState == null ||
        !recipeFormKey.currentState!.validate()) {
      validation = false;
      mainScrollController.animateTo(
        mainScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceInOut,
      );
    }

    if (ingredientsListKey.currentState == null) {
      validation = false;
    } else {
      await ingredientsListKey.currentState!.validate();
    }
    if (instructionsListKey.currentState == null) {
      validation = false;
    } else {
      await instructionsListKey.currentState!.validate();
    }
  }

  void setRecipeName(String value) {
    _recipe.name = value;
    update();
  }

  void changeIngredientCategory(int index, String? category) {
    recipe.ingredients[index].category = category;
    update();
  }

  void changeIngredientMeasuring(int index, String? measuring) {
    recipe.ingredients[index].measuring = measuring;
    update();
  }

  void changeIngredientSize(int index, String? size) {
    recipe.ingredients[index].size = size;
    update();
  }

  void clearRecipeImage() {
    recipe.picture = null;
    update();
  }

  void changeRecipeCategory(String? category) {
    recipe.category = category;
    update();
  }
}
