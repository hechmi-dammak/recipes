import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decoration/gradient_decoration.dart';
import 'package:recipes/components/utils/dialog_input.dart';
import 'package:recipes/components/utils/show_snack_bar.dart';
import 'package:recipes/controller/recipe_create_controller.dart';

class CategoryDropDownInput extends StatelessWidget {
  CategoryDropDownInput({Key? key}) : super(key: key);

  final RecipeCreateController recipeCreateController =
      RecipeCreateController.find;
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: Container(
            decoration: gradientDecoation(context),
            child: DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).colorScheme.secondary,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 18),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                  labelText: 'Category'),
              iconSize: 40,
              value: recipeCreateController.recipe.value.category,
              onChanged: (String? newValue) {
                recipeCreateController.recipe.value.category = newValue!;
              },
              items: recipeCreateController.recipeCategories
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    child: Text(value), value: value);
              }).toList(),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: TextButton(
              onPressed: () {
                showDialogInput(
                    title: 'Create a new category',
                    label: 'Category',
                    controller: _categoryController,
                    confirm: () async {
                      if (_categoryController.text == "") {
                        showInSnackBar("Category shouldn't be empty.");
                        return;
                      }
                      recipeCreateController
                          .addNewCategory(_categoryController.text);
                      recipeCreateController.recipe.value.category =
                          _categoryController.text;

                      Get.back();

                      _categoryController.clear();
                    });
              },
              child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: gradientDecoation(context),
                  child: const Icon(Icons.add))),
        )
      ],
    );
  }
}
