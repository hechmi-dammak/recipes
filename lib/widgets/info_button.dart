import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/asset_button.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/project/description_dialog.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({
    super.key,
    required this.name,
    this.description,
    this.isRight = false,
  });

  final bool isRight;
  final String name;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return ConditionalWidget(
        child: (context) => Positioned(
              top: 0,
              left: isRight ? null : 0,
              right: isRight ? 0 : null,
              child: AssetButton(
                onTap: DescriptionDialog(title: name, description: description!)
                    .show,
                icon: 'info_icon',
                iconHeight: 9,
                iconWidth: 2,
                iconColor: Get.theme.colorScheme.onPrimary,
                parentBuilder: (context, child) => SizedBox(
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
