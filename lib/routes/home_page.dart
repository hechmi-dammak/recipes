import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/recipe_list_page/floating_action_button.dart';
import 'package:recipes/components/recipe_list_page/recipe_card.dart';
import 'package:recipes/components/utils/app_bar.dart';
import 'package:recipes/components/decorations/recipe_list_page/empty_recipe_list.dart';
import 'package:recipes/components/utils/loading_widget.dart';
import 'package:recipes/controller/recipes_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: customAppBar(context, title: 'Recipes List'),
        floatingActionButton: const RecipeListFloatingButton(),
        body: RefreshIndicator(
          onRefresh: initRecipes,
          child: GetBuilder<RecipesController>(
            builder: (recipesController) {
              return LoadingWidget(
                loading: recipesController.loading.value,
                child: recipesController.recipes.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
    );
  }
}
