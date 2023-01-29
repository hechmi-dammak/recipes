import 'package:recipes/controller_decorator/base_controller/data_fetching_base_controller.dart';

abstract class SelectionBaseController extends DataFetchingBaseController {
  @override
  bool allItemsSelectedFallBack({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  bool getAllItemsSelected({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  bool getSelectionIsActive({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  bool selectionIsActiveFallBack({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void setSelectAllValue({bool value = false, bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void updateSelectionIsActive({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void updateAllItemsSelected({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void updateSelection({callChild = true}) {
    throw UnimplementedError();
  }

  @override
  int selectionCount({callChild = true}) {
    throw UnimplementedError();
  }
}
