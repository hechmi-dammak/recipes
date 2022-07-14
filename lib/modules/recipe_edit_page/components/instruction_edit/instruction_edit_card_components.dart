import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';
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
            decoration: gradientDecorationRounded(),
            child: InkWell(
                onTap: () {
                  recipeEditController.setInEditing(
                      recipeEditController.recipe.instructions[index],
                      value:
                          (recipeEditController.recipe.instructions[index].inEditing));
                  Scrollable.ensureVisible(context);
                },
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Icon(
                      recipeEditController.recipe.instructions[index].inEditing
                          ? Icons.check
                          : Icons.edit,
                      color: Get.theme.colorScheme.onPrimary,
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
        decoration: gradientDecorationRounded(),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ReorderableListener(
            child: Transform.scale(
              scale: 0.75,
              child: ImageIcon(
                  const AssetImage('assets/images/up_down_arrow.png'),
                  size: 10,
                  color: Get.theme.colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class InsideInstructionCard extends StatefulWidget {
  const InsideInstructionCard({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<InsideInstructionCard> createState() => InsideInstructionCardState();
}

class InsideInstructionCardState extends State<InsideInstructionCard> {
  RecipeEditController recipeEditController = RecipeEditController.find;
  final _instructionFormKey = GlobalKey<FormState>();
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
    if (recipeEditController.recipe.instructions[widget.index].inEditing) {
      child = EnsureVisibleWhenFocused(
        focusNode: _toDoNode,
        child: TextFormField(
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Get.theme.colorScheme.onSecondary),
          autovalidateMode: validation,
          key: _instructionFormKey,
          onTap: () => _requestFocus(_toDoNode),
          focusNode: _toDoNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please specify the Instruction';
            }
            return null;
          },
          initialValue: recipeEditController.recipe.instructions[widget.index].toDo,
          onChanged: (value) {
            setState(() {
              recipeEditController.recipe.instructions[widget.index].toDo = value;
              if (validation != null) validation = null;
            });
          },
          decoration: getInputDecoration(
            'To Do',
          ),
        ),
      );
    } else {
      child = Text(
        (recipeEditController.recipe.instructions[widget.index].toDo).capitalize!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.theme.buttonTheme.colorScheme!.onBackground),
      );
    }
    return Container(
        margin: recipeEditController.selectionIsActive
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
    if (recipeEditController.recipe.instructions[widget.index].toDo.isEmpty) {
      recipeEditController.setInEditingWithNoPropagation(
          recipeEditController.recipe.instructions[widget.index]);
      setState(() {
        validation = AutovalidateMode.always;
      });

      if (recipeEditController.validation &&
          _instructionFormKey.currentContext != null) {
        Scrollable.ensureVisible(_instructionFormKey.currentContext!);
      }
      recipeEditController.validation = false;
      return;
    }
    recipeEditController.setInEditingWithNoPropagation(
        recipeEditController.recipe.instructions[widget.index],
        value: false);
    return;
  }
}
