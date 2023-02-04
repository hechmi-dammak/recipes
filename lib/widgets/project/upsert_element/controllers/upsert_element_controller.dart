import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/controller_decorator.dart';

abstract class UpsertElementController extends ControllerDecorator {
  UpsertElementController({super.controller, super.child});

  static UpsertElementController get find =>
      Get.find<UpsertElementController>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> confirm(void Function([bool? result, bool forceClose]) close);
}
