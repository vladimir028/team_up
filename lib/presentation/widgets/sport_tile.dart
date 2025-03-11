import 'package:flutter/material.dart';

import '../../data/account/sport_selection/sport.dart';
import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class SportTile extends StatefulWidget {
  final bool shouldSeeRatings;
  final Sport sport;
  final bool isSelected;
  final VoidCallback onToggle;
  final Function(int) onRatingChanged;

  const SportTile({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onToggle,
    required this.onRatingChanged,
    required this.shouldSeeRatings
  });

  @override
  State<SportTile> createState() => _SportTileState();
}

class _SportTileState extends State<SportTile> {
  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate your ${widget.sport.name} skill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate yourself from 1-5?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                      (index) => GestureDetector(
                    onTap: () {
                      widget.onRatingChanged(index + 1);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.sport.rating == index + 1
                            ? MyColors.primary.pink200
                            : Colors.grey.shade200,
                        border: Border.all(
                          color: MyColors.dark,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MyFontSizes.titleBase,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      onLongPress: widget.isSelected ? _showRatingDialog : null,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use Flexible widgets to prevent overflow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Make row take minimum space needed
                  children: [
                    Icon(widget.sport.iconData, color: widget.sport.iconColor),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.sport.name,
                        style: const TextStyle(
                          color: MyColors.dark,
                          fontWeight: FontWeight.bold,
                          fontSize: MyFontSizes.titleBase,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncate text if too long
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                if (widget.isSelected && widget.sport.rating != null)
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     mainAxisSize: MainAxisSize.min, // Make row take minimum space needed
                  //     children: [
                  //       const Text(
                  //         'Skill: ',
                  //         style: TextStyle(
                  //           fontSize: MyFontSizes.titleBase,
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisSize: MainAxisSize.min, // Make nested row take minimum space needed
                  //         children: List.generate(
                  //           5,
                  //               (index) => Icon(
                  //             Icons.star,
                  //             size: 14, // Smaller stars to save space
                  //             color: index < widget.sport.rating!
                  //                 ? Colors.amber
                  //                 : Colors.grey.shade300,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                if (widget.isSelected && widget.shouldSeeRatings)
                   Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Make row take minimum space needed
                      children: [
                         const Text(
                          'Skill: ',
                          style: TextStyle(
                            fontSize: MyFontSizes.titleBase,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min, // Make nested row take minimum space needed
                          children: List.generate(
                            5,
                                (index) => Icon(
                              Icons.star,
                              size: 14, // Smaller stars to save space
                              color: index < widget.sport.rating
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        // Text(
                        //   "Long press to rate",
                        //   style: TextStyle(
                        //     fontSize: MyFontSizes.titleBase - 2,
                        //     fontStyle: FontStyle.italic,
                        //   ),
                        // ),
                      ],
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
