import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddRecipeCategoryCard extends StatelessWidget {
  const AddRecipeCategoryCard(
      {Key? key, required this.onTap, required this.semanticsLabel})
      : super(key: key);
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),
              color: Get.theme.colorScheme.tertiaryContainer),
          child: Center(
            child: SvgPicture.asset('assets/icons/big_plus_icon.svg',
                color: Get.theme.colorScheme.onTertiaryContainer,
                semanticsLabel: semanticsLabel,
                height: 30,
                width: 30,
                fit: BoxFit.scaleDown),
          )),
    );
  }
}
