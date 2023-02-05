import 'package:get/get.dart';
import 'package:recipes/decorator/controller.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertRecipeController extends UpsertElementController {
  static UpsertRecipeController get find => Get.find<UpsertRecipeController>();

  final int? id;
  final int categoryId;

  UpsertRecipeController(
      {required this.categoryId,
      this.id,
      super.controller,
      super.child,
      required super.formFields});

  Recipe recipe = Recipe();

  factory UpsertRecipeController.create(
      {int? id, required int categoryId, Controller? controller}) {
    final recipesCategoriesController = UpsertRecipeController(
        controller: DataFetchingDecorator.create(
          controller: LoadingDecorator.create(),
        ),
        id: id,
        categoryId: categoryId,
        formFields: [
          TextUpsertFormField(
              name: 'name',
              label: 'Name :'.tr,
              validator: FormValidators.notEmptyOrNullValidator),
          TextUpsertFormField(
            name: 'description',
            label: 'Description :'.tr,
          ),
          PictureUpsertFormField(name: 'picture')
        ]);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    recipesCategoriesController.initState(null);
    return recipesCategoriesController;
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait([super.loadData(callChild: false), fetchRecipe()]);
  }

  Future<void> fetchRecipe() async {
    if (id != null) {
      recipe = await RecipeRepository.find.findById(id) ?? recipe;
      getTextFormFieldByName('name')?.controller.text = recipe.name;
      getTextFormFieldByName('description')?.controller.text =
          recipe.description ?? '';
      getPictureFormFieldByName('picture')?.picture = recipe.picture.value;
      return;
    }
    recipe.category.value =
        await RecipeCategoryRepository.find.findById(categoryId);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description =
          getTextFormFieldByName('description')?.controller.text.trim() ?? '';
      recipe
        ..name = getTextFormFieldByName('name')?.controller.text.trim() ?? ''
        ..description = description.isEmpty ? null : description
        ..picture.value = getPictureFormFieldByName('picture')?.picture;
      await RecipeRepository.find.save(recipe);
      close(true, true);
    }
  }
}
