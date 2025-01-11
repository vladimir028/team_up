import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_up/repository/auth_repository.dart';

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
}
