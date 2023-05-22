import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class ServingsUpsertFormField extends UpsertFormField {
  int servings;

  ServingsUpsertFormField({
    required super.name,
    required this.servings,
    super.optional,
    required super.label,
  });
}
