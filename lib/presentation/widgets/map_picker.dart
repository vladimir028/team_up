import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:team_up/api_key.dart';

import '../../models/location_data.dart';



class MapPicker extends StatefulWidget {
  static const DEFAULT_ZOOM = 14.4746;
  static const SKOPJE_LOCATION = LatLng(41.9981, 21.4254);

  final double initZoom;
  final LatLng initCoordinates;
  final Function(LocationData)? onLocationSelected;

  MapPicker({
    super.key,
    this.initZoom = DEFAULT_ZOOM,
    this.initCoordinates = SKOPJE_LOCATION,
    this.onLocationSelected,
  });

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  LatLng _currentCenter = MapPicker.SKOPJE_LOCATION;
  LocationData? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initCoordinates,
              zoom: widget.initZoom,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              _currentCenter = position.target;
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: false,
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 40,
              color: Colors.red,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _searchController,
                googleAPIKey: API_KEY,
                inputDecoration: const InputDecoration(
                  hintText: "Search for a location...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
                debounceTime: 800,
                countries: const ["mk"],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) async {
                  if (prediction.lat != null && prediction.lng != null) {
                    final locationData = LocationData(
                      name: prediction.description ?? "",
                      latitude: double.parse(prediction.lat!),
                      longitude: double.parse(prediction.lng!),
                    );

                    final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!)),
                          zoom: widget.initZoom,
                        ),
                      ),
                    );

                    setState(() {
                      _currentCenter = LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!));
                      _selectedLocation = locationData;
                    });

                    if (widget.onLocationSelected != null) {
                      widget.onLocationSelected!(locationData);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Location saved: ${prediction.description}"),
                      ),
                    );
                  }
                },
                itemClick: (Prediction prediction) {
                  _searchController.text = prediction.description ?? "";
                  _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _searchController.text.length),
                  );
                },
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(prediction.description ?? ""),
                        ),
                      ],
                    ),
                  );
                },
                seperatedBuilder: const Divider(),
                isCrossBtnShown: true,
                containerHorizontalPadding: 10,
                placeType: PlaceType.geocode,
              ),
            ),
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_selectedLocation!.name),
                    Text(
                      'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 30,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () async {
                var position = await _determinePosition();
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: widget.initZoom,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 100,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () =>
                  Navigator.popAndPushNamed(context, '/sport_create', arguments: _selectedLocation),
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}