import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/Page/recipe_edit_page.dart';
import 'package:recipes/modules/recipe_info_page.dart/components/ingredients/ingredient_list.dart';
import 'package:recipes/modules/recipe_info_page.dart/components/steps/step_list.dart';
import 'package:recipes/modules/recipe_info_page.dart/controller/recipe_info_controller.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/app_bar_bottom.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/components/serving_spin_box.dart';

class RecipeInfoPage extends StatefulWidget {
  final int? recipeId;
  const RecipeInfoPage({Key? key, this.recipeId}) : super(key: key);

  @override
  State<RecipeInfoPage> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends State<RecipeInfoPage> {
  RecipeOperations recipeOperations = RecipeOperations.instance;
  RecipeInfoController recipeInfoController = RecipeInfoController.find;
  @override
  void initState() {
    recipeInfoController.initRecipe(widget.recipeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (_) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: customAppBar(context,
                title: recipeInfoController.recipe.value.name.capitalize!,
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.to(() => RecipeEditPage(recipeId: widget.recipeId));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ))
                ],
                leading: Navigator.of(context).canPop()
                    ? IconButton(
                        onPressed: () async {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 25,
                        ))
                    : null),
            body: AppbarBottom(
              child: RefreshIndicator(
                onRefresh: () =>
                    recipeInfoController.initRecipe(widget.recipeId),
                child: LoadingWidget(
                  loading: recipeInfoController.loading.value,
                  child: ListView(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: ServingSpinBox(
                              changeServingFunction: (double value) {
                                setState(() {
                                  recipeInfoController
                                      .setServingValue(value.toInt());
                                });
                              },
                              servings: recipeInfoController.servings.value)),
                      recipeInfoController.recipe.value.picture == null ||
                              recipeInfoController
                                      .recipe.value.picture!.image ==
                                  null
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 4),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: MemoryImage(recipeInfoController
                                      .recipe.value.picture!.image!),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              height: (MediaQuery.of(context).size.width - 40) *
                                  0.5625,
                            ),
                      IngredientsList(),
                      StepsList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
