import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/input_decoration.dart';
import 'package:mekla/widgets/project/upsert_element/models/autocomplete_upsert_from_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_title.dart';

class AutocompleteUpsertFormFieldWidget<T extends Object>
    extends StatelessWidget {
  const AutocompleteUpsertFormFieldWidget({super.key, required this.formField});

  final AutocompleteUpsertFormField<T> formField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(
          title: formField.label.tr,
          optional: formField.optional,
        ),
        const SizedBox(height: 7),
        Autocomplete<T>(
          initialValue: TextEditingValue(text: formField.controller.text),
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
              controller: textEditingController,
              style: Get.textTheme.bodyLarge?.copyWith(fontFeatures: [
                const FontFeature.tabularFigures(),
                const FontFeature.liningFigures()
              ]),
              decoration: CustomInputDecoration(),
              maxLines: formField.maxLines,
              validator: formField.validator,
            );
          },
          displayStringForOption: formField.displayLabel,
          optionsBuilder: (textEditingController) {
            formField.controller.text = textEditingController.text;
            return formField.filter(textEditingController);
          },
          onSelected: formField.onSelect,
          optionsViewBuilder: (context, onSelected, options) {
            return _AutocompleteOptions<T>(
                displayStringForOption: formField.displayLabel,
                onSelected: onSelected,
                options: options);
          },
        ),
      ],
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: LayoutBuilder(builder: (context, _) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 35,
                maxWidth: Get.width - 60 - (Get.height > 450 ? 80 : 0)),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final T option = options.elementAt(index);
                return InkWell(
                  onTap: () {
                    onSelected(option);
                  },
                  child: Builder(builder: (BuildContext context) {
                    final bool highlight =
                        AutocompleteHighlightedOption.of(context) == index;
                    if (highlight) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((Duration timeStamp) {
                        Scrollable.ensureVisible(context, alignment: 0.5);
                      });
                    }
                    return Container(
                      color: highlight
                          ? Get.theme.colorScheme.tertiaryContainer
                          : Get.theme.colorScheme.primaryContainer,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        displayStringForOption(option),
                        style: Get.textTheme.bodyLarge,
                      ),
                    );
                  }),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
