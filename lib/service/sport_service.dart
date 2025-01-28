import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/time.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/models/enum/court_type.dart';
import 'package:team_up/repository/sport_repository.dart';

import '../models/sport_event.dart';

class SportService {
  final SportRepository sportRepository = SportRepository();

  Future<SportEvent?> addSport(
      String name,
      String imgUrl,
      int duration,
      String pricePerHour,
      String totalPlayers,
      String missingPlayers,
      String userId,
      GeoPoint location,
      String locationAddress,
      TimeOfDay scheduledTimeStart,
      TimeOfDay scheduledTimeEnd,
      DateTime? selectedDate,
      CourtType selectedCourtType) async {
    return sportRepository.addSport(
        name,
        imgUrl,
        duration,
        pricePerHour,
        totalPlayers,
        missingPlayers,
        userId,
        location,
        locationAddress,
        scheduledTimeStart,
        scheduledTimeEnd,
        selectedDate,
        selectedCourtType);
  }

  Future<List<SportEvent>?> fetchSportEvents() async {
    return await sportRepository.fetchSportEvents();
  }

  Future<List<SportEvent>?> filterSportEvents(
      List<String> filteredSportEvents) async {
    return await sportRepository.filterSportEvents(filteredSportEvents);
  }

  Future<List<Sport>?> getUserPreferredSports() async {
    return await sportRepository.getUserPreferredSports();
  }

  Future<SportEvent?> joinEvent(
      SportEvent sportEvent, BuildContext context) async {
    return await sportRepository.joinEvent(sportEvent, context);
  }

  Future<List<SportEvent>?> fetchMyUpcomingSportEvents() async {
    return await sportRepository.fetchMyUpcomingSportEvents();
  }

  Future<List<SportEvent>?> fetchMyWishlist() async {
    return await sportRepository.fetchMyWishlist();
  }

  Future<void> addToWishlist(String sportEventId) async {
    await sportRepository.addToWishlist(sportEventId);
  }

  Future<void> removeFromWishlist(String sportEventId) async{
    await sportRepository.removeFromWishlist(sportEventId);
  }

  Future<bool> checkWishlistStatus(String sportEventId) async{
    return await sportRepository.checkWishlistStatus(sportEventId);
  }

  Future<SportEvent?> cancelEvent(SportEvent sportEvent, BuildContext context) async{
    return await sportRepository.cancelEvent(sportEvent, context);
  }
}
