import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/conditional_parent_widget.dart';

class SvgButton extends StatelessWidget {
  const SvgButton(
      {super.key,
      required this.onTap,
      required this.icon,
      this.center = false,
      this.iconWidth = 20,
      this.iconHeight = 20,
      this.iconColor,
      this.parentBuilder});

  final VoidCallback onTap;
  final String icon;
  final bool center;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final ParentChildBuilder? parentBuilder;

  factory SvgButton.backButton({VoidCallback? onTap}) {
    return SvgButton(
        onTap: onTap ?? Get.back, icon: 'assets/icons/back_arrow_icon.svg');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConditionalParentWidget(
        condition: parentBuilder != null,
        parentBuilder: (child) => parentBuilder?.call(child) ?? Container(),
        child: ConditionalParentWidget(
          condition: center,
          parentBuilder: (Widget child) => Center(
            child: child,
          ),
          child: SvgPicture.asset(
            icon,
            height: iconHeight,
            width: iconWidth,
            fit: BoxFit.scaleDown,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          ),
        ),
      ),
    );
  }
}
