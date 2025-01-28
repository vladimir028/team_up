import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/models/sport_event.dart';
import 'package:team_up/service/sport_event_service.dart';
import 'package:team_up/service/sport_service.dart';

import '../../../styles/my_colors.dart';
import '../../../styles/my_font_sizes.dart';

class SportDetailPage extends StatefulWidget {
  const SportDetailPage({super.key});

  @override
  State<SportDetailPage> createState() => _SportDetailPageState();
}

class _SportDetailPageState extends State<SportDetailPage> {
  late SportEvent sportEvent;
  late GoogleMapController mapController;
  final SportService sportService = SportService();
  final SportEventService sportEventService = SportEventService();
  late int missingPlayers;
  late int playersAsOfNow;
  String buttonText = "Join Event";
  bool hasJoined = false;
  bool isInWishlist = false;
  String organizer = "";
  final Set<Marker> _markers = {};
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sportEvent = ModalRoute.of(context)?.settings.arguments as SportEvent;

    missingPlayers = sportEvent.missingPlayers;
    playersAsOfNow = sportEvent.totalPlayersAsOfNow;

    _markers.add(
      Marker(
        markerId: const MarkerId('event_location'),
        position:
        LatLng(sportEvent.location.latitude, sportEvent.location.longitude),
        infoWindow: InfoWindow(title: sportEvent.sportName),
      ),
    );

    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    await _checkIfUserHasJoined(sportEvent.id);
    await _checkWishlistStatus(sportEvent.id);
    await _fetchOrganizer(sportEvent.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: MyColors.primary.pink500,
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  sportEvent.sportImageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: MyColors.dark),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: MyColors.dark,
                    ),
                    onPressed: () => _toggleWishlist(sportEvent.id),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          sportEvent.sportName,
                          style: const TextStyle(
                              fontSize: MyFontSizes.titleLarge,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${sportEvent.pricePerHour} ден/hr',
                        style: TextStyle(
                            fontSize: MyFontSizes.titleMedium,
                            color: MyColors.primary.pink500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: MyColors.dark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sportEvent.locationAddress,
                          style: const TextStyle(
                              fontSize: MyFontSizes.titleBase,
                              color: MyColors.gray),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: MyColors.dark),
                      const SizedBox(width: 8),
                      Text(
                        'Date: ${sportEvent.selectedDate.toLocal().toString().split(' ')[0]}',
                        style:
                        const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: MyColors.dark),
                      const SizedBox(width: 8),
                      Text(
                        'Time: ${sportEvent.startingTime.format(context)} - ${sportEvent.endingTime.format(context)}',
                        style:
                        const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Players: $playersAsOfNow',
                        style:
                        const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                      Text(
                        'Missing Players: $missingPlayers',
                        style: TextStyle(
                            fontSize: MyFontSizes.titleMedium,
                            color: MyColors.support.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Court Type
                  Row(
                    children: [
                      const Icon(Icons.sports, color: MyColors.dark),
                      const SizedBox(width: 8),
                      Text(
                        'Court Type: ${sportEvent.courtType.toString().split('.').last}',
                        style:
                        const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.supervised_user_circle, color: MyColors.dark),
                      const SizedBox(width: 8),
                      Text(
                        'Organized By: $organizer',
                        style:
                        const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Location',
                    style: TextStyle(
                        fontSize: MyFontSizes.titleMedium,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(sportEvent.location.latitude,
                            sportEvent.location.longitude),
                        zoom: 14,
                      ),
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasJoined
                        ? MyColors.gray
                        : MyColors.primary.pink500,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: hasJoined ? () => cancelEvent(sportEvent) : () => joinEvent(sportEvent),
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: MyFontSizes.titleMedium, color: hasJoined ? MyColors.dark : MyColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void joinEvent(SportEvent sportEvent) async {
    SportEvent? updatedSportEvent =
    await sportService.joinEvent(sportEvent, context);
    if (updatedSportEvent != null) {
      setState(() {
        sportEvent = updatedSportEvent;
        missingPlayers = updatedSportEvent.missingPlayers;
        playersAsOfNow = updatedSportEvent.totalPlayersAsOfNow;
      });
    }
    _checkIfUserHasJoined(sportEvent.id);
  }

  Future<void> _checkIfUserHasJoined(String sportEventId) async {
    bool isJoined = await sportEventService.checkIfUserHasJoined(sportEventId);
    setState(() {
      hasJoined = isJoined;
      buttonText = hasJoined ? "Leave Event" : "Join Event";
    });
  }

  void addToWishlist(String sportEventId) {
    sportService.addToWishlist(sportEventId);
  }

  void removeFromWishlist(String sportEventId) {
    sportService.removeFromWishlist(sportEventId);
  }

  Future<void> _toggleWishlist(String sportEventId) async {
    if (isInWishlist) {
      removeFromWishlist(sportEventId);
    } else {
      addToWishlist(sportEventId);
    }

    setState(() {
      isInWishlist = !isInWishlist;
    });
  }

  Future<void> _checkWishlistStatus(String sportEventId) async{
    bool result =await sportService.checkWishlistStatus(sportEventId);
    setState(() {
      isInWishlist = result;
    });
  }

  Future<void> _fetchOrganizer(String sportEventId) async{
    CustomUser? organizer = await sportEventService.getOrganizer(sportEventId);

    if (organizer != null) {
      setState(() {
        this.organizer = organizer.username;
      });
    }
  }

  cancelEvent(SportEvent sportEvent) async{
    SportEvent? updatedSportEvent =
        await sportService.cancelEvent(sportEvent, context);
    if (updatedSportEvent != null) {
      setState(() {
        sportEvent = updatedSportEvent;
        missingPlayers = updatedSportEvent.missingPlayers;
        playersAsOfNow = updatedSportEvent.totalPlayersAsOfNow;
      });
    }
    _checkIfUserHasJoined(sportEvent.id);
  }
}
