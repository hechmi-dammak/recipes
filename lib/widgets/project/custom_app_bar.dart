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
      this.secondTitleChildren,
      this.secondAction,
      this.fadeTitle,
      this.fadeAction})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final Widget? leading;
  final Widget? secondLeading;
  final Widget title;
  final Widget? secondTitle;
  final List<Widget>? secondTitleChildren;

  final Widget? action;
  final Widget? secondAction;

  final bool? fadeLeading;
  final bool? fadeTitle;
  final bool? fadeAction;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final actionResult = getElement(fadeAction, action, secondAction);
    final titleResult = getElement(
        fadeTitle,
        title,
        secondTitle ??
            (secondTitleChildren != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: secondTitleChildren!,
                    ),
                  )
                : null));
    final leadingResult = getElement(fadeLeading, leading, secondLeading);
    return Material(
      color: Get.theme.primaryColor,
      child: Semantics(
        explicitChildNodes: true,
        child: SafeArea(
          bottom: false,
          child: ClipRect(
            child: NavigationToolbar(
              leading: leadingResult == null
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              minWidth: kToolbarHeight,
                              minHeight: kToolbarHeight),
                          child: Center(child: leadingResult),
                        ),
                      ],
                    ),
              middle: titleResult,
              trailing: actionResult == null
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              minWidth: kToolbarHeight,
                              minHeight: kToolbarHeight),
                          child: Center(child: actionResult),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? getElement(bool? fade, Widget? first, Widget? second) {
    if (fade != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: fade ? first : second ?? Container(),
      );
    }
    return first;
  }
}
