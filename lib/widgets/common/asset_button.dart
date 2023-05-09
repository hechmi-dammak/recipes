import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/service/asset_service.dart';
import 'package:recipes/widgets/common/conditional_parent_widget.dart';

class AssetButton extends StatelessWidget {
  const AssetButton(
      {super.key,
      this.onTap,
      required this.icon,
      this.center = false,
      this.iconWidth = 20,
      this.iconHeight = 20,
      this.iconColor,
      this.parentBuilder,
      this.scaleDown = true,
      this.flip = false});

  final VoidCallback? onTap;
  final String icon;
  final bool center;
  final bool scaleDown;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final ParentChildBuilder? parentBuilder;
  final bool flip;

  AssetButton.back({Key? key, VoidCallback? onTap})
      : this(
            onTap: onTap ?? Get.back,
            icon: 'back_arrow_icon',
            center: true,
            key: key);

  const AssetButton.selectAll(
      {Key? key, required VoidCallback onTap, required bool allItemsSelected})
      : this(
            onTap: onTap,
            center: true,
            icon: allItemsSelected ? 'select_all_icon' : 'deselect_all_icon',
            key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConditionalParentWidget(
        condition: parentBuilder != null,
        parentBuilder: (context, child) =>
            parentBuilder?.call(context, child) ?? Container(),
        child: ConditionalParentWidget(
          condition: center,
          parentBuilder: (context, child) => Center(
            child: child,
          ),
          child: ConditionalParentWidget(
            condition: flip,
            parentBuilder: (context, child) => Transform.rotate(
              angle: math.pi,
              child: child,
            ),
            child: Image(
                image: AssetService.assets[icon]!,
                height: iconHeight,
                width: iconWidth,
                colorBlendMode: BlendMode.srcIn,
                color: iconColor,
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
