import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/ensure_visible.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientSizeDropDownInput extends StatefulWidget {
  const IngredientSizeDropDownInput({Key? key, required this.index})
      : super(key: key);
  final int index;

  @override
  State<IngredientSizeDropDownInput> createState() =>
      _IngredientSizeDropDownInputState();
}

class _IngredientSizeDropDownInputState
    extends State<IngredientSizeDropDownInput> {
  final RecipeEditController recipeEditController = RecipeEditController.find;

  final _sizeController = TextEditingController();

  final FocusNode _fieldNode = FocusNode();

  final GlobalKey dropdownKey = GlobalKey();

//this is used so the tap area is for the whole button not just the label
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
                  decoration: gradientDecoration(),
                  child: EnsureVisibleWhenFocused(
                    focusNode: _fieldNode,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: GestureDetector(
                        onTap: () {
                          if (recipeEditController.ingredientSizes.isNotEmpty) {
                            openItemsList();
                          } else {
                            CustomSnackBar.warning(
                              'There are no values yet add a new one.',
                            );
                          }
                        },
                        child: DropdownButtonFormField<String>(
                          focusNode: _fieldNode,
                          key: dropdownKey,
                          dropdownColor: Get.theme.colorScheme.primary,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Get.theme.colorScheme.onPrimary,
                              fontSize: 18),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Get.theme.colorScheme.onPrimary,
                                  fontSize: 20),
                              labelText: 'Size'),
                          iconSize: 30,
                          value: recipeEditController
                              .recipe.ingredients[widget.index].size,
                          onChanged: (String? newValue) {
                            setState(() {
                              recipeEditController.recipe
                                  .ingredients[widget.index].size = newValue;
                            });
                          },
                          items: recipeEditController.ingredientSizes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
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
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: gradientDecoration(),
                    child: InkWell(
                        onTap: () {
                          if (recipeEditController
                                  .recipe.ingredients[widget.index].size !=
                              null) {
                            setState(() {
                              recipeEditController
                                  .recipe.ingredients[widget.index].size = null;
                            });
                            return;
                          }
                          recipeEditController.isDialOpen = false;
                          InputDialog(
                              title: 'Create a new size',
                              label: 'Size',
                              controller: _sizeController,
                              confirm: () async {
                                if (_sizeController.text == '') {
                                  CustomSnackBar.warning(
                                      "Size shouldn't be empty.");
                                  return;
                                }
                                recipeEditController
                                    .addNewIngredientSize(_sizeController.text);
                                setState(() {
                                  recipeEditController
                                      .recipe
                                      .ingredients[widget.index]
                                      .size = _sizeController.text;
                                });

                                Get.back();

                                _sizeController.clear();
                              }).show();
                        },
                        child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Icon(recipeEditController.recipe
                                        .ingredients[widget.index].size ==
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
