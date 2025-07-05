import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerWidget {

  const AddPlace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var title = "";

    File? image;
    PlaceLocation? location;

    void setImage(File imageUrl){
      image = imageUrl;
    }

    void setLocation(PlaceLocation loc){
      location = loc;
    }

    final formKey = GlobalKey<FormState>();

    void savePlace(){
      if (formKey.currentState!.validate()){
        formKey.currentState!.save();
      }

      if (image == null) {
        return;
      }

      if (location == null){
        return;
      }

      final place = Place(title: title, image: image!, location: location!);
      ref.read(placeProvider.notifier).addPlace(place);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('Title')
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().length <=1 || value.trim().length > 50){
                      return 'The value should be between 0 and 50 characters.';
                    }
                    else {
                      return null;
                    }
                  },
                  onSaved: (value){
                    title = value!;
                  },
                ),
                const SizedBox(height: 10,),
                ImageInput(setImage: setImage,),
                const SizedBox(height: 10,),
                LocationInput(setLocation: setLocation,),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: savePlace,
                  icon: Icon(Icons.add),
                  label: Text('Add Place'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
