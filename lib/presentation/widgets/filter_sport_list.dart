import 'package:flutter/material.dart';
import 'package:team_up/presentation/widgets/sport_tile.dart';

import '../../data/account/sport_selection/sport.dart';
import '../../data/account/sport_selection/sport_selection.dart';

class FilterSportList extends StatefulWidget {

  final List<Sport> selectedSports;
  final VoidCallback filterSportEvents;

   const FilterSportList({
    super.key, required this.selectedSports, required this.filterSportEvents,
  });

  @override
  State<FilterSportList> createState() => _FilterSportListState();
}

class _FilterSportListState extends State<FilterSportList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      // itemCount: selectedSportsFromRegistration.length,
      itemCount: SportSelection.sports.length,
      itemBuilder: (context, index) {
        // final sport = selectedSportsFromRegistration[index];
        final sport = SportSelection.sports[index];
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SportTile(
            shouldSeeRatings: false,
            sport: sport,
            isSelected: widget.selectedSports.contains(sport),
            onToggle: () => selectSport(sport),
            onRatingChanged: (rating) => updateSportRating(sport, rating),
          ),
        );
      },
    );
  }


  void updateSportRating(Sport sport, int rating) {
    setState(() {
      sport.rating = rating;
      // You might want to add additional logic here
      // to persist the rating or trigger other updates
    });
  }

  void selectSport(Sport sport) {
    setState(() {
      if (widget.selectedSports.contains(sport)) {
        widget.selectedSports.remove(sport);
      } else {
        widget.selectedSports.add(sport);
      }
      widget.filterSportEvents();
    });
  }
}
