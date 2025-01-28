import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/repository/auth_repository.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../models/custom_user.dart';
import '../styles/my_colors.dart';

class SportEventRepository {
  final AuthRepository authRepository = AuthRepository();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> checkIfUserHasJoined(String sportEventId) async {
    final String userId = authRepository.getCurrentUser().uid;
    final userEventCollection = firebaseFirestore.collection("user_event");
    bool hasJoined = false;

    var existingUserEvent = await userEventCollection
        .where('userId', isEqualTo: userId)
        .where('sportEventId', isEqualTo: sportEventId)
        .get();

    return existingUserEvent.docs.isNotEmpty;
  }

  Future<CustomUser?> getOrganizer(String sportEventId) async{
    try {
      final sportDoc = await firebaseFirestore.collection("sport").doc(sportEventId).get();

      if (!sportDoc.exists) {
        Toast toast = Toast(
          ToastificationType.error,
          "Sport Event not found",
          "Error finding the sport event",
          Icons.dangerous_outlined,
          MyColors.support.error,
        );
        toast.showToast();
        return null;
      }

      final userId = sportDoc.data()?['userId'];
      if (userId == null) {
        Toast toast = Toast(
          ToastificationType.error,
          "No userId found in the sport event",
          "Error finding the organizer",
          Icons.dangerous_outlined,
          MyColors.support.error,
        );
        toast.showToast();
        return null;
      }

      final customUserDoc = await firebaseFirestore
          .collection("customUser")
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (customUserDoc.docs.isEmpty) {
        Toast toast = Toast(
          ToastificationType.error,
          "An error occurred",
          "No custom user found with userId: $userId",
          Icons.dangerous_outlined,
          MyColors.support.error,
        );
        toast.showToast();
        return null;
      }

      final userData = customUserDoc.docs.first;
      return CustomUser.fromSnapshot(userData);

    } catch (e) {
      Toast toast = Toast(
        ToastificationType.error,
        "An error occurred",
        "Error fetching organizer: $e",
        Icons.dangerous_outlined,
        MyColors.support.error,
      );
      toast.showToast();
      return null;
    }
  }
}
