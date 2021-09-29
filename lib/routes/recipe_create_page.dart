import 'package:flutter/material.dart';
import 'package:recipes/components/app_bar.dart';
import 'package:recipes/components/serving_spin_box.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/show_snack_bar.dart';

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
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Form(
                          key: _recipeFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(label: Text('Name')),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please specify a name';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  DropdownButtonFormField(
                                    value: _recipe.category,
                                    items: _recipeCategories
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          child: Text(value), value: value);
                                    }).toList(),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            useRootNavigator: false,
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              // holding this dialog context
                                              return Scaffold(
                                                backgroundColor:
                                                    Colors.transparent,
                                                body: AlertDialog(
                                                  title: const Text(
                                                    'Create a new category',
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          child: const Text(
                                                              'cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');
                                                            _categoryController
                                                                .clear();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'confirm'),
                                                          onPressed: () async {
                                                            if (_categoryController
                                                                    .text ==
                                                                "") {
                                                              showInSnackBar(
                                                                  "Category shouldn't be empty",
                                                                  dialogContext);
                                                              return;
                                                            }
                                                            _recipeCategories.add(
                                                                _categoryController
                                                                    .text);

                                                            _categoryController
                                                                .clear();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  content: TextField(
                                                    controller:
                                                        _categoryController,
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Category'),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(Icons.add))
                                ],
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
}
