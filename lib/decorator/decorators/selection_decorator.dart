import 'package:recipes/decorator/controller.dart';

mixin SelectionDecorator on Controller {
  bool _selectionIsActive = false;
  bool _allItemsSelected = false;

  @override
  bool get allItemsSelected => _allItemsSelected;

  @override
  bool get selectionIsActive => _selectionIsActive;

  @override
  void setSelectAllValue([bool value = false]) {
    updateSelection();
  }

  @override
  void toggleSelectAllValue() {
    setSelectAllValue(!allItemsSelected);
  }

  @override
  void updateAllItemsSelected() {
    _allItemsSelected = allItemsSelectedFallBack;
    update();
  }

  @override
  void updateSelection() {
    updateSelectionIsActive();
    updateAllItemsSelected();
  }

  @override
  void updateSelectionIsActive() {
    _selectionIsActive = selectionIsActiveFallBack;
    update();
  }
}
