import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';

abstract class ControllerDecorator extends Controller {
  final Controller controller;

  static ControllerDecorator get find => Get.find<ControllerDecorator>();

  ControllerDecorator({required this.controller, super.child});

  @override
  bool getLoading({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.getLoading();
    }
    return controller.getLoading(callChild: false);
  }

  @override
  void setLoading(bool loading, {bool callChild = true}) {
    if (child != null && callChild) {
      child!.setLoading(loading);
      return;
    }
    controller.setLoading(loading, callChild: false);
  }

  @override
  void decoratorUpdate({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.decoratorUpdate();
    }
    update();
  }

  @override
  Future<void> fetchData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.fetchData();
      return;
    }
    await controller.fetchData(callChild: false);
  }

  @override
  void initState(GetBuilderState<Controller> state, {bool callChild = true}) {
    if (child != null && callChild) {
      child!.initState(state);
      return;
    }
    controller.initState(state, callChild: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
    }
    await controller.loadData(callChild: false);
  }
}
