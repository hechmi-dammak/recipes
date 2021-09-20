import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/components/recipe_card.dart';
import 'package:recipes/models/recipe.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _items = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await json.decode(response);
    _items = [];
    data.forEach((item) {
      _items.add(Recipe.fromJson(item));
    });
    setState(() {});
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

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
        title: const Text(
          'Recipes List',
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: _items.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3,
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / 500).ceil(),
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      recipe: _items[index],
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
