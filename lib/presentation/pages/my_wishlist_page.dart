import 'package:flutter/material.dart';

import '../../models/sport_event.dart';
import '../../service/sport_service.dart';
import '../../styles/my_colors.dart';
import '../widgets/navigation_bottom.dart';
import '../widgets/sport_event_card.dart';

class MyWishlistPage extends StatefulWidget {
  const MyWishlistPage({super.key});

  @override
  State<MyWishlistPage> createState() => _MyWishlistPageState();
}

class _MyWishlistPageState extends State<MyWishlistPage> {
  List<SportEvent> sportEvents = [];
  bool isLoading = true;
  SportService sportService = SportService();

  @override
  void initState() {
    super.initState();
    _fetchSportEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset('lib/data/images/logo.png'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: MyColors.gray,
            thickness: 2,
            height: 1,
          ),
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : sportEvents.isEmpty
                ? const Center(
              child: Text(
                "No events found in your wishlist.",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.dark,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: sportEvents.length,
              itemBuilder: (context, index) {
                final sport = sportEvents[index];
                return SportEventCard(sport: sport);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBarBottom(
        currentPage: 2,
      ),
    );
  }

  void _fetchSportEvents() async {
    List<SportEvent>? sportEventsFetched = await sportService.fetchMyWishlist();

    setState(() {
      isLoading = false;
      if (sportEventsFetched != null && sportEventsFetched.isNotEmpty) {
        sportEvents = sportEventsFetched;
      }
    });
  }
}
