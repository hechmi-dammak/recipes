import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/ensure_visible.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientMeasuringDropDownInput extends StatefulWidget {
  const IngredientMeasuringDropDownInput({Key? key, required this.index})
      : super(key: key);
  final int index;

  @override
  State<IngredientMeasuringDropDownInput> createState() =>
      _IngredientMeasuringDropDownInputState();
}

class _IngredientMeasuringDropDownInputState
    extends State<IngredientMeasuringDropDownInput> {
  final RecipeEditController recipeEditController = RecipeEditController.find;

  final _measuringController = TextEditingController();

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
                  decoration: gradientDecoration(),
                  child: EnsureVisibleWhenFocused(
                    focusNode: _fieldNode,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: GestureDetector(
                        onTap: () {
                          if (recipeEditController
                              .ingredientMeasuring.isNotEmpty) {
                            openItemsList();
                          } else {
                            CustomSnackBar.warning(
                              'There are no values yet add a new one.',
                            );
                          }
                        },
                        child: DropdownButtonFormField<String>(
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
                              labelText: 'Measuring'),
                          iconSize: 30,
                          value: recipeEditController
                              .recipe.ingredients[widget.index].measuring,
                          onChanged: (String? newValue) {
                            setState(() {
                              recipeEditController
                                  .recipe
                                  .ingredients[widget.index]
                                  .measuring = newValue;
                            });
                          },
                          items: recipeEditController.ingredientMeasuring
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
                                  .recipe.ingredients[widget.index].measuring !=
                              null) {
                            setState(() {
                              recipeEditController.recipe
                                  .ingredients[widget.index].measuring = null;
                            });
                            return;
                          }
                          recipeEditController.isDialOpen = false;
                          InputDialog(
                              title: 'Create a new measuring',
                              label: 'Measuring',
                              controller: _measuringController,
                              confirm: () async {
                                if (_measuringController.text == '') {
                                  CustomSnackBar.warning(
                                      "Measuring shouldn't be empty.");
                                  return;
                                }
                                recipeEditController.addNewIngredientMeasuring(
                                    _measuringController.text);

                                setState(() {
                                  recipeEditController
                                      .recipe
                                      .ingredients[widget.index]
                                      .measuring = _measuringController.text;
                                });

                                Get.back();

                                _measuringController.clear();
                              }).show();
                        },
                        child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Icon(recipeEditController.recipe
                                        .ingredients[widget.index].measuring ==
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
