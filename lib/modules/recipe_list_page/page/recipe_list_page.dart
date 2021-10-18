import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_list_page/components/empty_recipe_list.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_list_floating_action_button.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_card.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/decorations/input_decoration_inside_card.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  var isDialOpen = ValueNotifier<bool>(false);

  final RecipesController recipesController = RecipesController.find;
  final _searchController = TextEditingController();

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
    return GetBuilder<RecipesController>(builder: (_) {
      return WillPopScope(
        onWillPop: () async {
          if (recipesController.searchActive.value) {
            setState(() {
              recipesController.setSearchActive(false);
            });
            return false;
          }
          if (isDialOpen.value) {
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
            appBar: customAppBar(context,
                title: 'Recipes List',
                titleWidget: recipesController.searchActive.value
                    ? TextFormField(
                        decoration: getInputDecorationInsideCardHint(
                          "Search",
                          suffix: GestureDetector(
                            child: Icon(
                              Icons.close_rounded,
                              size: 30,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            onTap: () {
                              setState(() {
                                _searchController.text = "";
                                recipesController.searchValue.value = "";
                                recipesController.updateSearch();
                              });
                            },
                          ),
                        ),
                        controller: _searchController,
                        onChanged: (value) {
                          recipesController.setSeachValue(value);
                        },
                      )
                    : null,
                leading: recipesController.searchActive.value
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            recipesController.setSearchActive(false);
                          });
                        },
                      )
                    : null,
                actions: recipesController.searchActive.value
                    ? null
                    : [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 30,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            setState(() {
                              recipesController.setSearchActive(true);
                            });
                          },
                        ),
                      ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  recipesController.selectionIsActive.value
                      ? FloatingActionButton(
                          onPressed: () =>
                              recipesController.deleteSelectedRecipes(),
                          child: const Icon(Icons.delete_forever_rounded,
                              size: 30),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        )
                      : const Text(
                          "",
                        ),
                  const RecipeListFloatingButton(),
                ],
              ),
            ),
            body: RefreshIndicator(
                onRefresh: initRecipes,
                child: LoadingWidget(
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
                )),
          ),
        ),
      );
    });
  }
}
