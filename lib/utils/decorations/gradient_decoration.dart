import 'package:flutter/material.dart';

BoxDecoration gradientDecoation(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    // color: Theme.of(context).buttonTheme.colorScheme!.primary,
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: const [
        0.1,
        0.9,
      ],
      colors: [
        Color(0xFF358c7a),
        Theme.of(context).colorScheme.primaryVariant,
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
}

BoxDecoration gradientDecoationSecondery(BuildContext context,
    {bool? selected}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Theme.of(context).buttonTheme.colorScheme!.primary,
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: const [
        0.1,
        0.9,
      ],
      colors: (selected ?? false)
          ? [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryVariant
            ]
          : [
              Theme.of(context).colorScheme.secondaryVariant,
              Theme.of(context).colorScheme.secondary
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

BoxDecoration gradientDecoationRounded(BuildContext context) {
  return BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: const [
        0.1,
        0.9,
      ],
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primaryVariant,
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
}
