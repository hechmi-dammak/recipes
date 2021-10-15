import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/dialog_input.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

class IngredientCategoryDropDownInput extends StatefulWidget {
  const IngredientCategoryDropDownInput({Key? key, required this.index})
      : super(key: key);
  final int index;

  @override
  State<IngredientCategoryDropDownInput> createState() =>
      _IngredientCategoryDropDownInputState();
}

class _IngredientCategoryDropDownInputState
    extends State<IngredientCategoryDropDownInput> {
  final RecipeEditController recipeEditController = RecipeEditController.find;

  final _categoryController = TextEditingController();

  final FocusNode _fieldNode = FocusNode();

  final GlobalKey dropdownKey = GlobalKey();
  void openItemsList() {
    dynamic detector;
    void search(BuildContext context) {
      context.visitChildElements((element) {
        if (detector != null) return;
        if (element.widget is GestureDetector) {
          detector = element.widget;
        } else {
          search(element);
        }
      });
    }

    search(dropdownKey.currentContext!);
    if (detector != null) detector.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (_) {
        return SizedBox(
          height: 70,
          child: Row(
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  decoration: gradientDecoation(context),
                  child: EnsureVisibleWhenFocused(
                    focusNode: _fieldNode,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: GestureDetector(
                        onTap: () {
                          if (recipeEditController
                              .ingredientCategories.isNotEmpty) {
                            openItemsList();
                          } else {
                            showInSnackBar(
                                "There are no values yet add a new one.",
                                status: false);
                          }
                        },
                        child: DropdownButtonFormField<String>(
                          focusNode: _fieldNode,
                          key: dropdownKey,
                          dropdownColor: Theme.of(context).colorScheme.primary,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 20),
                              labelText: "Category"),
                          iconSize: 30,
                          value: recipeEditController
                              .recipe.value.ingredients![widget.index].category,
                          onChanged: (String? newValue) {
                            setState(() {
                              recipeEditController
                                  .recipe
                                  .value
                                  .ingredients![widget.index]
                                  .category = newValue;
                            });
                          },
                          items: recipeEditController.ingredientCategories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                child: Text(value), value: value);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                flex: 1,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: gradientDecoation(context),
                    child: InkWell(
                        onTap: () {
                          if (recipeEditController.recipe.value
                                  .ingredients![widget.index].category !=
                              null) {
                            setState(() {
                              recipeEditController.recipe.value
                                  .ingredients![widget.index].category = null;
                            });
                            return;
                          }
                          recipeEditController.setDialOpen(false);
                          showDialogInput(
                              title: 'Create a new category',
                              label: 'Category',
                              controller: _categoryController,
                              confirm: () async {
                                if (_categoryController.text == "") {
                                  showInSnackBar(
                                      "Category shouldn't be empty.");
                                  return;
                                }
                                recipeEditController.addNewIngredientCategory(
                                    _categoryController.text);
                                setState(() {
                                  recipeEditController
                                      .recipe
                                      .value
                                      .ingredients![widget.index]
                                      .category = _categoryController.text;
                                });

                                Get.back();

                                _categoryController.clear();
                              });
                        },
                        child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Icon(recipeEditController.recipe.value
                                        .ingredients![widget.index].category ==
                                    null
                                ? Icons.add
                                : Icons.close_rounded))),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
