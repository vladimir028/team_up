import 'package:flutter/cupertino.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/repository/sport_repository.dart';

import '../models/sport_event.dart';

class SportService {
  final SportRepository sportRepository = SportRepository();

  Future<SportEvent?> addSport(SportEvent sport, BuildContext context) async{
    return sportRepository.addSport(sport, context);
  }

  Future<List<SportEvent>?>fetchSportEvents() async{
    return await sportRepository.fetchSportEvents();
  }

  Future<List<SportEvent>?> filterSportEvents(List<String> filteredSportEvents) async{
    return await sportRepository.filterSportEvents(filteredSportEvents);
  }

  Future<List<Sport>?> getUserPreferredSports() async{
    return await sportRepository.getUserPreferredSports();
  }
}