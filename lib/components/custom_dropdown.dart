import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/ensure_visible.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/decorations/gradient_decoration.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown(
      {Key? key,
      required this.items,
      this.value,
      required this.onChange,
      required this.onButtonClick})
      : super(key: key);
  final List<String> items;
  final String? value;
  final void Function(String?) onChange;
  final void Function() onButtonClick;
  final FocusNode _fieldNode = FocusNode();

  final GlobalKey _dropdownKey = GlobalKey();

  void openItemsList() {
    dynamic detector;
    void search(BuildContext context) {
      context.visitChildElements((element) {
        if (detector != null) return;
        if (element.widget is GestureDetector) {
          detector = element.widget;
        } else {
          search(element);
        }
      });
    }

    search(_dropdownKey.currentContext!);
    if (detector != null) detector.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: Container(
              decoration: GradientDecoration(),
              child: EnsureVisibleWhenFocused(
                focusNode: _fieldNode,
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: GestureDetector(
                    onTap: () {
                      if (items.isNotEmpty) {
                        openItemsList();
                      } else {
                        CustomSnackBar.warning(
                            'There are no values yet add a new one.');
                      }
                    },
                    child: DropdownButtonFormField<String>(
                      focusNode: _fieldNode,
                      key: _dropdownKey,
                      dropdownColor: Get.theme.colorScheme.primary,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Get.theme.colorScheme.onPrimary,
                          fontSize: 18),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Get.theme.colorScheme.onPrimary,
                              fontSize: 20),
                          labelText: 'Category'),
                      iconSize: 30,
                      value: value,
                      onChanged: onChange,
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: GradientDecoration(),
                child: InkWell(
                    onTap: onButtonClick,
                    child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Icon(
                            value == null ? Icons.add : Icons.close_rounded))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
