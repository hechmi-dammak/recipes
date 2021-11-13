import 'package:flutter/material.dart';

PreferredSize customAppBar(BuildContext context,
    {String? title,
    List<Widget>? actions,
    Widget? searchWidget,
    Widget? leading}) {
  final double height = 130 + (searchWidget != null ? 20 : 0);
  return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Stack(
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
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).colorScheme.primary,
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
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                title ?? "",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                                  children: actions),
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
                        children: [Expanded(child: searchWidget)],
                      ),
                    ),
                  )
              ]))
        ],
      ));
}
