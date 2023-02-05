import 'package:recipes/decorator/controller.dart';

mixin LoadingDecorator on Controller {
  bool _loading = true;

  @override
  bool get loading => _loading;

  @override
  set loading(bool loading) {
    _loading = loading;
    update();
  }
}
