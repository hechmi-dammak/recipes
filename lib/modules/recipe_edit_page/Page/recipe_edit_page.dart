import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/StepEdit/step_create_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/floating_action_button.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_create_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/recipe_category_drop_down.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/components/serving_spin_box.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

class RecipeEditPage extends StatefulWidget {
  final int? recipeId;
  const RecipeEditPage({Key? key, this.recipeId}) : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final RecipeEditController recipeEditController = RecipeEditController.find;
  final _nameNode = FocusNode();
  final ingredientsListKey = GlobalKey<IngredientCreateListState>();
  final stepsListKey = GlobalKey<StepCreateListState>();
  final _recipeFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    recipeEditController.initRecipe(widget.recipeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (recipeEditController.isDialOpen.value) {
          setState(() {
            recipeEditController.setDialOpen(false);
          });
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: GetBuilder<RecipeEditController>(
          builder: (_) {
            return Scaffold(
              floatingActionButton: const RecipeCreateFloatingButton(),
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: customAppBar(context,
                  title: widget.recipeId != null
                      ? "Edit ${recipeEditController.recipe.value.name.capitalize!}"
                      : "Create a new recipe",
                  leading: Navigator.of(context).canPop()
                      ? IconButton(
                          onPressed: () async {
                            if (recipeEditController.isDialOpen.value) {
                              recipeEditController.setDialOpen(false);
                            } else {
                              Get.back();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 25,
                          ))
                      : null,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          recipeEditController.setLoading(true);
                          if (await validateRecipe()) {
                            await recipeEditController.saveRecipe();
                            recipeEditController.setLoading(false);
                            recipeEditController.setDialOpen(false);
                            Get.back();
                          } else {
                            showInSnackBar("Failed to save recipe");
                          }
                          recipeEditController.setLoading(false);
                        },
                        icon: Icon(
                          Icons.save,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ))
                  ]),
              body: LoadingWidget(
                loading: recipeEditController.loading.value,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: ServingSpinBox(
                                changeServingFunction: (double value) {
                                  setState(() {
                                    recipeEditController
                                        .setServingValue(value.toInt());
                                  });
                                },
                                servings: recipeEditController.servings.value)),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Form(
                            key: _recipeFormKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: EnsureVisibleWhenFocused(
                                    focusNode: _nameNode,
                                    child: TextFormField(
                                      initialValue: recipeEditController
                                          .recipe.value.name,
                                      onChanged: (value) {
                                        setState(() {
                                          recipeEditController
                                              .recipe.value.name = value;
                                        });
                                      },
                                      decoration: getInputDecoration("Name"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify a name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: const RecipeCategoryDropDownInput(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IngredientCreateList(key: ingredientsListKey),
                        const SizedBox(
                          height: 15,
                        ),
                        StepCreateList(key: stepsListKey)
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> validateRecipe() async {
    var valid = true;
    if (_recipeFormKey.currentState == null ||
        !_recipeFormKey.currentState!.validate()) valid = false;

    if (ingredientsListKey.currentState == null ||
        !(await ingredientsListKey.currentState!.validate())) valid = false;

    if (stepsListKey.currentState == null ||
        !(await stepsListKey.currentState!.validate())) valid = false;

    return valid;
  }
}
