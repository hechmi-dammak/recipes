import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/services/asset_service.dart';

class TitleAppBarButton extends StatelessWidget {
  const TitleAppBarButton({
    Key? key,
    required this.title,
    this.hideTitle = false,
    required this.icon,
    required this.onTap,
    this.isStart = false,
  }) : super(key: key);
  final String title;
  final String icon;
  final bool hideTitle;
  final VoidCallback onTap;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isStart ? null : const EdgeInsets.only(left: 25),
      child: Tooltip(
        showDuration: const Duration(milliseconds: 300),
        message: title,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: LayoutBuilder(builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                    image: AssetService.assets[icon]!,
                    height: 20,
                    width: 20,
                    semanticLabel: title,
                    fit: BoxFit.contain),
                if (Get.width > 340 && !hideTitle) ...[
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    title,
                    style: Get.textTheme.labelSmall?.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                        overflow: TextOverflow.clip),
                  )
                ]
              ],
            );
          }),
        ),
      ),
    );
  }
}
