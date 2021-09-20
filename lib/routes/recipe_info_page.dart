import 'package:flutter/material.dart';
import 'package:recipes/components/ingredient_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'dart:math';

class RecipeInfoPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeInfoPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeInfoPage> createState() => _RecipeInfoPageState();
}

class _RecipeInfoPageState extends State<RecipeInfoPage> {
  int servings = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            widget.recipe.getName(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (widget.recipe.spices != null) {
                    for (var element in widget.recipe.spices!) {
                      element.selected = false;
                    }
                  }
                  if (widget.recipe.ingredients != null) {
                    for (var element in widget.recipe.ingredients!) {
                      element.selected = false;
                    }
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 20,
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
                                  color: Theme.of(context).primaryColor))),
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary),
                      keyboardType: TextInputType.number,
                      min: 1,
                      max: 10,
                      value: servings.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          servings = value.toInt();
                        });
                      },
                    ),
                  ),
                  widget.recipe.spices!.isNotEmpty
                      ? Container(
                          height: 30,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Spices",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : Container(),
                  widget.recipe.spices != null &&
                          widget.recipe.spices!.isNotEmpty
                      ? SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return IngredientCard(
                                servings: servings,
                                ingredient: widget.recipe.spices![index],
                              );
                            },
                            itemCount: widget.recipe.spices!.length,
                          ),
                        )
                      : Container(),
                  widget.recipe.ingredients!.isNotEmpty
                      ? Container(
                          height: 30,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "Ingredients",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : Container(),
                  widget.recipe.ingredients != null &&
                          widget.recipe.ingredients!.isNotEmpty
                      ? SizedBox(
                          height: 400,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.5,
                              crossAxisCount: min(
                                  2,
                                  (MediaQuery.of(context).size.width / 350)
                                      .ceil()),
                              mainAxisExtent: 300,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return IngredientCard(
                                ingredient: widget.recipe.ingredients![index],
                                servings: servings,
                              );
                            },
                            itemCount: widget.recipe.ingredients!.length,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }
}
