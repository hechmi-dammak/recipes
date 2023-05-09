import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/service/asset_service.dart';
import 'package:recipes/widgets/common/conditional_parent_widget.dart';

class ServingsIcon extends StatelessWidget {
  const ServingsIcon({
    super.key,
    required this.servings,
    required this.color, this.onTap,
  });

  final Color color;
  final int servings;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: onTap != null,
      parentBuilder: (context, child) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
      child: Stack(
        children: [
          Align(
            child: Image(
                image: AssetService.assets['portions_icon']!,
                height: 20,
                width: 20,
                colorBlendMode: BlendMode.srcIn,
                color: color,
                fit: BoxFit.contain),
          ),
          Align(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20),
              child: Text(
                servings.toString(),
                style: Get.textTheme.labelSmall?.copyWith(color: color),
              ),
            ),
          )
        ],
      ),
    );
  }
}
