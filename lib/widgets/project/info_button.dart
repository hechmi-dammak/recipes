import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/description_dialog.dart';

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
                height: 9,
                center: true,
                width: 2,
                color: Get.theme.colorScheme.onPrimary,
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
