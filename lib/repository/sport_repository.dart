import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/repository/auth_repository.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../models/enum/court_type.dart';
import '../models/sport_event.dart';
import '../styles/my_colors.dart';

class SportRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final AuthRepository authRepository = AuthRepository();

  Future<SportEvent?> addSport(
      String name,
      String imgUrl,
      int duration,
      String pricePerHour,
      String totalPlayers,
      String missingPlayers,
      String userId,
      GeoPoint location,
      TimeOfDay scheduledTimeStart,
      TimeOfDay scheduledTimeEnd,
      DateTime? selectedDate,
      CourtType selectedCourtType) async {
    try {
      final collection = firebaseFirestore.collection("sport");
      String id = collection.doc().id;

      final createdSport = SportEvent(
        id: id,
        sportName: name,
        sportImageUrl: imgUrl,
        duration: duration,
        pricePerHour: int.parse(pricePerHour),
        totalPlayersAsOfNow: int.parse(totalPlayers),
        missingPlayers: int.parse(missingPlayers),
        userId: userId,
        location: location,
        startingTime: scheduledTimeStart,
        endingTime: scheduledTimeEnd,
        selectedDate: selectedDate ?? DateTime.now(),
        courtType: selectedCourtType,
      );

      await collection.doc(id).set(createdSport.toJson());

      return createdSport;
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<SportEvent>?> fetchSportEvents() async {
    final collection = firebaseFirestore.collection("sport");
    try {
      final querySnapshot = await collection.get();

      List<SportEvent> sportEvents = querySnapshot.docs
          .map((doc) => SportEvent.fromSnapshot(doc))
          .toList();

      return sportEvents;
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<SportEvent>?> filterSportEvents(
      List<String> filteredSportEvents) async {
    final collection = firebaseFirestore.collection("sport");
    try {
      final querySnapshot = await collection
          .where("sportName", whereIn: filteredSportEvents)
          .get();

      List<SportEvent> sportEvents = querySnapshot.docs
          .map((doc) => SportEvent.fromSnapshot(doc))
          .toList();

      return sportEvents;
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<List<Sport>?> getUserPreferredSports() async {
    final collection = firebaseFirestore.collection("customUser");
    final currentUserId = authRepository.getCurrentUser().uid;
    List<Sport> allSports = SportSelection.sports;

    try {
      final docSnapshot =
          await collection.where("id", isEqualTo: currentUserId).get();
      final favoriteSportWithLevel = docSnapshot.docs
          .map((doc) => CustomUser.fromSnapshot(doc))
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
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }

  Future<SportEvent?> joinEvent(SportEvent sportEvent, BuildContext context) async {
    final collection = firebaseFirestore.collection("sport");
    try {
      var docSnapshot = await collection.where('id', isEqualTo: sportEvent.id).get();

      if (docSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = docSnapshot.docs.first.data();
        int missingPlayers = data['missingPlayers'] ?? 0;
        int totalPlayersAsOfNow = data['totalPlayersAsOfNow'] ?? 0;

        if (missingPlayers > 0) {
          missingPlayers--;
          totalPlayersAsOfNow++;

          String docId =  docSnapshot.docs.single.id;

          await collection.doc(docId).update({
            'missingPlayers' : missingPlayers,
            'totalPlayersAsOfNow': totalPlayersAsOfNow
          });

          var updatedDocSnapshot = await collection.doc(docId).get();
          if (updatedDocSnapshot.exists) {
            SportEvent updatedEvent = SportEvent.fromSnapshot(updatedDocSnapshot);
            return updatedEvent;
          }
        } else {
          Toast toast = Toast(
              ToastificationType.error,
              "No slots available",
              "This event is already full.",
              Icons.info_outline,
              MyColors.support.warning);
          toast.showToast();
        }
      } else {
        Toast toast = Toast(
            ToastificationType.error,
            "Event not found",
            "The specified event does not exist.",
            Icons.error_outline,
            MyColors.support.error);
        toast.showToast();
      }
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }
    return null;
  }
}
