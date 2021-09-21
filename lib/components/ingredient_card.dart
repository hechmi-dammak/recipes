import 'package:flutter/material.dart';
import 'package:recipes/components/modal_paint.dart';
import 'package:recipes/models/ingredient.dart';
import 'dart:math';

class IngredientCard extends StatefulWidget {
  final Ingredient ingredient;
  final int servings;
  const IngredientCard(
      {Key? key, required this.ingredient, required this.servings})
      : super(key: key);

  @override
  State<IngredientCard> createState() => IngredientCardState();
}

class IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _onLongPress(context),
      onTap: () {
        setState(() {
          widget.ingredient.selected = !(widget.ingredient.selected ?? true);
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).buttonTheme.colorScheme!.primary,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.9,
            ],
            colors: (widget.ingredient.selected ?? false)
                ? [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryVariant
                  ]
                : [
                    Theme.of(context).colorScheme.secondaryVariant,
                    Theme.of(context).colorScheme.secondary
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        width: min(MediaQuery.of(context).size.width * 3 / 5, 300),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.ingredient.name,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                ),
              ),
              if (widget.ingredient.getQuantity(widget.servings) != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.ingredient.getQuantity(widget.servings)!,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                ),
              if (widget.ingredient.method != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.ingredient.method!,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                )
            ],
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
                        "Name",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary),
                      ),
                      title: Text(
                        widget.ingredient.name,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary),
                      ),
                    ),
                  ),
                  if (widget.ingredient.getQuantity(widget.servings) != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "Quantity",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onPrimary),
                        ),
                        title: Text(
                          widget.ingredient.getQuantity(widget.servings)!,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onPrimary),
                        ),
                      ),
                    ),
                  if (widget.ingredient.method != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: Text(
                          "method",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onPrimary),
                        ),
                        title: Text(
                          widget.ingredient.method!,
                          style: TextStyle(
                              // overflow: TextOverflow.ellipsis,
                              fontSize: 15,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onPrimary),
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
