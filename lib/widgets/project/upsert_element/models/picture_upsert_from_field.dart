import 'package:recipes/models/picture.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class PictureUpsertFormField extends UpsertFormField {
  PictureUpsertFormField({required super.name, this.aspectRatio = 2});

  Picture? picture;
  double aspectRatio;
}
