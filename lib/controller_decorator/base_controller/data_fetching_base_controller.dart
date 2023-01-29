import 'package:get/get.dart';
import 'package:recipes/controller_decorator/base_controller/loading_base_controller.dart';
import 'package:recipes/controller_decorator/controller.dart';

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
  @override
  void initState(GetBuilderState<Controller>? state,
      {bool callChild = true}) async {
    if (child != null && callChild) {
      child!.initState(state);
      return;
    }
    fetchData();
  }
}
