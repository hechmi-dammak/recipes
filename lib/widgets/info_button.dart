import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/widgets/description_dialog.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/common/svg_button.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({
    super.key,
    required this.name,
    this.description,
  });

  final String name;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        child: (context) => Positioned(
              top: 0,
              left: 0,
              child: SvgButton(
                onTap: DescriptionDialog(title: name, description: description!)
                    .show,
                icon: 'assets/icons/info_icon.svg',
                iconHeight: 9,
                iconWidth: 2,
                iconColor: Get.theme.colorScheme.onPrimary,
                parentBuilder: (child) => SizedBox(
                  height: 34,
                  width: 32,
                  child: Center(
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Get.theme.colorScheme.primary),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
        condition: description != null);
  }
}
