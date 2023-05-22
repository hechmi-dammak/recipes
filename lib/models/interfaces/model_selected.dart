import 'package:mekla/models/interfaces/model_id.dart';

abstract class ModelSelected extends ModelId {
  bool get selected;

  set selected(bool selected);
}
