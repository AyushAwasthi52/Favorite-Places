import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/places_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No places added yet', style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(places[index].title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlacesDetails(place: places[index])));
        },
        subtitle: Text(places[index].location.address, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface,)),
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(places[index].image),
        ),
      )
    );
  }
}

//Padding(
//         padding: const EdgeInsets.all(16),
//         child: InkWell(
//           onTap: (){
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlacesDetails(title: places[index].title)));
//           },
//           child: Text(places[index].title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),),
//         ),
//       ),
