import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decoration/input_decoration.dart';
import 'package:recipes/components/recipe_create_page.dart/category_drop_down.dart';
import 'package:recipes/components/recipe_create_page.dart/floating_action_button.dart';
import 'package:recipes/components/utils/app_bar.dart';
import 'package:recipes/components/utils/loading_widget.dart';
import 'package:recipes/components/utils/serving_spin_box.dart';
import 'package:recipes/controller/recipe_create_controller.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeCreatePage extends StatefulWidget {
  const RecipeCreatePage({Key? key}) : super(key: key);

  @override
  _RecipeCreatePageState createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  final RecipeCreateController recipeCreateController =
      RecipeCreateController.find;

  RecipeOperations recipeOperations = RecipeOperations.instance;

  final _recipeFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    recipeCreateController.initRecipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const RecipeCreateFloatingButton(),
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: customAppBar(context, title: "Create a new recipe"),
        body: GetBuilder<RecipeCreateController>(
          builder: (recipeCreateController) {
            return LoadingWidget(
              loading: recipeCreateController.loading.value,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: ServingSpinBox(
                              changeServingFunction: (double value) {
                                setState(() {
                                  recipeCreateController
                                      .setServingValue(value.toInt());
                                });
                              },
                              servings: recipeCreateController.servings.value)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Form(
                          key: _recipeFormKey,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: TextFormField(
                                  decoration: getInputDecoration("Name"),
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
                                child: CategoryDropDownInput(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
