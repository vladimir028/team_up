import 'package:flutter/material.dart';
import 'package:team_up/service/sport_service.dart';

import '../../data/account/sport_selection/sport.dart';
import '../../models/sport_event.dart';
import '../../styles/my_colors.dart';
import '../widgets/filter_sport_list.dart';
import '../widgets/navigation_bottom.dart';
import '../widgets/sport_event_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SportEvent> sportEvents = [];
  List<SportEvent> filteredSportEvents = [];

  List<Sport> selectedSports = [];

  List<Sport> selectedSportsFromRegistration = [];

  SportService sportService = SportService();

  @override
  void initState() {
    super.initState();
    _fetchSportEvents();
    _userSportPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('lib/data/images/logo.png')),
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: MyColors.gray,
            thickness: 2,
            height: 1,
          ),
          SizedBox(
            height: 100,
            child: FilterSportList(
                selectedSports: selectedSports,
                filterSportEvents: _filterSportEvents),
          ),
          sportEvents.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
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
        currentPage: 0,
      ),
    );
  }

  void _fetchSportEvents() async {
    List<SportEvent>? sportEventsFetched =
        await sportService.fetchSportEvents();

    if (sportEventsFetched != null) {
      setState(() {
        sportEvents = sportEventsFetched;
      });
    }
  }

  void _filterSportEvents() async {
    List<String> mappedSelectedSportsName =
        selectedSports.map((sport) => sport.name).toList();

    if (mappedSelectedSportsName.isEmpty) {
      _fetchSportEvents();
      return;
    }

    List<SportEvent>? sportEventsFiltered =
        await sportService.filterSportEvents(mappedSelectedSportsName);

    if (sportEventsFiltered != null) {
      setState(() {
        sportEvents = sportEventsFiltered;
      });
    }
  }

  void _userSportPreferences() async {
    List<Sport>? usersFavSports = await sportService.getUserPreferredSports();
    if (usersFavSports != null) {
      setState(() {
        selectedSportsFromRegistration = usersFavSports;
      });
    }
  }
}
