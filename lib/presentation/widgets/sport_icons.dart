import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/global/user_registration_details.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/presentation/widgets/sport_tile.dart';

class SportIcons extends StatefulWidget {
  const SportIcons({super.key});

  @override
  State<SportIcons> createState() => _SportIconsState();
}

class _SportIconsState extends State<SportIcons> {
  List<Sport> _selectedSports = [];

  void _toggleSportSelection(Sport sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }

      UserStore.favoriteSports = _selectedSports;
    });
  }

  @override
  void initState() {

    super.initState();
    _selectedSports = UserStore.favoriteSports ?? [];
  }

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
          return SportTile(
            sport: sport,
            isSelected: _selectedSports.contains(sport),
            onToggle: () => _toggleSportSelection(sport),
          );
        },
        childCount: SportSelection.sports.length,
      ),
    );
  }
}
