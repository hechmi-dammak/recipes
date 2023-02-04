import 'package:get/get.dart';
import 'package:recipes/decorator/controller.dart';
import 'package:recipes/decorator/controller_decorator.dart';

class DataFetchingDecorator extends ControllerDecorator {
  DataFetchingDecorator({super.controller});

  factory DataFetchingDecorator.create({Controller? controller}) {
    final dataFetchingDecorator = DataFetchingDecorator(controller: controller);
    dataFetchingDecorator.controller.child = dataFetchingDecorator;
    return dataFetchingDecorator;
  }

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
