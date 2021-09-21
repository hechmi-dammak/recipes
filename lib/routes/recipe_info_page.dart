import 'package:flutter/material.dart';
import 'package:recipes/components/ingredient_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'dart:math';
import 'package:recipes/utils/string_extenstions.dart';

class RecipeInfoPage extends StatefulWidget {
  final int? recipeId;
  const RecipeInfoPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeInfoPage> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends State<RecipeInfoPage> {
  Recipe? _recipe;
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
    setState(() {});
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
            title: Text(
              _recipe == null ? "" : _recipe!.name.capitalize(),
            ),
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
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _initRecipe,
            child: _recipe != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: SpinBox(
                                incrementIcon: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 50),
                                decrementIcon: const Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 50),
                                decoration: InputDecoration(
                                    label: Text("Servings",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .primaryColor))),
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                keyboardType: TextInputType.number,
                                min: 1,
                                max: double.infinity,
                                value: servings.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    servings = value.toInt();
                                  });
                                },
                              ),
                            ),
                            buildIngredient(context),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          )),
    );
  }

  Widget buildIngredient(BuildContext context) {
    if (_recipe!.ingredientsByCategory == null) {
      return Container();
    }
    List<Widget> children = [];
    _recipe!.ingredientsByCategory!.forEach((key, value) {
      children.add(Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(
          key.capitalize(),
          style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        ),
      ));
      if (key == "spices") {
        children.add(Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 150,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return IngredientCard(
                servings: servings,
                ingredient: value[index],
              );
            },
            itemCount: value.length,
          ),
        ));
      } else {
        children.add(Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 300,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.5,
              crossAxisCount:
                  min(2, (MediaQuery.of(context).size.width / 350).ceil()),
              mainAxisExtent: 300,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return IngredientCard(
                ingredient: value[index],
                servings: servings,
              );
            },
            itemCount: value.length,
          ),
        ));
      }
    });
    return Column(
      children: children,
    );
  }
}
