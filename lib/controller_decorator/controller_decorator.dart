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
  Future<void> fetchData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.fetchData();
      return;
    }
    await controller.fetchData(callChild: false);
  }

  @override
  void initState(GetBuilderState<Controller>? state, {bool callChild = true}) {
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

  @override
  bool getAllItemsSelected({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.getAllItemsSelected();
    }
    return controller.getAllItemsSelected(callChild: false);
  }

  @override
  bool getSelectionIsActive({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.getSelectionIsActive();
    }
    return controller.getSelectionIsActive(callChild: false);
  }

  @override
  void updateSelectionIsActive({bool callChild = true}) {
    if (child != null && callChild) {
      child!.updateSelectionIsActive();
      return;
    }
    controller.updateSelectionIsActive(callChild: false);
  }

  @override
  void updateAllItemsSelected({bool callChild = true}) {
    if (child != null && callChild) {
      child!.updateAllItemsSelected();
      return;
    }
    controller.updateAllItemsSelected(callChild: false);
  }

  @override
  bool allItemsSelectedFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.allItemsSelectedFallBack();
    }
    return controller.allItemsSelectedFallBack(callChild: false);
  }

  @override
  bool selectionIsActiveFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionIsActiveFallBack();
    }
    return controller.selectionIsActiveFallBack(callChild: false);
  }

  @override
  void setSelectAllValue({bool value = false, bool callChild = true}) {
    if (child != null && callChild) {
      child!.setSelectAllValue(value: value);
      return;
    }
    controller.setSelectAllValue(value: value, callChild: false);
  }

  @override
  void updateSelection({callChild = true}) {
    if (child != null && callChild) {
      child!.updateSelection();
      return;
    }
    controller.updateSelection(callChild: false);
  }

  @override
  int selectionCount({callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionCount();
    }
    return controller.selectionCount(callChild: false);
  }
}
