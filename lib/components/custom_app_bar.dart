import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? searchWidget;
  final Widget? leading;
  final double height;

  const CustomAppBar(
      {super.key, this.title, this.actions, this.searchWidget, this.leading})
      : height = 130 + (searchWidget != null ? 20 : 0);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: const [
                0.1,
                0.6,
              ],
              colors: [
                Get.theme.primaryColorDark,
                Get.theme.colorScheme.primary,
              ],
            ),
          ),
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: height,
            width: double.infinity,
            child: Column(children: [
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: (searchWidget != null ? 10 : 15),
                      bottom: 7,
                    ),
                    child: Stack(
                      children: [
                        if (leading != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: leading,
                          ),
                        Align(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: Text(
                              title ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                        if (actions != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: actions!),
                          ),
                      ],
                    ),
                  )),
              if (searchWidget != null)
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [Expanded(child: searchWidget!)],
                    ),
                  ),
                )
            ]))
      ],
    );
  }
}
