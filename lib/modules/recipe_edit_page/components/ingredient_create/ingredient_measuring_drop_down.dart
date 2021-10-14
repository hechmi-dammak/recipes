import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/dialog_input.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';

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
                  decoration: gradientDecoation(context),
                  child: EnsureVisibleWhenFocused(
                    focusNode: _fieldNode,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: GestureDetector(
                        onTap: () {
                          if (recipeEditController
                              .ingredientMeasurings.isNotEmpty) {
                            openItemsList();
                          } else {
                            showInSnackBar(
                                "There are no values yet add a new one.",
                                status: false);
                          }
                        },
                        child: DropdownButtonFormField<String>(
                          key: dropdownKey,
                          dropdownColor:
                              Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 18),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 20),
                              labelText: "Measuring"),
                          iconSize: 30,
                          value: recipeEditController.recipe.value
                              .ingredients![widget.index].measuring,
                          onChanged: (String? newValue) {
                            setState(() {
                              recipeEditController
                                  .recipe
                                  .value
                                  .ingredients![widget.index]
                                  .measuring = newValue;
                            });
                          },
                          items: recipeEditController.ingredientMeasurings
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
                                  .ingredients![widget.index].measuring !=
                              null) {
                            setState(() {
                              recipeEditController.recipe.value
                                  .ingredients![widget.index].measuring = null;
                            });
                            return;
                          }

                          showDialogInput(
                              title: 'Create a new measuring',
                              label: 'Measuring',
                              controller: _measuringController,
                              confirm: () async {
                                if (_measuringController.text == "") {
                                  showInSnackBar(
                                      "Measuring shouldn't be empty.");
                                  return;
                                }
                                recipeEditController.addNewIngredientMeasuring(
                                    _measuringController.text);

                                setState(() {
                                  recipeEditController
                                      .recipe
                                      .value
                                      .ingredients![widget.index]
                                      .measuring = _measuringController.text;
                                });

                                Get.back();

                                _measuringController.clear();
                              });
                        },
                        child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Icon(recipeEditController.recipe.value
                                        .ingredients![widget.index].measuring ==
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
