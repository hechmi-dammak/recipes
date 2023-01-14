import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/custom_card.dart';

class AddRecipeCategoryCard extends StatelessWidget {
  const AddRecipeCategoryCard(
      {Key? key, required this.onTap, required this.semanticsLabel})
      : super(key: key);
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor:
      Get.theme.colorScheme.tertiaryContainer,
      onTap: onTap,
      child: Center(
        child: SvgPicture.asset('assets/icons/big_plus_icon.svg',
            color: Get.theme.colorScheme.onTertiaryContainer,
            semanticsLabel: semanticsLabel,
            height: 30,
            width: 30,
            fit: BoxFit.scaleDown),
      ),
    );
  }
}
