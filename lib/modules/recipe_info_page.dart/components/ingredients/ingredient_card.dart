import 'package:flutter/material.dart';

import 'package:recipes/models/ingredient.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:recipes/utils/decorations/gradient_decoration.dart';
import 'package:recipes/utils/decorations/modal_paint.dart';

class IngredientCard extends StatefulWidget {
  final Ingredient ingredient;
  final int servings;
  final int? recipeServings;
  const IngredientCard(
      {Key? key,
      required this.ingredient,
      required this.servings,
      this.recipeServings})
      : super(key: key);

  @override
  State<IngredientCard> createState() => IngredientCardState();
}

class IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: gradientDecoationSecondery(context,
            selected: widget.ingredient.selected ?? false),
        child: InkWell(
          onLongPress: () => _onLongPress(context),
          onTap: () {
            setState(() {
              widget.ingredient.selected =
                  !(widget.ingredient.selected ?? true);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            width: min(MediaQuery.of(context).size.width * 3 / 5, 300),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.ingredient.name.capitalize!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.ingredient.selected ?? false
                              ? Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onPrimary
                              : Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSecondary),
                    ),
                  ),
                  if (widget.ingredient.getQuantity(
                          widget.servings, widget.recipeServings) !=
                      null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.ingredient
                            .getQuantity(
                                widget.servings, widget.recipeServings)!
                            .capitalize!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.ingredient.selected ?? false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                    ),
                  if (widget.ingredient.method != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.ingredient.method!.capitalize!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: widget.ingredient.selected ?? false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onLongPress(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: widget.ingredient.selected ?? false
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: CustomPaint(
              painter: ModalPainter(
                widget.ingredient.selected ?? false
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Text(
                        "Name:",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.ingredient.selected ?? false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                      title: Text(
                        widget.ingredient.name.capitalize!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.ingredient.selected ?? false
                                ? Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary
                                : Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .onSecondary),
                      ),
                    ),
                  ),
                  if (widget.ingredient.category != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "Category:",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                        title: Text(
                          widget.ingredient.category!.capitalize!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                      ),
                    ),
                  if (widget.ingredient.getQuantity(
                          widget.servings, widget.recipeServings) !=
                      null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "Quantity:",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                        title: Text(
                          widget.ingredient
                              .getQuantity(
                                  widget.servings, widget.recipeServings)!
                              .capitalize!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                      ),
                    ),
                  if (widget.ingredient.method != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "Method:",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                        title: Text(
                          widget.ingredient.method!.capitalize!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              color: widget.ingredient.selected ?? false
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onSecondary),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
