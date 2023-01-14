import 'package:recipes/controller_decorator/base_controller/loading_base_controller.dart';

abstract class DataFetchingBaseController extends LoadingBaseController {
  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
    }
  }

  @override
  Future<void> fetchData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.fetchData();
      return;
    }
    setLoading(true);
    await loadData();
    setLoading(false);
  }
}
