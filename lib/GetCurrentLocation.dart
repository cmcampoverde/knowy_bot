import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class GetCurrentLocation extends StatefulWidget {
  @override
  State<GetCurrentLocation> createState() => _GetCurrentLocation();
}

class _GetCurrentLocation extends State<GetCurrentLocation> {
  static String currentCity;
  final Map<String, Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double lat=-0.22985, long=-78.5249481;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }
  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    var currentAddress = await _getAddress(currentLocation);
    await _moveToPosition(currentLocation);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: currentAddress),
      );
      _markers["Current Location"] = marker;
    });
  }

  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      currentCity=pos.locality;
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  Future<void> _moveToPosition(Position pos) async {
    final GoogleMapController mapController = await _controller.future;
    if(mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 15.0,
        )
    )
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat,long),
          zoom: 11,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }
}