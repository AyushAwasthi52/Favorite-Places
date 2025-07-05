import 'package:favorite_places/providers/place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/screens/add_place.dart';


class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _FavoritePlacesState();
}

class _FavoritePlacesState extends ConsumerState<PlacesScreen> {

  late Future<void> _placeFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placeFuture = ref.read(placeProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {

    final places = ref.watch(placeProvider).where((p) => p.title!='').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPlace()));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(future: _placeFuture, builder: (context, snapshots) => snapshots.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : PlacesList(places: places)),
    );
  }
}
//PlacesList(places: places)