import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageView extends StatelessWidget {
  final Uint8List image;

  const ImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Get.theme.colorScheme.primary, width: 4),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
        image: DecorationImage(
          image: MemoryImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      width: double.infinity,
      height: (MediaQuery.of(context).size.width - 40) * 0.7,
    );
  }
}
