import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

NewGradientAppBar customAppBar(BuildContext context,
    {String? title, List<Widget>? actions}) {
  return NewGradientAppBar(
    leading: Navigator.of(context).canPop()
        ? IconButton(
            onPressed: () async {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 25,
            ))
        : Container(),
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
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
    ),
  );
}
