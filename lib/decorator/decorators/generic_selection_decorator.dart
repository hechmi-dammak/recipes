import 'package:get/get.dart';
import 'package:mekla/decorator/controller.dart';
import 'package:mekla/models/interfaces/model_selected.dart';
import 'package:mekla/repositories/abstracts/repository_service.dart';
import 'package:mekla/widgets/common/snack_bar.dart';

mixin GenericSelectionDecorator<T extends ModelSelected,
    V extends RepositoryService> on Controller {
  List<T> get items;

  String get itemsName;

  Iterable<T> get selectedItems {
    return items.where((item) => item.selected);
  }

  @override
  bool get selectionIsActiveFallBack => items.any((item) => item.selected);

  @override
  bool get allItemsSelectedFallBack => items.every((item) => item.selected);

  @override
  int get selectionCount => selectedItems.length;

  @override
  void setSelectAllValue([bool value = false]) {
    for (var item in items) {
      item.selected = value;
    }
    super.setSelectAllValue(value);
  }

  Future<void> deleteSelectedItems() async {
    loading = true;
    for (T item in selectedItems) {
      Get.find<V>().deleteById(item.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected $itemsName were deleted.'.tr);
  }
}
