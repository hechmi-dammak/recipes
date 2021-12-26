import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/components/StepEdit/step_edit_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/floating_action_button.dart';
import 'package:recipes/modules/recipe_edit_page/components/image_edit.dart';
import 'package:recipes/modules/recipe_edit_page/components/ingredient_edit/ingredient_edit_list.dart';
import 'package:recipes/modules/recipe_edit_page/components/recipe_category_drop_down.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/modules/recipe_info_page/controller/recipe_info_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/app_bar_bottom.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/components/serving_spin_box.dart';
import 'package:recipes/utils/components/show_dialog.dart';
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
  final ingredientsListKey = GlobalKey<IngredientEditListState>();
  final stepsListKey = GlobalKey<StepEditListState>();
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
              bottomNavigationBar: BottomBar(),
              floatingActionButton: recipeEditController.selectionIsActive.value
                  ? null
                  : const RecipeCreateFloatingButton(),
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
                              if (recipeEditController.recipe.value.id !=
                                  null) {
                                RecipeInfoController.find.initRecipe(
                                    recipeEditController.recipe.value.id);
                              }
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
                    if (recipeEditController.selectionIsActive.value) ...[
                      if (recipeEditController.allItemsSelected.value)
                        TextButton(
                            onPressed: () =>
                                recipeEditController.setSelectAllValue(false),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline_outlined,
                                    size: 30,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                Text(
                                  "All",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              Text(
                                "All",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              )
                            ],
                          ),
                        ),
                    ] else
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            recipeEditController.setLoading(true);
                          });
                          await validateRecipe();
                          if (recipeEditController.validation) {
                            await recipeEditController.saveRecipe();

                            recipeEditController.setDialOpen(false);
                            if (Get.isSnackbarOpen) {
                              Get.back();
                            }
                            if (recipeEditController.recipe.value.id != null) {
                              RecipeInfoController.find.initRecipe(
                                  recipeEditController.recipe.value.id);
                            }

                            Get.back(result: true);
                          } else {
                            showInSnackBar("Failed to save recipe");
                            setState(() {
                              recipeEditController.setLoading(false);
                            });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save,
                                size: 30,
                                color: Theme.of(context).colorScheme.onPrimary),
                            Text(
                              "Save",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )
                          ],
                        ),
                      )
                  ]),
              body: AppbarBottom(
                child: LoadingWidget(
                  loading: recipeEditController.loading.value,
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
                                  changeServingFunction: (double value) {
                                    setState(() {
                                      recipeEditController
                                          .setServingValue(value.toInt());
                                    });
                                  },
                                  servings:
                                      recipeEditController.servings.value)),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        initialValue: recipeEditController
                                            .recipe.value.name,
                                        onChanged: (value) {
                                          setState(() {
                                            recipeEditController
                                                .recipe.value.name = value;
                                          });
                                        },
                                        decoration: getInputDecoration("Name",
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 20,
                                                    top: 15,
                                                    bottom: 15)),
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
                          IngredientEditList(key: ingredientsListKey),
                          const SizedBox(
                            height: 15,
                          ),
                          StepEditList(key: stepsListKey)
                        ],
                      ),
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

  Future validateRecipe() async {
    recipeEditController.validation = true;
    if (_recipeFormKey.currentState == null ||
        !_recipeFormKey.currentState!.validate()) {
      recipeEditController.validation = false;
      recipeEditController.mainScrollController.animateTo(
        recipeEditController.mainScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceInOut,
      );
    }

    if (ingredientsListKey.currentState == null) {
      recipeEditController.validation = false;
    } else {
      await ingredientsListKey.currentState!.validate();
    }
    if (stepsListKey.currentState == null) {
      recipeEditController.validation = false;
    } else {
      await stepsListKey.currentState!.validate();
    }
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
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  showConfirmationDialog(
                      title: "These items will be deleted.",
                      confirm: recipeEditController.deleteSelectedItems);
                },
                child: Column(
                  children: [
                    Icon(Icons.delete_forever_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                    Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                )),
          ],
        ),
      ),
      height: recipeEditController.selectionIsActive.value ? 75 : 0,
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
            Theme.of(context).primaryColorDark,
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
    );
  }
}
