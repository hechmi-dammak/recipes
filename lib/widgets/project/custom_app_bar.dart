import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leading,
      required this.title,
      this.action,
      this.fadeLeading,
      this.secondLeading,
      this.secondTitle,
      this.secondAction,
      this.fadeTitle,
      this.fadeAction})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final Widget? leading;
  final Widget? secondLeading;
  final Widget title;
  final Widget? secondTitle;

  final Widget? action;
  final Widget? secondAction;

  final bool? fadeLeading;
  final bool? fadeTitle;
  final bool? fadeAction;
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
              leading: SizedBox(
                width: kToolbarHeight,
                height: kToolbarHeight,
                child: getElement(fadeLeading, leading, secondLeading),
              ),
              middle: getElement(fadeTitle, title, secondTitle),
              trailing: SizedBox(
                width: kToolbarHeight,
                height: kToolbarHeight,
                child: getElement(fadeAction, action, secondAction),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? getElement(bool? fade, Widget? first, Widget? second) {
    if (fade != null) {
      return AnimatedCrossFade(
        firstChild: first ?? Container(),
        secondChild: second ?? Container(),
        crossFadeState:
            fade ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
      );
    }
    return first;
  }
}
