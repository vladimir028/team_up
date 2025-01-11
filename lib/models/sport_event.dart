import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/models/enum/court_type.dart';

class SportEvent {
  final String id;
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
      required this.courtType,
      required this.id});

  static SportEvent fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return SportEvent(
      id: snapshot['id'],
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sportName": sportName,
      "sportImageUrl": sportImageUrl,
      "duration": duration,
      "pricePerHour": pricePerHour,
      "totalPlayersAsOfNow": totalPlayersAsOfNow,
      "missingPlayers": missingPlayers,
      "userId": userId,
      'location': location,
      "startingTime": castToString(startingTime),
      "endingTime": castToString(endingTime),
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

  static castToString(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }
}
