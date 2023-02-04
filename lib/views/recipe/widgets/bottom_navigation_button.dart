import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavigationBarButton extends StatelessWidget {
  const BottomNavigationBarButton({
    super.key,
    required this.selected,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  final bool selected;
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: selected
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.secondary,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(icon,
                    semanticsLabel: title,
                    height: 20,
                    width: 20,
                    fit: BoxFit.scaleDown),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: Get.textTheme.labelSmall?.copyWith(
                      color: selected
                          ? Get.theme.colorScheme.onPrimary
                          : Get.theme.colorScheme.onSecondary),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
