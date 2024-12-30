import 'package:team_up/data/account/sport_selection/sport_selection_icon_data.dart';
import 'package:team_up/styles/my_colors.dart';

import 'sport.dart';


class SportSelection {

  static List<Sport> sports =
      [
        Sport("Basketball", SportIconData.sports_basketball, MyColors.sport.orange),
        Sport("Football", SportIconData.sports_football,  MyColors.sport.black),
        Sport("Volleyball", SportIconData.sports_volleyball, MyColors.sport.blue),
        Sport("Tennis", SportIconData.sports_tennis, MyColors.sport.red),
        Sport("Running", SportIconData.run_circle_outlined, MyColors.sport.black),
        Sport("Handball", SportIconData.sports_handball, MyColors.sport.green),
        Sport("Badminton", SportIconData.sports_badminton, MyColors.sport.brown),
      ];
}