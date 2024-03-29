import 'package:mekla/decorator/controller.dart';
import 'package:mekla/models/interfaces/model_selected.dart';

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

  @override
  void selectItem(ModelSelected item) {
    item.selected = !item.selected;
    updateSelection();
  }

  @override
  Future<void> fetchData() async {
    loading = true;
    await loadData();
    updateSelection();
    loading = false;
  }
}
