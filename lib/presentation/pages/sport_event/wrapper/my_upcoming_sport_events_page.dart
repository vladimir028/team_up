import 'package:flutter/material.dart';
import 'package:team_up/presentation/pages/sport_event/wrapper/sport_event_page_layout.dart';

import '../../../../models/sport_event.dart';
import '../../../../service/sport_service.dart';

class MyUpcomingSportEventsPage extends StatefulWidget {
  const MyUpcomingSportEventsPage({super.key});

  @override
  State<MyUpcomingSportEventsPage> createState() => _MyUpcomingSportEventsPageState();
}

class _MyUpcomingSportEventsPageState extends State<MyUpcomingSportEventsPage> {

  List<SportEvent> sportEvents = [];
  bool isLoading = false;
  SportService sportService = SportService();
  final String message = "You haven't joined any sport event!";
  final int pageNum = 1;

  @override
  void initState() {
    super.initState();
    _fetchSportEvents();
  }
  @override
  Widget build(BuildContext context) {
    return SportEventPageLayout(
      sportEvents: sportEvents,
      pageNum: pageNum,
      fetchData: _fetchSportEvents,
      message: message,
      isLoading: isLoading
    );
  }

  Future<void> _fetchSportEvents() async {
    setState(() {
      isLoading = true;
    });

    List<SportEvent>? sportEventsFetched =
    await sportService.fetchMyUpcomingSportEvents();

    setState(() {
      isLoading = false;
      if (sportEventsFetched != null && sportEventsFetched.isNotEmpty) {
        sportEvents = sportEventsFetched;
      }
    });
  }
}
