import 'package:recipes/decorator/controller.dart';
import 'package:recipes/decorator/controller_decorator.dart';

class SelectionDecorator extends ControllerDecorator {
  SelectionDecorator({super.controller});

  factory SelectionDecorator.create({Controller? controller}) {
    final selectionDecorator = SelectionDecorator(controller: controller);
    selectionDecorator.controller.child = selectionDecorator;
    return selectionDecorator;
  }

  bool _selectionIsActive = false;
  bool _allItemsSelected = false;

  @override
  bool getSelectionIsActive({callChild = true}) {
    if (child != null && callChild) {
      return child!.getSelectionIsActive();
    }
    return _selectionIsActive;
  }

  @override
  void updateSelection({callChild = true}) {
    if (child != null && callChild) {
      child!.updateSelection();
      return;
    }
    updateSelectionIsActive();
    updateAllItemsSelected();
  }

  @override
  void updateSelectionIsActive({callChild = true}) {
    if (child != null && callChild) {
      child!.updateSelectionIsActive();
      return;
    }
    _selectionIsActive = selectionIsActiveFallBack();
    decoratorUpdate();
  }

  @override
  bool getAllItemsSelected({callChild = true}) {
    if (child != null && callChild) {
      return child!.getAllItemsSelected();
    }
    return _allItemsSelected;
  }

  @override
  void updateAllItemsSelected({bool callChild = true}) {
    if (child != null && callChild) {
      child!.updateAllItemsSelected();
      return;
    }
    _allItemsSelected = allItemsSelectedFallBack();
    decoratorUpdate();
  }

  @override
  void toggleSelectAllValue({bool value = false, callChild = true}) {
    if (child != null && callChild) {
      child!.toggleSelectAllValue();
      return;
    }
    setSelectAllValue(value: !getAllItemsSelected());
  }

  @override
  void setSelectAllValue({bool value = false, callChild = true}) {
    if (child != null && callChild) {
      child!.setSelectAllValue(value: value);
      return;
    }
    updateSelection();
    decoratorUpdate();
  }
}
