import 'package:mekla/models/interfaces/model_id.dart';

abstract class ModelName extends ModelId {
  String get name;

  set name(String name);

  static int nameComparator(ModelName a, ModelName b) {
    return a.name.compareTo(b.name);
  }
}
