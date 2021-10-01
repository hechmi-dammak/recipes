import 'package:flutter/material.dart';
import 'package:recipes/components/app_bar.dart';
import 'package:recipes/components/ingredient_list.dart';
import 'package:recipes/components/loading_widget.dart';
import 'package:recipes/components/serving_spin_box.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/string_extenstions.dart';

class RecipeInfoPage extends StatefulWidget {
  final int? recipeId;
  const RecipeInfoPage({Key? key, this.recipeId}) : super(key: key);

  @override
  State<RecipeInfoPage> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends State<RecipeInfoPage> {
  Recipe? _recipe;
  bool loading = true;
  RecipeOperations recipeOperations = RecipeOperations.instance;
  int servings = 4;
  @override
  void initState() {
    _initRecipe();
    super.initState();
  }

  Future<void> _initRecipe() async {
    if (widget.recipeId == null) {
      _recipe = Recipe();
    } else {
      _recipe = await recipeOperations.read(widget.recipeId!);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: customAppBar(context,
              title: _recipe == null ? "" : _recipe!.name.capitalize(),
              actions: [
                IconButton(
                    onPressed: () {
                      if (_recipe!.ingredients != null) {
                        for (var element in _recipe!.ingredients!) {
                          element.selected = false;
                        }
                      }
                      servings = 4;
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh))
              ]),
          body: RefreshIndicator(
            onRefresh: _initRecipe,
            child: LoadingWidget(
              loading: loading,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 15, top: 15),
                          child: ServingSpinBox(
                              changeServingFunction: (double value) {
                                setState(() {
                                  servings = value.toInt();
                                });
                              },
                              servings: servings)),
                      IngredientsList(
                          servings: servings,
                          ingredientsByCategory:
                              _recipe?.ingredientsByCategory),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
