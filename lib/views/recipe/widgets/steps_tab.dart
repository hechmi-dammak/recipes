import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/project/add_element_card.dart';

class StepsTab extends StatelessWidget {
  const StepsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        AddElementCard(
          onTap: () {},
          semanticsLabel: 'Add Step'.tr,
          height: Get.height * 0.2,
        ),
      ],
    );
  }
}
