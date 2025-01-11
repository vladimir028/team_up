import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/repository/auth_repository.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../models/sport_event.dart';
import '../styles/my_colors.dart';

class SportRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final AuthRepository authRepository = AuthRepository();

  Future<SportEvent?> addSport(SportEvent sport, BuildContext context) async{
    try{
      final collection = firebaseFirestore.collection("sport");
      String id = collection.doc().id;

      await collection.doc(id).set(sport.toJson(context));
      return sport;
    }
    catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<SportEvent>?> fetchSportEvents() async{
    final collection = firebaseFirestore.collection("sport");
    try{

      final querySnapshot = await collection.get();

      List<SportEvent> sportEvents = querySnapshot.docs
          .map((doc) => SportEvent.fromSnapshot(doc))
          .toList();

      return sportEvents;
    }
    catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<SportEvent>?> filterSportEvents(List<String> filteredSportEvents) async{
    final collection = firebaseFirestore.collection("sport");
    try{

      final querySnapshot = await collection.where("sportName", whereIn: filteredSportEvents).get();

      List<SportEvent> sportEvents = querySnapshot.docs
          .map((doc) => SportEvent.fromSnapshot(doc))
          .toList();

      return sportEvents;
    }
    catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<Sport>?> getUserPreferredSports() async{
    final collection = firebaseFirestore.collection("customUser");
    final currentUserId = authRepository.getCurrentUser().uid;
    List<Sport> allSports = SportSelection.sports;

    try{
      final docSnapshot = await collection.where("id", isEqualTo: currentUserId).get();
      final  favoriteSportWithLevel = docSnapshot.docs.map((doc) => CustomUser.fromSnapshot(doc))
      .first
      .favoriteSportWithLevel;

      List<String> favoriteSportsKeys = favoriteSportWithLevel.keys.toList();

      List<Sport> usersFavSports = [];
      for (var sport in allSports) {
        for (var favSport in favoriteSportsKeys) {
          if (sport.name == favSport) {
            usersFavSports.add(sport);
          }
        }
      }

      return usersFavSports;
    }
    catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }



}