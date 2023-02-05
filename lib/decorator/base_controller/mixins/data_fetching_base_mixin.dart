import 'package:get/get.dart';
import 'package:recipes/decorator/controller.dart';

mixin DataFetchingBassMixin on Controller {
  @override
  Future<void> fetchData() {
    throw UnimplementedError();
  }

  @override
  void initState(GetBuilderState<Controller>? state) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadData() {
    throw UnimplementedError();
  }
}
