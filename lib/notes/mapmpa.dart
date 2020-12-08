import 'dart:async';

import 'package:alarm_recorder/notes/add_note.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  double latt =0;
  double longg =0;
  static LatLng _initialPosition=LatLng(37.42796133580664,-122.085749655962);
  static final CameraPosition _kGooglePlex = CameraPosition(target:LatLng(37.42796133580664,-122.085749655962), zoom: 15);
List<Marker> allMarker =[];
  @override
  void initState() {
    super.initState();
    _getUserLocation();

  }


  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await  placemarkFromCoordinates(position.latitude,position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
    allMarker.add(Marker(
        markerId: MarkerId("myMarker"),
        draggable: false,
        position: LatLng(position.latitude, position.longitude)
    ));

  }
  static final CameraPosition _current = CameraPosition(
      target: _initialPosition,
      zoom: 15
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(allMarker),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _currentLocation,
        label: Text('to the Current Position!'),
        icon: Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_current)).whenComplete(() {
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
            return AddNotes(false, false, true);
          }));
        });

    });

    // if(mounted) {
    //   Future.delayed(Duration(second: 10000)).then(
    //           (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
    //         return AddNotes(false, false, true);
    //       })));
    // }

  }
}
