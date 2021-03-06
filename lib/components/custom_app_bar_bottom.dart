import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarBottom extends StatelessWidget {
  const CustomAppBarBottom({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: const Alignment(0, -1.001),
        child: Container(
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
          height: 20,
          width: double.infinity,
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: 21,
        ),
      ),
      child
    ]);
  }
}
