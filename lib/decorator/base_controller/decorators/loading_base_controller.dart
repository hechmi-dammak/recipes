import 'package:recipes/decorator/controller.dart';

abstract class LoadingBaseController extends Controller {
  @override
  bool getLoading({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void setLoading(bool loading, {bool callChild = true}) {
    throw UnimplementedError();
  }
}
