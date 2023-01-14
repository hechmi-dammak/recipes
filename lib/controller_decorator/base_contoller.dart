import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';

class BaseController extends Controller {
  bool _loading = true;

  @override
  bool getLoading({callChild = true}) {
    if (child != null && callChild) {
      return child!.getLoading();
    }
    return _loading;
  }

  @override
  void setLoading(bool loading, {callChild = true}) {
    if (child != null && callChild) {
      child!.setLoading(loading);
      return;
    }
    _loading = loading;
    update();
  }

  @override
  Future<void> fetchData({callChild = true}) async {
    if (child != null && callChild) {
      await child!.fetchData();
      return;
    }
    setLoading(true);
    await loadData();
    setLoading(false);
  }

  @override
  void initState(GetBuilderState<Controller> state, {callChild = true}) {
    if (child != null && callChild) {
      child!.initState(state);
      return;
    }
    fetchData();
  }

  @override
  Future<void> loadData({callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
    }
  }
}
