import 'package:mekla/decorator/controller.dart';
import 'package:mekla/models/interfaces/model_used.dart';

mixin UsedDecorator on Controller {
  void useItem(ModelUsed item) {
    item.used = !item.used;
    updateSelection();
  }
}
