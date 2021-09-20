import 'package:flutter/material.dart';
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
    return Container(
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
            colors: [
              !widget.ingredient.selected
                  ? Theme.of(context).colorScheme.secondaryVariant
                  : Theme.of(context).colorScheme.primary,
              !widget.ingredient.selected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primaryVariant,
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
        child: TextButton(
          onPressed: () {
            setState(() {
              widget.ingredient.selected = !widget.ingredient.selected;
            });
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.ingredient.name,
                  style: TextStyle(
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                )
              else
                Container(),
              if (widget.ingredient.method != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.ingredient.method!,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),
                  ),
                )
              else
                Container()
            ],
          ),
        ));
  }
}
