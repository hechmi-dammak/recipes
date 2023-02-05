import 'package:recipes/decorator/controller.dart';

mixin SelectionBaseMixin on Controller {
  @override
  bool get allItemsSelected => throw UnimplementedError();

  @override
  bool get allItemsSelectedFallBack => throw UnimplementedError();

  @override
  int get selectionCount => throw UnimplementedError();

  @override
  bool get selectionIsActive => throw UnimplementedError();

  @override
  bool get selectionIsActiveFallBack => throw UnimplementedError();

  @override
  void setSelectAllValue([bool value = false]) {
    throw UnimplementedError();
  }

  @override
  void toggleSelectAllValue() {
    throw UnimplementedError();
  }

  @override
  void updateAllItemsSelected() {
    throw UnimplementedError();
  }

  @override
  void updateSelection() {
    throw UnimplementedError();
  }

  @override
  void updateSelectionIsActive() {
    throw UnimplementedError();
  }
}
