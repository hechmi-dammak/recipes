import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/project/add_element_card.dart';

class GridCards extends StatelessWidget {
  const GridCards({
    super.key,
    required this.children,
    required this.addElement,
    required this.hideAddElement,
    this.multiple = false,
  });

  final List<Widget> children;
  final VoidCallback addElement;
  final bool hideAddElement;
  final bool multiple;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return GridView(
        shrinkWrap: multiple,
        physics: multiple ? const NeverScrollableScrollPhysics() : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (Get.width / 300).ceil(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        children: [
          ...children,
          AnimatedOpacity(
            opacity: hideAddElement ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            child: AddElementCard(
              onTap: addElement,
            ),
          ),
        ],
      );
    });
  }
}
