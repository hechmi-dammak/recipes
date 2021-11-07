import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:content_resolver/content_resolver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/page/recipe_edit_page.dart';
import 'package:recipes/modules/recipe_list_page/components/empty_recipe_list.dart';
import 'package:recipes/modules/recipe_list_page/components/recipe_card.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/utils/components/app_bar.dart';
import 'package:recipes/utils/components/app_bar_bottom.dart';
import 'package:recipes/utils/components/loading_widget.dart';
import 'package:recipes/utils/components/show_dialog.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';
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
  final recipesScrollController = ScrollController();
  late AppLinks _appLinks;
  bool loading = true;
  final searchFocusNode = FocusNode();
  Future<void> initRecipes() async {
    await recipesController.loadRecipes();
  }

  @override
  void initState() {
    initRecipes();
    initDeepLinks();
    super.initState();
  }

  void initDeepLinks() async {
    _appLinks = AppLinks(
      onAppLink: (Uri uri, String stringUri) {
        openAppLink(uri);
      },
    );

    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null && appLink.hasFragment && appLink.fragment != '/') {
      openAppLink(appLink);
    }
  }

  void openAppLink(Uri uri) async {
    try {
      final uriStr = uri.toString().replaceFirst(
          'content://com.slack.fileprovider/',
          'content://com.Slack.fileprovider/');
      var content = "";
      try {
        var contentEncoded = await ContentResolver.resolveContent(uriStr);
        content = String.fromCharCodes(contentEncoded);
      } catch (e) {
        try {
          content = await File(uri.path).readAsString();
        } catch (e) {
          content = await File(uri.path.split("external").last).readAsString();
        }
      }

      await recipesController.saveRecipesFromFile(content);
    } catch (e) {
      showInSnackBar("Failed to open to file " + e.toString());
    }
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
            bottomNavigationBar: BottomBar(),
            appBar: appBar(context),
            floatingActionButton: recipesController.selectionIsActive.value
                ? null
                : FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.note_add_rounded, size: 30),
                    onPressed: () async {
                      var result = await Get.to(() => const RecipeEditPage());
                      if (result != null && result) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (recipesScrollController.hasClients) {
                            recipesScrollController.animateTo(
                              recipesScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceInOut,
                            );
                          }
                        });
                      }
                    },
                  ),
            body: AppbarBottom(
              child: RefreshIndicator(
                  onRefresh: initRecipes,
                  child: LoadingWidget(
                    loading: recipesController.loading.value,
                    child: recipesController.recipes.isNotEmpty
                        ? GridView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            controller: recipesScrollController,
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
          ),
        ),
      );
    });
  }

  void selectedItemMenu(BuildContext context, item) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ))
          else
            TextButton(
              onPressed: () => recipesController.setSelectAllValue(true),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.radio_button_unchecked_rounded,
                      size: 30, color: Theme.of(context).colorScheme.onPrimary),
                  Text(
                    "All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
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
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onSelected: (item) => selectedItemMenu(context, item),
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
        autofocus: false,
        focusNode: searchFocusNode,
        textAlignVertical: TextAlignVertical.bottom,
        // style: const TextStyle(fontSize: 20),
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
                searchFocusNode.unfocus();
                _searchController.clear();
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
  BottomBar({
    Key? key,
  }) : super(key: key);

  final RecipesController recipesController = RecipesController.find;

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
              onPressed: () {
                showConfirmationDialog(
                    title: "These recipes will be deleted.",
                    confirm: recipesController.deleteSelectedRecipes);
              },
              child: Column(
                children: [
                  Icon(Icons.delete_forever_rounded,
                      size: 30, color: Theme.of(context).colorScheme.onPrimary),
                  Text(
                    "Delete",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: recipesController.exportToFile,
              child: Column(
                children: [
                  ImageIcon(const AssetImage('assets/images/export_file.png'),
                      size: 30, color: Theme.of(context).colorScheme.onPrimary),
                  Text(
                    "Export",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: recipesController.shareAsFile,
              child: Column(
                children: [
                  Icon(Icons.share,
                      size: 30, color: Theme.of(context).colorScheme.onPrimary),
                  Text(
                    "Share",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
                ],
              ),
            ),
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
