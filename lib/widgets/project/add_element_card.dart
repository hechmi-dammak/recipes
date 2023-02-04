import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/svg_button.dart';

class AddElementCard extends StatelessWidget {
  const AddElementCard(
      {Key? key, required this.onTap, required this.semanticsLabel})
      : super(key: key);
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgButton(
      onTap: onTap,
      icon: 'assets/icons/big_plus_icon.svg',
      center: true,
      iconHeight: 30,
      iconWidth: 30,
      iconColor: Get.theme.colorScheme.onTertiaryContainer,
      parentBuilder: (child) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.5),
            color: Get.theme.colorScheme.tertiaryContainer),
        child: child,
      ),
    );
  }
}
