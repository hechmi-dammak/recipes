import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';

class FadedScroll extends StatelessWidget {
  const FadedScroll({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.cardBorderRadius),
        ),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: child,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 1],
                    colors: [
                      Get.theme.colorScheme.primaryContainer,
                      Get.theme.colorScheme.primaryContainer.withOpacity(0)
                    ],
                  ),
                ),
                width: double.infinity,
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.4, 1],
                      colors: [
                        Get.theme.colorScheme.primaryContainer,
                        Get.theme.colorScheme.primaryContainer.withOpacity(0)
                      ],
                    ),
                  ),
                  width: double.infinity,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
