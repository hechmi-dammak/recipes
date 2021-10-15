import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_list_page/components/empty_recipe_list.dart';
import 'package:recipes/modules/recipe_list_page/components/floating_action_button.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_card.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/loading_widget.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final RecipesController recipesController = RecipesController.find;
  bool loading = true;

  Future<void> initRecipes() async {
    await recipesController.loadRecipes();
  }

  @override
  void initState() {
    initRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (recipesController.isDialOpen.value) {
          setState(() {
            recipesController.setDialOpen(false);
          });
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: customAppBar(context, title: 'Recipes List'),
          floatingActionButton: const RecipeListFloatingButton(),
          body: RefreshIndicator(
            onRefresh: initRecipes,
            child: GetBuilder<RecipesController>(
              builder: (_) {
                return LoadingWidget(
                  loading: recipesController.loading.value,
                  child: recipesController.recipes.isNotEmpty
                      ? GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 3,
                            maxCrossAxisExtent: 500,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          shrinkWrap: true,
                          itemCount: recipesController.recipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(index: index);
                          },
                        )
                      : const EmptyRecipeList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
