import 'package:flutter/foundation.dart';

abstract class SelectionInterface {
  bool getSelectionIsActive({bool callChild = true});

  void updateSelectionIsActive({bool callChild = true});

  void updateAllItemsSelected({bool callChild = true});

  bool getAllItemsSelected({bool callChild = true});

  @mustCallSuper
  bool selectionIsActiveFallBack({bool callChild = true});

  bool allItemsSelectedFallBack({bool callChild = true});

  void toggleSelectAllValue({bool callChild = true});

  void setSelectAllValue({bool value = false, bool callChild = true});

  void updateSelection({callChild = true});

  int selectionCount({callChild = true});
}
