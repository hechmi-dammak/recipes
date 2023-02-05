import 'package:get/get.dart';
import 'package:recipes/decorator/interfaces/data_fetching_interface.dart';
import 'package:recipes/decorator/interfaces/loading_interface.dart';
import 'package:recipes/decorator/interfaces/selection_interface.dart';

abstract class Controller extends GetxController
    implements LoadingInterface, DataFetchingInterface, SelectionInterface {
  Controller? child;

  Controller({this.child});

  void decoratorUpdate({bool callChild = true}) {
    if (child != null && callChild) {
      child!.decoratorUpdate();
      return;
    }
    update();
  }
}
