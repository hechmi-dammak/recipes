import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_app_bar.dart';
import 'package:recipes/components/custom_app_bar_bottom.dart';
import 'package:recipes/components/loading_widget.dart';
import 'package:recipes/decorations/custom_input_decoration.dart';
import 'package:recipes/modules/recipe_list_page/components/bottom_bar.dart';
import 'package:recipes/modules/recipe_list_page/components/empty_recipe_list.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_card.dart';
import 'package:recipes/modules/recipe_list_page/recipes_list_controller.dart';

class RecipeListPage extends StatelessWidget {
  static const routeName = '/recipes';

  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesListController>(builder: (recipesController) {
      return WillPopScope(
        onWillPop: () async {
          if (recipesController.selectionIsActive) {
            recipesController.setSelectAllValue();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: const BottomBar(),
            appBar: CustomAppBar(
              actions: [
                if (recipesController.selectionIsActive) ...[
                  if (recipesController.allItemsSelected)
                    TextButton(
                        onPressed: () => recipesController.setSelectAllValue(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline_outlined,
                                size: 30,
                                color: Get.theme.colorScheme.onPrimary),
                            Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.onPrimary),
                            )
                          ],
                        ))
                  else
                    TextButton(
                      onPressed: () =>
                          recipesController.setSelectAllValue(true),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.radio_button_unchecked_rounded,
                              size: 30, color: Get.theme.colorScheme.onPrimary),
                          Text(
                            'All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.onPrimary),
                          )
                        ],
                      ),
                    ),
                ]
              ],
              leading: PopupMenuButton<int>(
                offset: const Offset(0, 35),
                child: Icon(
                  Icons.menu,
                  size: 35,
                  color: Get.theme.colorScheme.onPrimary,
                ),
                onSelected: (item) => recipesController.selectedItemMenu(item),
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
                          Text('Import From File'),
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
                focusNode: recipesController.searchFocusNode,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: CustomInputDecoration.insideCardHint(
                  'Search',
                  suffix: GestureDetector(
                      onTap: recipesController.clearSearch,
                      child: Icon(
                        Icons.close_rounded,
                        size: 30,
                        color: Get.theme.colorScheme.onBackground,
                      )),
                ),
                controller: recipesController.searchController,
                onChanged: (value) => recipesController.searchValue = value,
              ),
            ),
            floatingActionButton: recipesController.selectionIsActive
                ? null
                : FloatingActionButton(
                    backgroundColor: Get.theme.colorScheme.primaryContainer,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
                    onPressed: recipesController.addRecipe,
                    child: const Icon(Icons.note_add_rounded, size: 30)),
            body: CustomAppBarBottom(
              child: RefreshIndicator(
                  onRefresh: recipesController.loadRecipes,
                  child: LoadingWidget(
                    loading: recipesController.loading,
                    child: recipesController.recipes.isNotEmpty
                        ? GridView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            controller:
                                recipesController.recipesScrollController,
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
                              return RecipeCard(
                                selectionIsActive:
                                    recipesController.selectionIsActive,
                                recipe: recipesController.recipes[index],
                                onLongPress:
                                    recipesController.setRecipeSelected,
                                onTap: recipesController.onRecipeTap,
                              );
                            },
                          )
                        : const EmptyRecipeList(),
                  )),
            ),
          ),
        ),
      );
    });
  }
}
