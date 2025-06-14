import 'package:team_up/data/account/sport_selection/sport_selection_icon_data.dart';
import 'package:team_up/styles/my_colors.dart';

import 'sport.dart';


class SportSelection {

  static List<Sport> sports =
      [
        Sport("Basketball", SportIconData.sports_basketball, MyColors.sport.orange, "https://images.wallpaperscraft.com/image/single/basketball_ball_basketball_spalding_113635_1600x900.jpg", 1),
        Sport("Football", SportIconData.sports_football,  MyColors.sport.black, "https://images.wallpaperscraft.com/image/single/ball_football_lawn_122322_2560x1440.jpg", 1),
        Sport("Volleyball", SportIconData.sports_volleyball, MyColors.sport.blue, "https://assets-global.website-files.com/5ca5fe687e34be0992df1fbe/61cf16cfb8137b7b88eddb62_female-player-holding-volleyball-in-the-court-2021-08-28-22-13-01-utc-min.jpg", 1),
        Sport("Tennis", SportIconData.sports_tennis, MyColors.sport.red, "https://images.wallpaperscraft.com/image/single/tennis_court_net_211540_2560x1440.jpg", 1),
        Sport("Running", SportIconData.run_circle_outlined, MyColors.sport.black, "https://dss.fosterwebmarketing.com/upload/1160/person-running-down-a-street-with-blurred-background%20(1).jpeg", 1),
        Sport("Handball", SportIconData.sports_handball, MyColors.sport.green, "https://mrwallpaper.com/images/high/caption-intense-handball-match-in-action-mxdvwzrttqe26fvi.jpg", 1),
        Sport("Badminton", SportIconData.sports_badminton, MyColors.sport.brown, "https://img2.wallspic.com/previews/8/0/0/6/3/136008/136008-racquet_sport-sports-racket-tennis-sporting_goods-550x310.jpg", 1),
      ];
}