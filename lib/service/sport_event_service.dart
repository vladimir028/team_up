import 'package:team_up/models/custom_user.dart';
import 'package:team_up/repository/sport_event_repository.dart';

class SportEventService {
  final SportEventRepository sportEventRepository = SportEventRepository();

  Future<bool> checkIfUserHasJoined(String sportEventId) async{
    return await sportEventRepository.checkIfUserHasJoined(sportEventId);
  }

  Future<CustomUser?> getOrganizer(String sportEventId) async{
    return await sportEventRepository.getOrganizer(sportEventId);
  }
}