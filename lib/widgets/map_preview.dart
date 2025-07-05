import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return const Center(
        child: Text('No location chosen', textAlign: TextAlign.center),
      );
    }

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(latitude!, longitude!),
        initialZoom: 13.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude!, longitude!),
              width: 40,
              height: 40,
              alignment: Alignment.bottomCenter,
              child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
