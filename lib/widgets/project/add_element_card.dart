import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/widgets/common/asset_button.dart';

class AddElementCard extends StatelessWidget {
  const AddElementCard({Key? key, required this.onTap, this.height})
      : super(key: key);
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AssetButton(
      onTap: onTap,
      icon: 'big_plus_icon',
      center: true,
      height: 30,
      width: 30,
      color: Get.theme.colorScheme.onTertiaryContainer,
      parentBuilder: (context, child) => Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            color: Get.theme.colorScheme.tertiaryContainer),
        child: child,
      ),
    );
  }
}
