import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/utils/app_bar.dart';
import 'package:recipes/components/decorations/input_decoration.dart';
import 'package:recipes/components/utils/serving_spin_box.dart';
import 'package:recipes/components/utils/show_snack_bar.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeCreatePage extends StatefulWidget {
  const RecipeCreatePage({Key? key}) : super(key: key);

  @override
  _RecipeCreatePageState createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  late final Recipe _recipe;
  bool loading = false;
  late final List<String> _recipeCategories;
  final _categoryController = TextEditingController();
  RecipeOperations recipeOperations = RecipeOperations.instance;
  int servings = 4;
  final _recipeFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    loading = true;
    _recipe = Recipe();
    initData();
    super.initState();
  }

  void initData() async {
    _recipeCategories = await recipeOperations.getAllCategories();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: customAppBar(context, title: "Create a new recipe"),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: ServingSpinBox(
                              changeServingFunction: (double value) {
                                setState(() {
                                  servings = value.toInt();
                                });
                              },
                              servings: servings)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Form(
                          key: _recipeFormKey,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: TextFormField(
                                  decoration:
                                      getInputDecoration(context, "Name"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please specify a name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: buildCategory(context),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildCategory(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: Container(
            decoration: gradientDecoation(context),
            child: DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).colorScheme.secondary,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 18),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                  labelText: 'Category'),
              iconSize: 40,
              value: _recipe.category,
              onChanged: (String? newValue) {
                setState(() {
                  _recipe.category = newValue!;
                });
              },
              items: _recipeCategories
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    child: Text(value), value: value);
              }).toList(),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: TextButton(
              onPressed: () {
                addNewRecipeCategory(context);
              },
              child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: gradientDecoation(context),
                  child: const Icon(Icons.add))),
        )
      ],
    );
  }

  BoxDecoration gradientDecoation(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).buttonTheme.colorScheme!.primary,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.1,
          0.9,
        ],
        colors: [
          Theme.of(context).colorScheme.secondaryVariant,
          Theme.of(context).colorScheme.secondary
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.25),
          spreadRadius: 2,
          blurRadius: 2,
          offset: const Offset(1, 1), // changes position of shadow
        ),
      ],
    );
  }

  addNewRecipeCategory(BuildContext context) {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: const Text(
          'Create a new category',
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Get.back();
                  _categoryController.clear();
                },
              ),
              TextButton(
                child: const Text('confirm'),
                onPressed: () async {
                  if (_categoryController.text == "") {
                    showInSnackBar("Category shouldn't be empty", context);
                    return;
                  }
                  _recipeCategories.add(_categoryController.text);
                  setState(() {
                    _recipe.category = _categoryController.text;
                  });
                  Get.back();

                  _categoryController.clear();
                },
              ),
            ],
          )
        ],
        content: TextField(
          controller: _categoryController,
          decoration: getInputDecoration(context, 'Category'),
        ),
      ),
    ));
  }
}
