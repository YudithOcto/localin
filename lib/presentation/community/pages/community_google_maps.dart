import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/themes.dart';

class CommunityGoogleMaps extends StatefulWidget {
  static const routeName = '/googlemaps';
  @override
  _CommunityGoogleMapsState createState() => _CommunityGoogleMapsState();
}

class _CommunityGoogleMapsState extends State<CommunityGoogleMaps> {
  GoogleMapController mapController;
  double latitude = -6.121435, longitude = 106.774124;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isLocationEnabled = false;
  String currentAddress = '';
  Address address;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    final String markerIdVal = 'userMarker';
    final MarkerId markerId = MarkerId(markerIdVal);
    if (isLocationEnabled) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    }

    setState(() {
      if (mapController != null) {
        mapController
            .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
      }
      final Marker marker = Marker(
          draggable: true,
          markerId: markerId,
          position: LatLng(latitude, longitude));
      markers[markerId] = marker;
    });
  }

  updateMarkerPosition(CameraPosition _position) {
    if (markers.length > 0) {
      final String markerIdVal = 'userMarker';
      final MarkerId markerId = MarkerId(markerIdVal);
      Marker marker = markers[markerId];
      Marker updatedMarker = marker.copyWith(
        positionParam: _position.target,
      );
      setState(() {
        latitude = _position.target.latitude;
        longitude = _position.target.longitude;
        markers[markerId] = updatedMarker;
      });
    }
  }

  Future<String> _getAddressFromLatLng() async {
    try {
      Coordinates coordinates = Coordinates(latitude, longitude);
      try {
        var result =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        address = result.first;
        currentAddress = '${address.locality}, ${address.subAdminArea}';
      } catch (error) {
        print(error);
      }
      return currentAddress;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _controller.complete(controller);
            },
            myLocationEnabled: isLocationEnabled,
            mapType: MapType.normal,
            onCameraMove: ((_position) {
              updateMarkerPosition(_position);
            }),
            onCameraIdle: (() {
              _getAddressFromLatLng();
            }),
            initialCameraPosition: CameraPosition(
                bearing: 15.0,
                zoom: 15.0,
                target: LatLng(latitude != null ? latitude : 0,
                    longitude != null ? longitude : 0)),
            markers: Set<Marker>.of(markers.values),
          ),
          Positioned(
            top: 50.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                color: Colors.white,
                elevation: 5.0,
                onPressed: () async {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                child: Text(
                  '$currentAddress',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 20.0,
            right: 20.0,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(address);
              },
              color: Themes.primaryBlue,
              child: Text(
                'Apply',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
