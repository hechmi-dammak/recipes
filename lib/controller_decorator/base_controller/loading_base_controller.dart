import 'package:recipes/controller_decorator/controller.dart';

abstract class LoadingBaseController extends Controller {
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
}
