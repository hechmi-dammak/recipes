import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/page/recipe_edit_page.dart';
import 'package:recipes/modules/recipe_list_page/components/empty_recipe_list.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_card.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/app_bar_bottom.dart';
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
          if (recipesController.selectionIsActive.value) {
            setState(() {
              recipesController.setSelectAllValue(false);
            });
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: appBar(context),
            floatingActionButton: recipesController.selectionIsActive.value
                ? null
                : FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Icon(Icons.note_add_rounded, size: 30),
                    onPressed: () => Get.to(() => const RecipeEditPage()),
                  ),
            body: AppbarBottom(
              child: RefreshIndicator(
                  onRefresh: initRecipes,
                  child: LoadingWidget(
                    loading: recipesController.loading.value,
                    child: recipesController.recipes.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 15, bottom: 10),
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
            bottomNavigationBar:
                BottomBar(recipesController: recipesController),
          ),
        ),
      );
    });
  }

  void SelectedItemMenu(BuildContext context, item) {
    switch (item) {
      case 0:
        recipesController.importFromFile(context);
        break;
      case 1:
        recipesController.importFromLibrary();
        break;
    }
  }

  PreferredSize appBar(BuildContext context) {
    return customAppBar(
      context,
      actions: [
        if (recipesController.selectionIsActive.value) ...[
          if (recipesController.allItemsSelected.value)
            TextButton(
                onPressed: () => recipesController.setSelectAllValue(false),
                child: Column(
                  children: [
                    Icon(Icons.radio_button_unchecked_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                    Text(
                      "All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                ))
          else
            TextButton(
                onPressed: () => recipesController.setSelectAllValue(true),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline_outlined,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                    Text(
                      "All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                )),
        ]
      ],
      leading: PopupMenuButton<int>(
        child: Icon(
          Icons.menu,
          size: 35,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onSelected: (item) => SelectedItemMenu(context, item),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: const [
                  Icon(Icons.upload_file_rounded, size: 20),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Import From File"),
                ],
              ),
            ),
            if (recipesController.recipes.isEmpty)
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.download, size: 20),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Import from library'),
                  ],
                ),
              )
          ];
        },
      ),
      title: 'Recipes List',
      searchWidget: TextFormField(
        textAlignVertical: TextAlignVertical.bottom,
        style: const TextStyle(fontSize: 20),
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
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.recipesController,
  }) : super(key: key);

  final RecipesController recipesController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: recipesController.deleteSelectedRecipes,
                child: Column(
                  children: [
                    Icon(Icons.delete_forever_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                    Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                )),
            TextButton(
                onPressed: recipesController.exportToFile,
                child: Column(
                  children: [
                    ImageIcon(const AssetImage('assets/images/export_file.png'),
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary),
                    Text(
                      "Export",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                ))
          ],
        ),
      ),
      height: recipesController.selectionIsActive.value ? 75 : 0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: const [
            0.1,
            0.6,
          ],
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
    );
  }
}
