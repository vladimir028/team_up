import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/models/enum/court_type.dart';

class SportEvent {
  final String sportName;
  final String sportImageUrl;
  final int duration;
  final int pricePerHour;
  final int totalPlayersAsOfNow;
  final int missingPlayers;
  final String userId;
  final GeoPoint location;
  final TimeOfDay startingTime;
  final TimeOfDay endingTime;
  final DateTime selectedDate;
  final CourtType courtType;

  SportEvent(
      {required this.sportName,
      required this.sportImageUrl,
      required this.duration,
      required this.pricePerHour,
      required this.totalPlayersAsOfNow,
      required this.missingPlayers,
      required this.userId,
      required this.location,
      required this.startingTime,
      required this.endingTime,
      required this.selectedDate,
      required this.courtType});

  static SportEvent fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return SportEvent(
      sportName: snapshot['sportName'],
      sportImageUrl: snapshot['sportImageUrl'],
      duration: snapshot['duration'],
      pricePerHour: snapshot['pricePerHour'],
      totalPlayersAsOfNow: snapshot['totalPlayersAsOfNow'],
      missingPlayers: snapshot['missingPlayers'],
      userId: snapshot['userId'],
      location: snapshot['location'],
      startingTime: castToTimeOfDay(snapshot['startingTime']),
      endingTime: castToTimeOfDay(snapshot['endingTime']),
      selectedDate: (snapshot['selectedDate'] as Timestamp).toDate(),
      courtType: castToEnum(snapshot['courtType']),
    );
  }

  Map<String, dynamic> toJson(BuildContext context) {
    return {
      "sportName": sportName,
      "sportImageUrl": sportImageUrl,
      "duration": duration,
      "pricePerHour": pricePerHour,
      "totalPlayersAsOfNow": totalPlayersAsOfNow,
      "missingPlayers": missingPlayers,
      "userId": userId,
      'location': location,
      "startingTime": startingTime.format(context),
      "endingTime": endingTime.format(context),
      "selectedDate": selectedDate,
      "courtType": courtType.toString().split('.').last,
    };
  }

  static castToTimeOfDay(snapshot) {
    return TimeOfDay(
        hour: int.parse(snapshot.split(":")[0]),
        minute: int.parse(snapshot.split(":")[1]));
  }

  static castToEnum(snapshot) {
    return CourtType.values
        .firstWhere((e) => e.toString() == 'CourtType.$snapshot');
  }
}
