import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/floating_action_button.dart';
import 'package:recipes/modules/recipe_edit_page/components/image_edit.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/instruction_edit/instruction_edit_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/recipe_category_drop_down.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';
import 'package:recipes/utils/components/app_bar_bottom.dart';
import 'package:recipes/utils/components/custom_app_bar.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/components/serving_spin_box.dart';
import 'package:recipes/utils/components/show_dialog.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

class RecipeEditPage extends StatelessWidget {
  static const routeName = '/edit';

  RecipeEditPage({super.key});

  final _nameNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>( builder: (recipeEditController) {
      return WillPopScope(
        onWillPop: () async {
          if (recipeEditController.isDialOpen) {
            recipeEditController.isDialOpen = false;
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: BottomBar(),
            floatingActionButton: recipeEditController.selectionIsActive
                ? null
                : const RecipeCreateFloatingButton(),
            appBar: CustomAppBar(
                title: recipeEditController.recipeId != null
                    ? 'Edit ${recipeEditController.recipe.name.capitalize!}'
                    : 'Create a new recipe',
                leading: Navigator.of(context).canPop()
                    ? IconButton(
                        onPressed: () async {
                          if (recipeEditController.isDialOpen) {
                            recipeEditController.isDialOpen = (false);
                          } else {
                            Get.back();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Get.theme.colorScheme.onPrimary,
                          size: 25,
                        ))
                    : null,
                actions: [
                  if (recipeEditController.selectionIsActive) ...[
                    if (recipeEditController.allItemsSelected)
                      TextButton(
                          onPressed: recipeEditController.setSelectAllValue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline_outlined,
                                  size: 30,
                                  color: Get.theme.colorScheme.onPrimary),
                              Text(
                                'All',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.onPrimary),
                              )
                            ],
                          ))
                    else
                      TextButton(
                        onPressed: () =>
                            recipeEditController.setSelectAllValue(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.radio_button_unchecked_rounded,
                                size: 30,
                                color: Get.theme.colorScheme.onPrimary),
                            Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.onPrimary),
                            )
                          ],
                        ),
                      ),
                  ] else
                    TextButton(
                      onPressed: recipeEditController.submit,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save,
                              size: 30, color: Get.theme.colorScheme.onPrimary),
                          Text(
                            'Save',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.onPrimary),
                          )
                        ],
                      ),
                    )
                ]),
            body: AppBarBottom(
              child: LoadingWidget(
                loading: recipeEditController.loading,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: recipeEditController.mainScrollController,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: ServingSpinBox(
                                changeServingFunction: (value) {
                                  recipeEditController.servings = value;
                                },
                                servings: recipeEditController.servings)),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Form(
                            key: recipeEditController.recipeFormKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: EnsureVisibleWhenFocused(
                                    focusNode: _nameNode,
                                    child: TextFormField(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Get
                                              .theme.colorScheme.onSecondary),
                                      initialValue:
                                          recipeEditController.recipe.name,
                                      onChanged:
                                          recipeEditController.setRecipeName,
                                      decoration: getInputDecoration('Name',
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, top: 15, bottom: 15)),
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
                        const ImageEditField(),
                        IngredientEditList(
                            key: recipeEditController.ingredientsListKey),
                        const SizedBox(
                          height: 15,
                        ),
                        InstructionEditList(
                            key: recipeEditController.instructionsListKey)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class BottomBar extends StatelessWidget {
  BottomBar({
    Key? key,
  }) : super(key: key);
  final RecipeEditController recipeEditController = RecipeEditController.find;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: recipeEditController.selectionIsActive ? 75 : 0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: const [
            0.1,
            0.6,
          ],
          colors: [
            Get.theme.primaryColorDark,
            Get.theme.colorScheme.primary,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  ConfirmationDialog(
                          title: 'These items will be deleted.',
                          confirm: recipeEditController.deleteSelectedItems)
                      .show();
                },
                child: Column(
                  children: [
                    Icon(Icons.delete_forever_rounded,
                        size: 30, color: Get.theme.colorScheme.onPrimary),
                    Text(
                      'Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onPrimary),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
