import 'package:recipes/decorator/controller.dart';
import 'package:recipes/decorator/controller_decorator.dart';

class LoadingDecorator extends ControllerDecorator {
  LoadingDecorator({super.controller});

  factory LoadingDecorator.create({Controller? controller}) {
    final loadingDecorator = LoadingDecorator(controller: controller);
    loadingDecorator.controller.child = loadingDecorator;
    return loadingDecorator;
  }

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
