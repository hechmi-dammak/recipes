import 'package:flutter/material.dart';

class EmptyRecipeList extends StatelessWidget {
  const EmptyRecipeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 6,
                  left: 10,
                  right: 10),
              child: const Center(
                  child: Text(
                "No recipes exists yet.\nPress import to load new recipes or you can  create your own.",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              )),
            ),
          ],
        )
      ],
    );
  }
}
