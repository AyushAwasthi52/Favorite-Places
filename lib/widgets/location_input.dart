import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:favorite_places/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.setLocation});

  final void Function(PlaceLocation) setLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  PlaceLocation? _pickedLocation;
  double? la, lo;

  bool _isLocating = false;

  void pickLocation() async {
    final selectedLatLng = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          location: PlaceLocation(
            latitude: 37.422, // any default value
            longitude: -122.084,
            address: '',
          ),
          isSelecting: true,
        ),
      ),
    );

    if (selectedLatLng == null) {
      return;
    }

    double? lat = selectedLatLng.latitude;
    double? lng = selectedLatLng.longitude;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng',
    );
    final response = await http.get(url);

    final resData = json.decode(response.body);

    final address = resData['display_name'];


    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: address);
      la = lat;
      lo = lng;
    });

    widget.setLocation(_pickedLocation!);

  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isLocating = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null){
      return;
    }

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng',
    );
    final response = await http.get(url);

    final resData = json.decode(response.body);

    final address = resData['display_name'];


    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: address);
      la = lat;
      lo = lng;
      _isLocating = false;
    });

    widget.setLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('No location chosen', textAlign: TextAlign.center,);

    if (_isLocating) {
      content = const CircularProgressIndicator();
    }

    if (_pickedLocation != null){
      content = MapPreview(latitude: la, longitude: lo);
    }

    return Column(
      children: [
        Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            ),
            alignment: Alignment.center,
            child: content
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Get current location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Choose location from map'),
              onPressed: pickLocation,
            )
          ],
        )
      ],
    );
  }
}
