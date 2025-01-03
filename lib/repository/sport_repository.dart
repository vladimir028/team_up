import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../models/sport_event.dart';
import '../styles/my_colors.dart';

class SportRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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



}