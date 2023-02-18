import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ServingsButton extends StatelessWidget {
  const ServingsButton({
    super.key,
    required this.servings,
    required this.onTap,
  });

  final VoidCallback onTap;
  final int servings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Align(
            child: SvgPicture.asset(
              'assets/icons/portions_icon.svg',
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                  Get.theme.colorScheme.onPrimary, BlendMode.srcIn),
            ),
          ),
          Align(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20),
              child: Text(
                servings.toString(),
                style: Get.textTheme.labelSmall
                    ?.copyWith(color: Get.theme.colorScheme.onPrimary),
              ),
            ),
          )
        ],
      ),
    );
  }
}
