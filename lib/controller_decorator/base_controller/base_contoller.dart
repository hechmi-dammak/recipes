import 'package:get/get.dart';
import 'package:recipes/controller_decorator/base_controller/selection_base_controller.dart';
import 'package:recipes/controller_decorator/controller.dart';

class BaseController extends SelectionBaseController {
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
