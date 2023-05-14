import 'package:flutter/material.dart';
import 'package:mekla/models/isar_models/ingredient.dart';
import 'package:mekla/widgets/project/upsert_element/models/autocomplete_upsert_from_field.dart';
import 'package:mekla/widgets/project/upsert_element/models/servings_upsert_form_field.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/autocomplete_upsert_form_field_widget.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/picture_upsert_form_field/picture_upsert_form_field_widget.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/servings_upsert_form_field/servings_upsert_form_field_widget.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/text_upsert_form_field_widget.dart';

class UpsertFormFieldWidget extends StatelessWidget {
  const UpsertFormFieldWidget({Key? key, required this.formField})
      : super(key: key);
  final UpsertFormField formField;

  @override
  Widget build(BuildContext context) {
    if (formField is TextUpsertFormField) {
      return TextUpsertFormFieldWidget(
          formField: formField as TextUpsertFormField);
    }
    if (formField is PictureUpsertFormField) {
      return PictureUpsertFormFieldWidget(
          formField: formField as PictureUpsertFormField);
    }
    if (formField is ServingsUpsertFormField) {
      return ServingsUpsertFormFieldWidget(
          formField: formField as ServingsUpsertFormField);
    }
    if (formField is AutocompleteUpsertFormField<Ingredient>) {
      return AutocompleteUpsertFormFieldWidget<Ingredient>(
          formField: formField as AutocompleteUpsertFormField<Ingredient>);
    }
    return Container();
  }
}
