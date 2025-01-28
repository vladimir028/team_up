import 'package:flutter/material.dart';
import 'package:team_up/presentation/pages/sport_event/wrapper/sport_event_page_layout.dart';

import '../../../../models/sport_event.dart';
import '../../../../service/sport_service.dart';

class MyWishlistPage extends StatefulWidget {
  const MyWishlistPage({super.key});

  @override
  State<MyWishlistPage> createState() => _MyWishlistPageState();
}

class _MyWishlistPageState extends State<MyWishlistPage> {
  List<SportEvent> sportEvents = [];
  bool isLoading = false;
  SportService sportService = SportService();
  final String message = "No events found in your wishlist.";
  final int pageNum = 2;

  @override
  void initState() {
    _fetchSportEvents();
    super.initState();
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

    List<SportEvent>? sportEventsFetched = await sportService.fetchMyWishlist();

    setState(() {
      isLoading = false;
      if (sportEventsFetched != null && sportEventsFetched.isNotEmpty) {
        sportEvents = sportEventsFetched;
      }
    });
  }
}
