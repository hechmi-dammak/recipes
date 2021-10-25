import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

import 'ingredient_category_drop_down.dart';
import 'ingredient_measuring_drop_down.dart';
import 'ingredient_size_drop_down.dart';

class EditButton extends StatelessWidget {
  EditButton({Key? key, required this.index}) : super(key: key);
  final int index;
  final RecipeEditController recipeEditController = RecipeEditController.find;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 0,
      child: SizedBox(
        height: 60,
        width: 60,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: gradientDecoationRounded(context),
            child: InkWell(
                onTap: () {
                  recipeEditController.setInEditing(
                      recipeEditController.recipe.value.ingredients![index],
                      value: !(recipeEditController
                              .recipe.value.ingredients![index].inEditing ??
                          false));
                  Scrollable.ensureVisible(context);
                },
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Icon(
                      recipeEditController
                                  .recipe.value.ingredients![index].inEditing ??
                              false
                          ? Icons.check
                          : Icons.edit,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ))),
          ),
        ),
      ),
    );
  }
}

class InsideIngredientCard extends StatefulWidget {
  const InsideIngredientCard({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<InsideIngredientCard> createState() => InsideIngredientCardState();
}

class InsideIngredientCardState extends State<InsideIngredientCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;

  final _ingredientFormKey = GlobalKey<FormState>();
  final _nameNode = FocusNode();
  final _quantityNode = FocusNode();
  final _methodNode = FocusNode();
  AutovalidateMode? validation;
  @override
  void dispose() {
    _nameNode.dispose();
    _quantityNode.dispose();
    _methodNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (recipeEditController
            .recipe.value.ingredients![widget.index].inEditing ??
        false) {
      child = Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Form(
                  child: EnsureVisibleWhenFocused(
                    focusNode: _nameNode,
                    child: TextFormField(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSecondary),
                      key: _ingredientFormKey,
                      onTap: () => _requestFocus(_nameNode),
                      focusNode: _nameNode,
                      initialValue: recipeEditController
                          .recipe.value.ingredients![widget.index].name,
                      onChanged: (value) {
                        setState(() {
                          recipeEditController.recipe.value
                              .ingredients![widget.index].name = value;
                          if (validation != null) validation = null;
                        });
                      },
                      decoration: getInputDecoration("Name"),
                      autovalidateMode: validation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please specify a name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: IngredientCategoryDropDownInput(index: widget.index),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: EnsureVisibleWhenFocused(
                  focusNode: _quantityNode,
                  child: TextFormField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSecondary),
                    onTap: () => _requestFocus(_quantityNode),
                    focusNode: _quantityNode,
                    keyboardType: TextInputType.number,
                    initialValue: recipeEditController
                        .recipe.value.ingredients![widget.index].quantity
                        ?.toString(),
                    onChanged: (value) {
                      setState(() {
                        recipeEditController
                            .recipe
                            .value
                            .ingredients![widget.index]
                            .quantity = num.tryParse(value);
                      });
                    },
                    decoration: getInputDecoration(
                      "Quantity",
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: IngredientMeasuringDropDownInput(index: widget.index),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: IngredientSizeDropDownInput(index: widget.index),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: EnsureVisibleWhenFocused(
                  focusNode: _methodNode,
                  child: TextFormField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSecondary),
                    onTap: () => _requestFocus(_methodNode),
                    focusNode: _methodNode,
                    initialValue: recipeEditController
                        .recipe.value.ingredients![widget.index].method,
                    onChanged: (value) {
                      setState(() {
                        recipeEditController.recipe.value
                            .ingredients![widget.index].method = value;
                      });
                    },
                    decoration: getInputDecoration(
                      "Method",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      child = Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              recipeEditController
                  .recipe.value.ingredients![widget.index].name.capitalize!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground),
            ),
          ),
          if (recipeEditController
                  .recipe.value.ingredients![widget.index].category !=
              null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                recipeEditController.recipe.value.ingredients![widget.index]
                    .category!.capitalize!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .buttonTheme
                        .colorScheme!
                        .onBackground),
              ),
            ),
          if (recipeEditController.recipe.value.ingredients![widget.index]
                  .getQuantity(1) !=
              null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                recipeEditController.recipe.value.ingredients![widget.index]
                    .getQuantity(1)!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .buttonTheme
                        .colorScheme!
                        .onBackground),
              ),
            ),
          if (recipeEditController
                  .recipe.value.ingredients![widget.index].method !=
              null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                recipeEditController.recipe.value.ingredients![widget.index]
                    .method!.capitalize!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15,
                    color: Theme.of(context)
                        .buttonTheme
                        .colorScheme!
                        .onBackground),
              ),
            )
        ],
      );
    }
    return Container(
        margin: recipeEditController.selectionIsActive.value
            ? const EdgeInsets.only(top: 25)
            : null,
        child: child);
  }

  void _requestFocus(FocusNode focusNode) {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future validate() async {
    if (recipeEditController
        .recipe.value.ingredients![widget.index].name.isEmpty) {
      await recipeEditController.setInEditingWithNoPropagation(
          recipeEditController.recipe.value.ingredients![widget.index],
          value: true);
      setState(() {
        validation = AutovalidateMode.always;
      });
      if (recipeEditController.validation &&
          _ingredientFormKey.currentContext != null) {
        Scrollable.ensureVisible(_ingredientFormKey.currentContext!);
      }
      recipeEditController.validation = false;
      return;
    }
    recipeEditController.setInEditingWithNoPropagation(
        recipeEditController.recipe.value.ingredients![widget.index],
        value: false);
    return;
  }
}
