import 'package:flutter/material.dart';
import 'package:recipes/widgets/common/svg_button.dart';

class SelectAllButton extends StatelessWidget {
  const SelectAllButton({
    super.key,
    required this.allItemsSelected,
    required this.onTap,
  });

  final bool allItemsSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SvgButton(
        onTap: onTap,
        icon: allItemsSelected
            ? 'assets/icons/select_all_icon.svg'
            : 'assets/icons/deselect_all_icon.svg');
  }
}
