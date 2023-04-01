import 'package:flutter/material.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/widgets/project/upsert_element/models/autocomplete_upsert_from_field.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/autocomplete_upsert_form_field_widget.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/picture_upsert_form_field/picture_upsert_form_field_widget.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/text_upsert_form_field_widget.dart';

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
    if (formField is AutocompleteUpsertFormField<Ingredient>) {
      return AutocompleteUpsertFormFieldWidget<Ingredient>(
          formField: formField as AutocompleteUpsertFormField<Ingredient>);
    }
    return Container();
  }
}
