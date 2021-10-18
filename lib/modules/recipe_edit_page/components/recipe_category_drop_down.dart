import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/dialog_input.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

class RecipeCategoryDropDownInput extends StatefulWidget {
  const RecipeCategoryDropDownInput({Key? key}) : super(key: key);

  @override
  State<RecipeCategoryDropDownInput> createState() =>
      _RecipeCategoryDropDownInputState();
}

class _RecipeCategoryDropDownInputState
    extends State<RecipeCategoryDropDownInput> {
  final GlobalKey dropdownKey = GlobalKey();

  final RecipeEditController recipeEditController = RecipeEditController.find;

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
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: Container(
              decoration: gradientDecoation(context),
              child: ButtonTheme(
                alignedDropdown: true,
                child: GestureDetector(
                  onTap: () {
                    if (recipeEditController.recipeCategories.isNotEmpty) {
                      openItemsList();
                    } else {
                      showInSnackBar("There are no values yet add a new one.",
                          status: false);
                    }
                  },
                  child: DropdownButtonFormField<String>(
                    focusNode: _categoryNode,
                    key: dropdownKey,
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20),
                        labelText: 'Category'),
                    iconSize: 30,
                    value: recipeEditController.recipe.value.category,
                    onChanged: (String? newValue) {
                      setState(() {
                        recipeEditController.recipe.value.category = newValue;
                      });
                    },
                    items: recipeEditController.recipeCategories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: value);
                    }).toList(),
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
                      if (recipeEditController.recipe.value.category != null) {
                        setState(() {
                          recipeEditController.recipe.value.category = null;
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
                              showInSnackBar("Category shouldn't be empty.");
                              return;
                            }
                            recipeEditController
                                .addNewRecipeCategory(_categoryController.text);
                            setState(() {
                              recipeEditController.recipe.value.category =
                                  _categoryController.text;
                            });
                            Get.back();

                            _categoryController.clear();
                          });
                    },
                    child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Icon(
                            recipeEditController.recipe.value.category == null
                                ? Icons.add
                                : Icons.close_rounded))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
