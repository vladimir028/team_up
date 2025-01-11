import 'package:cloud_firestore/cloud_firestore.dart';

class UserEvents {
  final String id;
  final String userId;
  final String sportEventId;

  UserEvents(
      {required this.id, required this.userId, required this.sportEventId});

  static UserEvents fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserEvents(
        id: snapshot['id'],
        userId: snapshot['userId'],
        sportEventId: snapshot['sportEventId']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "sportEventId": sportEventId,
    };
  }
}
