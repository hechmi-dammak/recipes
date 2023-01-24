import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      required this.leading,
      required this.title,
      required this.action})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final Widget leading;
  final Widget title;
  final Widget action;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.theme.primaryColor,
      child: Semantics(
        explicitChildNodes: true,
        child: SafeArea(
          bottom: false,
          child: ClipRect(
            child: NavigationToolbar(
              leading: leading,
              middle: title,
              trailing: action,
            ),
          ),
        ),
      ),
    );
  }
}
