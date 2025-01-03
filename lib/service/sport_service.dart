import 'package:flutter/cupertino.dart';
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
}