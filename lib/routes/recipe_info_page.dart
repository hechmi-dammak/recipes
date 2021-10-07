import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/ingredient_list.dart';
import 'package:recipes/components/utils/app_bar.dart';
import 'package:recipes/components/utils/loading_widget.dart';
import 'package:recipes/components/utils/serving_spin_box.dart';
import 'package:recipes/controller/recipe_info_controller.dart';

class RecipeInfoPage extends StatefulWidget {
  final int? recipeId;
  const RecipeInfoPage({Key? key, this.recipeId}) : super(key: key);

  @override
  State<RecipeInfoPage> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends State<RecipeInfoPage> {
  RecipeInfoController recipeInfoController = RecipeInfoController.find;

  @override
  void initState() {
    recipeInfoController.initRecipe(widget.recipeId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (recipeInfoController) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: customAppBar(context,
                  title: recipeInfoController.recipe.name.capitalize!,
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (recipeInfoController.recipe.ingredients != null) {
                            for (var element
                                in recipeInfoController.recipe.ingredients!) {
                              element.selected = false;
                            }
                          }
                          recipeInfoController.setServingDefaultValue();
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh))
                  ]),
              body: LoadingWidget(
                loading: recipeInfoController.loading.value,
                child: RefreshIndicator(
                  onRefresh: () =>
                      recipeInfoController.initRecipe(widget.recipeId),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: ServingSpinBox(
                                  changeServingFunction: (double value) {
                                    setState(() {
                                      recipeInfoController.servings.value =
                                          value.toInt();
                                    });
                                  },
                                  servings:
                                      recipeInfoController.servings.value)),
                          IngredientsList(
                              servings: recipeInfoController.servings.value,
                              ingredientsByCategory: recipeInfoController
                                  .recipe.ingredientsByCategory),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
