import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.location,
    required this.isSelecting,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  void _savePickedLocation() {
    if (_selectedLocation == null) return;

    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final initialLatLng = LatLng(widget.location.latitude, widget.location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedLocation == null ? null : _savePickedLocation,
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialLatLng,
          initialZoom: 16.0,
          onTap: widget.isSelecting
              ? (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          }
              : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              if (!widget.isSelecting)
                Marker(
                  point: initialLatLng,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              if (widget.isSelecting && _selectedLocation != null)
                Marker(
                  point: _selectedLocation!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
