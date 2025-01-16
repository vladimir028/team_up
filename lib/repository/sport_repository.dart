import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/models/user_events.dart';
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
      String locationAddress,
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
        locationAddress: locationAddress,
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

  Future<SportEvent?> joinEvent(
      SportEvent sportEvent, BuildContext context) async {
    final sportEventCollection = firebaseFirestore.collection("sport");
    final userEventCollection = firebaseFirestore.collection("user_event");
    final String userId = authRepository.getCurrentUser().uid;
    try {
      var existingUserEvent = await userEventCollection
          .where('userId', isEqualTo: userId)
          .where('sportEventId', isEqualTo: sportEvent.id)
          .get();

      if (existingUserEvent.docs.isNotEmpty) {
        Toast toast = Toast(
            ToastificationType.error,
            "Already Joined",
            "You have already joined this event.",
            Icons.info_outline,
            MyColors.support.warning);
        toast.showToast();
        return null;
      }

      var docSnapshot = await sportEventCollection
          .where('id', isEqualTo: sportEvent.id)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = docSnapshot.docs.first.data();
        int missingPlayers = data['missingPlayers'] ?? 0;
        int totalPlayersAsOfNow = data['totalPlayersAsOfNow'] ?? 0;

        if (missingPlayers > 0) {
          missingPlayers--;
          totalPlayersAsOfNow++;

          String docId = docSnapshot.docs.single.id;

          await sportEventCollection.doc(docId).update({
            'missingPlayers': missingPlayers,
            'totalPlayersAsOfNow': totalPlayersAsOfNow
          });

          var updatedDocSnapshot = await sportEventCollection.doc(docId).get();
          if (updatedDocSnapshot.exists) {
            SportEvent updatedEvent =
                SportEvent.fromSnapshot(updatedDocSnapshot);
            String userEventId = userEventCollection.doc().id;

            UserEvents userEvents = UserEvents(
                id: userEventId, userId: userId, sportEventId: updatedEvent.id);
            await userEventCollection.add(userEvents.toJson());

            Toast toast = Toast(
                ToastificationType.success,
                "Sport Event Joined",
                "See your event at Upcoming Events.",
                Icons.check,
                MyColors.support.success);
            toast.showToast();

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

  Future<List<SportEvent>?> fetchMyUpcomingSportEvents() async {
    final sportCollection = firebaseFirestore.collection("sport");
    final userSportEventCollection = firebaseFirestore.collection("user_event");
    final userId = authRepository.getCurrentUser().uid;

    try {
      final userEventQuerySnapshot = await userSportEventCollection
          .where("userId", isEqualTo: userId)
          .get();

      final sportIds = userEventQuerySnapshot.docs
          .map((doc) => doc.data()["sportEventId"] as String)
          .toList();

      if (sportIds.isEmpty) {
        return [];
      }

      final sportQuerySnapshot =
          await sportCollection.where("id", whereIn: sportIds).get();

      List<SportEvent> sportEvents = sportQuerySnapshot.docs
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

  Future<List<SportEvent>?> fetchMyWishlist() async {
    final sportCollection = firebaseFirestore.collection("sport");
    final userWishlist = firebaseFirestore.collection("wishlist");
    final userId = authRepository.getCurrentUser().uid;

    try {
      final userWishlistQuerySnapshot =
          await userWishlist.where("userId", isEqualTo: userId).get();

      final sportIds = userWishlistQuerySnapshot.docs
          .map((doc) => doc.data()["sportEventId"] as String)
          .toList();

      if (sportIds.isEmpty) {
        return [];
      }

      final sportQuerySnapshot =
          await sportCollection.where("id", whereIn: sportIds).get();

      List<SportEvent> sportEvents = sportQuerySnapshot.docs
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

  Future<void> addToWishlist(String sportEventId) async {
    final wishlistCollection = firebaseFirestore.collection("wishlist");
    final String userId = authRepository.getCurrentUser().uid;
    try {
      String wishlistId = wishlistCollection.doc().id;

      UserEvents userEvents = UserEvents(
          id: wishlistId, userId: userId, sportEventId: sportEventId);
      await wishlistCollection.add(userEvents.toJson());

      Toast toast = Toast(
        ToastificationType.success,
        "Added to Wishlist",
        "The event has been successfully added to your wishlist.",
        Icons.check_circle_outlined,
        MyColors.support.success,
      );
      toast.showToast();
    } catch (e) {
      Toast toast = Toast(
        ToastificationType.error,
        "An error occurred",
        e.toString(),
        Icons.dangerous_outlined,
        MyColors.support.error,
      );
      toast.showToast();
    }
  }


  Future<void> removeFromWishlist(String sportEventId) async {
    final wishlistCollection = firebaseFirestore.collection("wishlist");
    final String userId = authRepository.getCurrentUser().uid;

    try {
      final querySnapshot = await wishlistCollection
          .where("userId", isEqualTo: userId)
          .where("sportEventId", isEqualTo: sportEventId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        Toast toast = Toast(
          ToastificationType.success,
          "Removed from Wishlist",
          "The event has been successfully removed from your wishlist.",
          Icons.check_circle_outlined,
          MyColors.support.success,
        );
        toast.showToast();
      } else {
        Toast toast = Toast(
          ToastificationType.warning,
          "Not Found",
          "The event was not found in your wishlist.",
          Icons.warning_amber_outlined,
          MyColors.support.warning,
        );
        toast.showToast();
      }
    } catch (e) {
      Toast toast = Toast(
        ToastificationType.error,
        "An error occurred",
        e.toString(),
        Icons.dangerous_outlined,
        MyColors.support.error,
      );
      toast.showToast();
    }
  }

  Future<bool> checkWishlistStatus(String sportEventId) async{
    final wishlistCollection = firebaseFirestore.collection("wishlist");
    final String userId = authRepository.getCurrentUser().uid;

    final querySnapshot = await wishlistCollection
        .where("userId", isEqualTo: userId)
        .where("sportEventId", isEqualTo: sportEventId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

}
