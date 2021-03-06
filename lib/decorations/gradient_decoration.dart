import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientDecoration extends BoxDecoration {
  GradientDecoration()
      : super(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.9,
            ],
            colors: [
              const Color(0xFF358c7a),
              Get.theme.colorScheme.primaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        );

  GradientDecoration.secondary([bool selected = false])
      : super(
          borderRadius: BorderRadius.circular(10),
          color: Get.theme.buttonTheme.colorScheme!.primary,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.9,
            ],
            colors: (selected)
                ? [
                    Get.theme.colorScheme.secondaryContainer,
                    Get.theme.colorScheme.secondary
                  ]
                : [
                    Get.theme.colorScheme.primary,
                    Get.theme.colorScheme.primaryContainer
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.5,
              blurRadius: 1.5,
              offset: const Offset(1, 1),
            ),
          ],
        );

  GradientDecoration.rounded([bool selected = false])
      : super(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.9,
            ],
            colors: (selected)
                ? [
                    Get.theme.colorScheme.secondaryContainer,
                    Get.theme.colorScheme.secondary
                  ]
                : [
                    Get.theme.colorScheme.primary,
                    Get.theme.colorScheme.primaryContainer
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        );
}
