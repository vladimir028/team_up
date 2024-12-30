import 'package:flutter/material.dart';

import '../../models/sport.dart';
import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class SportTile extends StatefulWidget {
  final Sport sport;
  final bool isSelected;
  final VoidCallback onToggle;

  const SportTile({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<SportTile> createState() => _SportTileState();
}

class _SportTileState extends State<SportTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected
              ? MyColors.primary.pink200
              : MyColors.primary.pink100,
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: MyColors.support.success, width: 3)
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(widget.sport.iconData, color: widget.sport.iconColor),
              Text(
                widget.sport.name,
                style: const TextStyle(
                  color: MyColors.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: MyFontSizes.titleBase,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
