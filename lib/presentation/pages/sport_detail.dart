import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:team_up/models/sport_event.dart';

import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class SportDetailPage extends StatefulWidget {
  const SportDetailPage({super.key});

  @override
  State<SportDetailPage> createState() => _SportDetailPageState();
}

class _SportDetailPageState extends State<SportDetailPage> {
  late SportEvent sportEvent;
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sportEvent = ModalRoute.of(context)?.settings.arguments as SportEvent;

    _markers.add(
      Marker(
        markerId: const MarkerId('event_location'),
        position: LatLng(sportEvent.location.latitude, sportEvent.location.longitude),
        infoWindow: InfoWindow(title: sportEvent.sportName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: MyColors.dark),
                    onPressed: () {
                    //   TODO: Implement wishlist logic
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          sportEvent.sportName,
                          style: const TextStyle(fontSize: MyFontSizes.titleLarge, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${sportEvent.pricePerHour} ден/hr',
                        style: TextStyle(fontSize: MyFontSizes.titleMedium, color: MyColors.primary.pink500),
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
                          'Latitude: ${sportEvent.location.latitude}, Longitude: ${sportEvent.location.longitude}',
                          style:  const TextStyle(fontSize: MyFontSizes.titleBase, color: MyColors.gray),
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
                        style: const TextStyle(fontSize: MyFontSizes.titleMedium),
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
                        style: const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Players info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Players: ${sportEvent.totalPlayersAsOfNow}',
                        style: const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                      Text(
                        'Missing Players: ${sportEvent.missingPlayers}',
                        style: TextStyle(fontSize: MyFontSizes.titleMedium, color: MyColors.support.error),
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
                        style: const TextStyle(fontSize: MyFontSizes.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Location',
                    style: TextStyle(fontSize: MyFontSizes.titleMedium, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(sportEvent.location.latitude, sportEvent.location.longitude),
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
                    backgroundColor: MyColors.primary.pink500,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                  //  TODO: Implement logic for adding/subtracting number of players
                  },
                  child: const Text(
                    'Join Event',
                    style: TextStyle(fontSize: MyFontSizes.titleMedium, color: MyColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
