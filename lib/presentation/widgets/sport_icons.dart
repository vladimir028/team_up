import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/sport.dart';

import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class SportIcons extends StatefulWidget {
  const SportIcons({super.key});

  @override
  State<SportIcons> createState() => _SportIconsState();
}

class _SportIconsState extends State<SportIcons> {
  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        pattern: [
          const WovenGridTile(2.5),
          const WovenGridTile(
            2.5,
          ),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          Sport sport = SportSelection.sports[index];
          return SportTile(sport: sport);
        },
        childCount: SportSelection.sports.length,
      ),
    );
  }
}

class SportTile extends StatelessWidget {
  final Sport sport;

  const SportTile({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primary.pink100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(sport.iconData, color: sport.iconColor,),
            Text(
              sport.name,
              style: const TextStyle(
                color: MyColors.dark,
                fontWeight: FontWeight.bold,
                fontSize: MyFontSizes.titleBase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
