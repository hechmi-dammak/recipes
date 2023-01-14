abstract class SelectionInterface {
  bool getSelectionIsActive({bool callChild = true});

  void setSelectionIsActive(bool? selectionIsActive, {bool callChild = true});

  bool getAllItemsSelected({bool callChild = true});

  void setAllItemsSelected(bool? allItemsSelected, {bool callChild = true});

  bool selectionIsActiveFallBack({bool callChild = true});

  bool allItemsSelectedFallBack({bool callChild = true});

  void setSelectAllValue({bool value = false, bool callChild = true}) {}
}
