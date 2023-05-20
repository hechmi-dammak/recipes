import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/conditional_parent_widget.dart';
import 'package:mekla/widgets/project/add_element_card.dart';

class GridCards extends StatelessWidget {
  const GridCards({
    super.key,
    required this.children,
    required this.addElement,
    required this.hideAddElement,
    this.multiple = false,
    this.paddingVertical = 20,
    this.paddingHorizontal = 20,
    this.crossAxisWidth = 300,
    this.childAspectRatio = 1,
    this.useAnimation = true,
  });

  final List<Widget> children;
  final VoidCallback addElement;
  final bool hideAddElement;
  final bool multiple;
  final double paddingVertical;
  final double paddingHorizontal;
  final double crossAxisWidth;
  final double childAspectRatio;
  final bool useAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return ConditionalParentWidget(
        condition: useAnimation,
        parentBuilder: (BuildContext context, Widget child) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: child,
          );
        },
        child: GridView(
          shrinkWrap: multiple,
          physics: multiple ? const NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: childAspectRatio,
              crossAxisCount: (Get.width / crossAxisWidth).ceil(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          children: [
            ...children,
            if (!hideAddElement)
              AddElementCard(
                onTap: addElement,
              ),
          ],
        ),
      );
    });
  }
}
