import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

NewGradientAppBar customAppBar(BuildContext context,
    {String? title,
    List<Widget>? actions,
    Widget? titleWidget,
    Widget? leading}) {
  return NewGradientAppBar(
    bottom: titleWidget != null
        ? NewGradientAppBar(
            title: titleWidget,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.6,
              ],
              colors: [
                Theme.of(context).primaryColorDark,
                Theme.of(context).colorScheme.primary,
              ],
            ),
          )
        : null,
    leading: leading,
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: const [
        0.1,
        0.6,
      ],
      colors: [
        Theme.of(context).primaryColorDark,
        Theme.of(context).colorScheme.primary,
      ],
    ),
    actions: actions,
    centerTitle: true,
    title: Text(
      title ?? "",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
    ),
  );
}
