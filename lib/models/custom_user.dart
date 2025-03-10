import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String id;
  final String username;
  final String profilePicture;
  final Map<String, int> favoriteSportWithLevel;

  CustomUser(
      {required this.id,
      required this.username,
      required this.profilePicture,
      required this.favoriteSportWithLevel});

  static CustomUser fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CustomUser(
        id: snapshot['id'],
        username: snapshot['username'],
        profilePicture: snapshot['profilePicture'],
        favoriteSportWithLevel: castExplicitly(snapshot['favoriteSportWithLevel']));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "profilePicture": profilePicture,
      "favoriteSportWithLevel": favoriteSportWithLevel,
    };
  }

  static castExplicitly(snapshot) {
    Map<String, int> favoriteSportWithLevel = {};
    snapshot.forEach((key, value) {
      if (value is int) {
        favoriteSportWithLevel[key] = value;
      }
    });
    return favoriteSportWithLevel;
  }
}
