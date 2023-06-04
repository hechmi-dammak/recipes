import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/theme.dart';
import 'package:mekla/services/asset_service.dart';
import 'package:mekla/widgets/common/conditional_parent_widget.dart';

class AssetButton extends StatelessWidget {
  const AssetButton(
      {super.key,
      this.onTap,
      required this.icon,
      this.center = false,
      this.width = 20,
      this.height = 20,
      this.color,
      this.parentBuilder,
      this.conditionalParent = true,
      this.flip = false});

  final VoidCallback? onTap;
  final String icon;
  final bool center;
  final bool conditionalParent;
  final double width;
  final double height;
  final Color? color;
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

  AssetButton.toggleButton(
      {Key? key,
      required VoidCallback onTap,
      required String icon,
      required bool active})
      : this(
          key: key,
          center: true,
          icon: icon,
          parentBuilder: (context, child) => Container(
            width: kToolbarHeight - 14,
            height: kToolbarHeight - 14,
            decoration: active
                ? BoxDecoration(
                    color: ApplicationTheme.createPrimarySwatch(
                        Get.theme.primaryColor)[650],
                    borderRadius: const BorderRadius.all(Radius.circular(7)))
                : null,
            child: child,
          ),
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConditionalParentWidget(
        condition: parentBuilder != null && conditionalParent,
        parentBuilder: (context, child) => parentBuilder!.call(context, child),
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
                height: height,
                width: width,
                colorBlendMode: BlendMode.srcIn,
                color: color,
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
