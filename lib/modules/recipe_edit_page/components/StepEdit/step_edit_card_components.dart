import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'package:recipes/utils/components/ensure_visible.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

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
                  Scrollable.ensureVisible(context);
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
            child: Transform.scale(
              scale: 0.75,
              child: ImageIcon(
                  const AssetImage('assets/images/up_down_arrow.png'),
                  size: 10,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
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
    Widget? child;
    if (recipeEditController.recipe.value.steps![widget.index].inEditing ??
        false) {
      child = EnsureVisibleWhenFocused(
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
          decoration: getInputDecoration(
            "To Do",
          ),
        ),
      );
    } else {
      child = Text(
        (recipeEditController.recipe.value.steps![widget.index].toDo ?? "")
            .capitalize!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).buttonTheme.colorScheme!.onBackground),
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
    if (recipeEditController.recipe.value.steps![widget.index].toDo == null ||
        recipeEditController.recipe.value.steps![widget.index].toDo!.isEmpty) {
      recipeEditController.setInEditingWithNoPropagation(
          recipeEditController.recipe.value.steps![widget.index],
          value: true);
      setState(() {
        validation = AutovalidateMode.always;
      });

      if (recipeEditController.validation &&
          _stepFormKey.currentContext != null) {
        Scrollable.ensureVisible(_stepFormKey.currentContext!);
      }
      recipeEditController.validation = false;
      return;
    }
    recipeEditController.setInEditingWithNoPropagation(
        recipeEditController.recipe.value.steps![widget.index],
        value: false);
    return;
  }
}
