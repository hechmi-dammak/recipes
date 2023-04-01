import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TitleAppBarButton extends StatelessWidget {
  const TitleAppBarButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon,
              semanticsLabel: title,
              height: 20,
              width: 20,
              fit: BoxFit.scaleDown),
          if (Get.width > 340) ...[
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: Get.textTheme.labelSmall
                  ?.copyWith(color: Get.theme.colorScheme.onPrimary),
            )
          ]
        ],
      ),
    );
  }
}
