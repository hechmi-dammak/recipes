import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/asset_button.dart';

class AddElementCard extends StatelessWidget {
  const AddElementCard(
      {Key? key,
      required this.onTap,
      required this.semanticsLabel,
      this.height})
      : super(key: key);
  final VoidCallback onTap;
  final String semanticsLabel;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AssetButton(
      onTap: onTap,
      icon: 'big_plus_icon',
      center: true,
      iconHeight: 30,
      iconWidth: 30,
      iconColor: Get.theme.colorScheme.onTertiaryContainer,
      parentBuilder: (context, child) => Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.5),
            color: Get.theme.colorScheme.tertiaryContainer),
        child: child,
      ),
    );
  }
}
