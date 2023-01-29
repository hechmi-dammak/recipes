import 'package:get/get.dart';

extension GetE on GetInterface {
  Future<T?>? toNamedWithPathParams<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Map<String, String>? pathParameters,
  }) {
    if (pathParameters?.isNotEmpty ?? false) {
      pathParameters!.forEach((key, value) {
        page = page.replaceAll(':$key', value);
      });
    }
    return Get.toNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }
}
