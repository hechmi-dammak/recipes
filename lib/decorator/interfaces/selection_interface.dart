import 'package:flutter/foundation.dart';

abstract class SelectionInterface {
  bool get selectionIsActive;

  void updateSelectionIsActive();

  void updateAllItemsSelected();

  bool get allItemsSelected;

  bool get selectionIsActiveFallBack;

  bool get allItemsSelectedFallBack;

  void toggleSelectAllValue();

  @mustCallSuper
  void setSelectAllValue([bool value = false]);

  void updateSelection();

  int get selectionCount;
}
