import 'package:flutter/material.dart';

import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(
            color: MyColors.dark,
            width: 2.0,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: MyColors.dark,
            fontSize: MyFontSizes.titleBase,
          ),
        ),
      ),
    );
  }
}
