import 'package:mekla/decorator/controller.dart';

mixin LoadingBaseMixin on Controller {
  @override
  bool get loading => throw UnimplementedError();

  @override
  set loading(bool loading) => throw UnimplementedError();
}
