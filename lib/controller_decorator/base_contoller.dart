import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';

class BaseController extends Controller {
  bool _loading = true;

  @override
  bool getLoading({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.getLoading();
    }
    return _loading;
  }

  @override
  void setLoading(bool loading, {bool callChild = true}) {
    if (child != null && callChild) {
      child!.setLoading(loading);
      return;
    }
    _loading = loading;
    decoratorUpdate();
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
  void initState(GetBuilderState<Controller> state, {bool callChild = true}) {
    if (child != null && callChild) {
      child!.initState(state);
      return;
    }
    fetchData();
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
    }
  }
}
