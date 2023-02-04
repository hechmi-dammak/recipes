import 'package:get/get.dart';
import 'package:recipes/decorator/base_controller/decorators/loading_base_controller.dart';
import 'package:recipes/decorator/controller.dart';

abstract class DataFetchingBaseController extends LoadingBaseController {
  @override
  Future<void> fetchData({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  void initState(GetBuilderState<Controller>? state, {bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadData({bool callChild = true}) {
    throw UnimplementedError();
  }
}
