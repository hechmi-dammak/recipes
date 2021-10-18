import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/input_decoration_inside_card.dart';

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
                      recipeEditController.recipe.value.steps![index],
                      value: !(recipeEditController
                              .recipe.value.steps![index].inEditing ??
                          false));
                },
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Icon(
                      recipeEditController
                                  .recipe.value.steps![index].inEditing ??
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

class DragButton extends StatelessWidget {
  const DragButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      top: 0,
      child: Container(
        height: 60,
        width: 60,
        decoration: gradientDecoationRounded(context),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ReorderableListener(
              child: Icon(
            Icons.reorder,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
        ),
      ),
    );
  }
}

class InsideStepCard extends StatefulWidget {
  const InsideStepCard({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<InsideStepCard> createState() => InsideStepCardState();
}

class InsideStepCardState extends State<InsideStepCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;
  final _stepFormKey = GlobalKey<FormState>();
  final _toDoNode = FocusNode();
  AutovalidateMode? validation;
  @override
  void dispose() {
    _toDoNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (recipeEditController.recipe.value.steps![widget.index].inEditing ??
        false) {
      return EnsureVisibleWhenFocused(
        focusNode: _toDoNode,
        child: TextFormField(
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSecondary),
          autovalidateMode: validation,
          key: _stepFormKey,
          onTap: () => _requestFocus(_toDoNode),
          focusNode: _toDoNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please specify the Step';
            }
            return null;
          },
          initialValue:
              recipeEditController.recipe.value.steps![widget.index].toDo,
          onChanged: (value) {
            setState(() {
              recipeEditController.recipe.value.steps![widget.index].toDo =
                  value;
              if (validation != null) validation = null;
            });
          },
          decoration: getInputDecorationInsideCard("To Do",
              focusNode: _toDoNode,
              value:
                  recipeEditController.recipe.value.steps![widget.index].toDo),
        ),
      );
    } else {
      return Text(
        (recipeEditController.recipe.value.steps![widget.index].toDo ?? "")
            .capitalize!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: recipeEditController
                        .recipe.value.steps![widget.index].selected ??
                    false
                ? Theme.of(context).buttonTheme.colorScheme!.onPrimary
                : Theme.of(context).buttonTheme.colorScheme!.onSecondary),
      );
    }
  }

  void _requestFocus(FocusNode focusNode) {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<bool> validate() async {
    if (recipeEditController.recipe.value.steps![widget.index].toDo == null ||
        recipeEditController.recipe.value.steps![widget.index].toDo!.isEmpty) {
      recipeEditController.setInEditingWithNoPropagation(
          recipeEditController.recipe.value.steps![widget.index],
          value: true);
      setState(() {
        validation = AutovalidateMode.always;
      });

      return false;
    }
    recipeEditController.setInEditingWithNoPropagation(
        recipeEditController.recipe.value.steps![widget.index],
        value: false);
    return true;
  }
}
