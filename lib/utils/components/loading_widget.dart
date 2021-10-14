import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final bool loading;
  const LoadingWidget({Key? key, required this.child, required this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : child;
  }
}
