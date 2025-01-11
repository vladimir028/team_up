import 'package:flutter/material.dart';

import '../../data/account/sport_selection/sport.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected
                ? MyColors.primary.pink200
                : null,
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(color: MyColors.dark, width: 1)
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.sport.iconData, color: widget.sport.iconColor),
                const SizedBox(width: 10,),
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
      ),
    );
  }
}
