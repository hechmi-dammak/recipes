import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';

class SelectionDecorator extends ControllerDecorator {
  SelectionDecorator({required super.controller});

  factory SelectionDecorator.create({required Controller controller}) {
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
  void setSelectionIsActive(bool? selectionIsActive, {callChild = true}) {
    if (child != null && callChild) {
      child!.setSelectionIsActive(selectionIsActive);
      return;
    }
    _selectionIsActive = selectionIsActive ?? selectionIsActiveFallBack();
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
  void setAllItemsSelected(bool? allItemsSelected, {callChild = true}) {
    if (child != null && callChild) {
      child!.setAllItemsSelected(allItemsSelected);
      return;
    }
    _allItemsSelected = allItemsSelected ?? allItemsSelectedFallBack();
    decoratorUpdate();
  }

  @override
  bool allItemsSelectedFallBack({callChild = true}) {
    if (child != null && callChild) {
      return child!.allItemsSelectedFallBack();
    }
    throw UnimplementedError();
  }

  @override
  bool selectionIsActiveFallBack({callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionIsActiveFallBack();
    }
    throw UnimplementedError();
  }
}
