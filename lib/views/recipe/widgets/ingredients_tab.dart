import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/project/add_element_card.dart';

class IngredientsTab extends StatelessWidget {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (Get.width / 300).ceil(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      children: [
        AddElementCard(onTap: () {}, semanticsLabel: 'Add Ingredient'.tr),
      ],
    );
  }
}
