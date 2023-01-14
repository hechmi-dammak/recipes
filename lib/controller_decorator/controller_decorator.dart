import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';

abstract class ControllerDecorator extends Controller {
  final Controller controller;

  static ControllerDecorator get find => Get.find<ControllerDecorator>();

  ControllerDecorator({required this.controller, super.child});

  @override
  bool getLoading({callChild = true}) {
    if (child != null && callChild) {
      return child!.getLoading();
    }
    return controller.getLoading(callChild: false);
  }

  @override
  void setLoading(bool loading, {callChild = true}) {
    if (child != null && callChild) {
      child!.setLoading(loading);
      return;
    }
    controller.setLoading(loading, callChild: false);
  }

  @override
  Future<void> fetchData({callChild = true}) async {
    if (child != null && callChild) {
      await child!.fetchData();
      return;
    }
    controller.fetchData(callChild: false);
  }

  @override
  void initState(GetBuilderState<Controller> state, {callChild = true}) {
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
  Future<void> loadData({callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
    }
    await controller.loadData(callChild: false);
  }
}
