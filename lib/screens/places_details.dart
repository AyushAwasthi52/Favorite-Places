import 'package:favorite_places/widgets/map_preview.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlacesDetails extends StatelessWidget {
  const PlacesDetails({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  child: ClipOval(
                      child: SizedBox(
                        width: 144,
                        height: 144,
                        child: MapPreview(
                          latitude: place.location.latitude,
                          longitude: place.location.longitude,
                        ),
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.transparent, Colors.black54], begin: Alignment.topLeft, end:  Alignment.bottomRight),
                  ),
                  child: Text(place.location.address, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
