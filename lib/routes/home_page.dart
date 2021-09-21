import 'package:flutter/material.dart';
import 'package:recipes/components/floating_action_button.dart';
import 'package:recipes/components/recipe_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:recipes/service/json_operations.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe>? _recipes;
  bool deleteIsActive = false;
  bool loading = true;
  RecipeOperations recipeOperations = RecipeOperations.instance;
  JsonOperations jsonOperations = JsonOperations.instance;
  Future<void> initRecipes() async {
    _recipes = await recipeOperations.readAllForList();
    updateDeleteIsActive();
    setState(() {
      loading = false;
    });
  }

  deinitRecipes() async {
    setState(() {
      loading = true;
      _recipes = null;
    });
  }

  Future<void> _reloadData() async {
    await initRecipes();
  }

  @override
  void initState() {
    loading = true;
    initRecipes();
    super.initState();
  }

  bool _deleteIsActive() {
    if (_recipes == null) return false;
    for (var recipe in _recipes!) {
      if (recipe.selected ?? false) {
        return true;
      }
    }
    return false;
  }

  void updateDeleteIsActive([bool? deleteIsActive]) {
    setState(() {
      this.deleteIsActive = deleteIsActive ?? _deleteIsActive();
    });
  }

  void deleteSelected() async {
    if (_recipes == null) return;
    setState(() {
      loading = true;
    });
    var _copyRecipes = _recipes!.toList();
    for (Recipe recipe in _copyRecipes) {
      if ((recipe.selected ?? false) && (recipe.id != null)) {
        recipeOperations.delete(recipe.id!);
        _recipes!.remove(recipe);
      }
    }
    loading = false;
    updateDeleteIsActive();
    setState(() {});
  }

  void setSelectAllValue([bool value = false]) {
    if (_recipes == null) return;
    for (var recipe in _recipes!) {
      recipe.selected = value;
    }
    updateDeleteIsActive();
    setState(() {});
  }

  readFromFile() async {
    deinitRecipes();
    List<Recipe> recipes = await jsonOperations.readJson();
    await recipeOperations.createAll(recipes);
    initRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.6,
            ],
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryVariant,
            ],
          ),
          centerTitle: true,
          title: const Text(
            'Recipes List',
          ),
        ),
        floatingActionButton: RecipeListFloatingButton(
            setSelectAllValue: setSelectAllValue,
            deleteSelected: deleteSelected,
            deleteIsActiveFunction: updateDeleteIsActive,
            deleteIsActive: deleteIsActive,
            readFromFile: readFromFile),
        body: RefreshIndicator(
          onRefresh: _reloadData,
          child: _recipes != null && !loading
              ? _recipes!.isNotEmpty
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
                      itemCount: _recipes!.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                            recipe: _recipes![index],
                            deleteIsActive: deleteIsActive,
                            deleteIsActiveFunction: updateDeleteIsActive);
                      },
                    )
                  : ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 6,
                                  left: 10,
                                  right: 10),
                              child: const Center(
                                  child: Text(
                                "No recipes exists yet.\nPress import to load new recipes or you can  create your own.",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ],
                        )
                      ],
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
