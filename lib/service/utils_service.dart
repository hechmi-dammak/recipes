import 'package:get/get.dart';

class UtilsService extends GetxService {
  static UtilsService get find => Get.find<UtilsService>();

  Future<String> getUniqueName(
      String name, Future<Set<String>> Function(String name) findByName) async {
    final setOfNames = await findByName(name);
    if (!setOfNames.contains(name)) return name;
    var index = 1;
    while (setOfNames.contains('${name}_$index')) {
      index++;
    }
    name += '_$index';
    return name;
  }
}
