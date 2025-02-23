import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:team_up/api_key.dart';

import '../../models/location_data.dart';

class MapPicker extends StatefulWidget {
  static const DEFAULT_ZOOM = 14.4746;
  static const SKOPJE_LOCATION = LatLng(41.9981, 21.4254);

  final double initZoom;
  final LatLng initCoordinates;
  final Function(LocationData)? onLocationSelected;

  const MapPicker({
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
  final TextEditingController _searchController = TextEditingController();
  LatLng? _selectedCoordinates;
  String? _selectedName;
  Marker? _activeMarker = const Marker(
    markerId: MarkerId("default-location"),
    position: MapPicker.SKOPJE_LOCATION,
    infoWindow: InfoWindow(title: "Default Location"),
  );

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
            onTap: _onMapTapped,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _activeMarker != null ? {_activeMarker!} : {},
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
                  final lat = double.parse(prediction.lat ?? "0");
                  final lng = double.parse(prediction.lng ?? "0");
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: widget.initZoom,
                  )));

                  setState(() {
                    _selectedCoordinates = LatLng(lat, lng);
                    _selectedName = prediction.description;
                    _activeMarker = Marker(
                      markerId: const MarkerId("selected-location"),
                      position: _selectedCoordinates!,
                      infoWindow: InfoWindow(title: _selectedName),
                    );
                  });
                  _notifyLocationSelected();
                },
                itemClick: (Prediction prediction) {
                  _searchController.text = prediction.description ?? "";
                  _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _searchController.text.length),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 100,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: _saveLocation,
              child: const Icon(Icons.check),
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

  void _onMapTapped(LatLng coordinates) {
    setState(() {
      _selectedCoordinates = coordinates;
      _selectedName = null;
      _activeMarker = Marker(
        markerId: const MarkerId("selected-location"),
        position: coordinates,
      );
    });
    _notifyLocationSelected();
  }

  Future<void> _goToCurrentLocation() async {
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
  }

  void _saveLocation() {
    Navigator.popAndPushNamed(
      context,
      '/sport_create',
      arguments: _selectedCoordinates != null
          ? LocationData(
              name: _selectedName ?? "",
              latitude: _selectedCoordinates!.latitude,
              longitude: _selectedCoordinates!.longitude,
            )
          : null,
    );
  }

  void _notifyLocationSelected() {
    if (widget.onLocationSelected != null && _selectedCoordinates != null) {
      widget.onLocationSelected!(
        LocationData(
          name: _selectedName ?? "",
          latitude: _selectedCoordinates!.latitude,
          longitude: _selectedCoordinates!.longitude,
        ),
      );
    }
  }
}
