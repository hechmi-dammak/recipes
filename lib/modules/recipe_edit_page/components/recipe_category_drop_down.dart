import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';
import 'package:recipes/utils/components/show_dialog.dart';
import 'package:recipes/utils/components/snack_bar.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

class RecipeCategoryDropDownInput extends StatefulWidget {
  const RecipeCategoryDropDownInput({super.key});

  @override
  State<RecipeCategoryDropDownInput> createState() =>
      _RecipeCategoryDropDownInputState();
}

class _RecipeCategoryDropDownInputState
    extends State<RecipeCategoryDropDownInput> {
  final GlobalKey dropdownKey = GlobalKey();

  final _categoryController = TextEditingController();

  final FocusNode _categoryNode = FocusNode();

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
      builder: (recipeEditController) {
        return SizedBox(
          height: 70,
          child: Row(
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  decoration: gradientDecoration(),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: GestureDetector(
                      onTap: () {
                        if (recipeEditController.recipeCategories.isNotEmpty) {
                          openItemsList();
                        } else {
                          CustomSnackBar.warning(
                              'There are no values yet add a new one.');
                        }
                      },
                      child: DropdownButtonFormField<String>(
                        focusNode: _categoryNode,
                        key: dropdownKey,
                        dropdownColor: Get.theme.colorScheme.primary,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Get.theme.colorScheme.onPrimary,
                            fontSize: 18),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                                fontSize: 20),
                            labelText: 'Category'),
                        iconSize: 30,
                        value: recipeEditController.recipe.category,
                        onChanged: (String? newValue) {
                          setState(() {
                            recipeEditController.recipe.category = newValue;
                          });
                        },
                        items: recipeEditController.recipeCategories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: gradientDecoration(),
                    child: InkWell(
                        onTap: () {
                          if (recipeEditController.recipe.category != null) {
                            setState(() {
                              recipeEditController.recipe.category = null;
                            });
                            return;
                          }
                          recipeEditController.isDialOpen = false;
                          InputDialog(
                              title: 'Create a new category',
                              label: 'Category',
                              controller: _categoryController,
                              confirm: () async {
                                if (_categoryController.text == '') {
                                  CustomSnackBar.warning(
                                      "Category shouldn't be empty.");
                                  return;
                                }
                                recipeEditController.addNewRecipeCategory(
                                    _categoryController.text);
                                setState(() {
                                  recipeEditController.recipe.category =
                                      _categoryController.text;
                                });
                                Get.back();

                                _categoryController.clear();
                              }).show();
                        },
                        child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Icon(
                                recipeEditController.recipe.category == null
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
