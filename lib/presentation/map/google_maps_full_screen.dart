import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/themes.dart';

class GoogleMapFullScreen extends StatefulWidget {
  static const routeName = 'GoogleMapPage';
  static const targetLocation = 'targetLocation';
  @override
  _GoogleMapFullScreenState createState() => _GoogleMapFullScreenState();
}

class _GoogleMapFullScreenState extends State<GoogleMapFullScreen> {
  GoogleMapController mapController;
  double latitude = -6.121435, longitude = 106.774124;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isLocationEnabled = false;
  String currentAddress = '';
  Address address;
  bool isInit = true;
  bool isFromHotel = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      UserLocation location =
          routeArgs[GoogleMapFullScreen.targetLocation] ?? null;
      if (location != null) {
        latitude = location?.latitude;
        longitude = location?.longitude;
        createMarker();
        _getAddressFromLatLng();
        isFromHotel = true;
      } else {
        getLocation();
      }
      isInit = false;
    }
  }

  void getLocation() async {
    isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    }

    setState(() {
      createMarker();
      _getAddressFromLatLng();
    });
  }

  createMarker() {
    final String markerIdVal = 'userMarker';
    final MarkerId markerId = MarkerId(markerIdVal);

    if (mapController != null) {
      mapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    }
    final Marker marker = Marker(
        draggable: true,
        markerId: markerId,
        infoWindow:
            InfoWindow(title: '$currentAddress', snippet: '$currentAddress'),
        position: LatLng(latitude, longitude));
    markers[markerId] = marker;
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
    return SafeArea(
      child: Scaffold(
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
                if (!isFromHotel) {
                  updateMarkerPosition(_position);
                }
              }),
              onCameraIdle: (() {
                setState(() {
                  _getAddressFromLatLng();
                });
              }),
              initialCameraPosition: CameraPosition(
                  bearing: 15.0,
                  zoom: 15.0,
                  target: LatLng(latitude != null ? latitude : 0,
                      longitude != null ? longitude : 0)),
              markers: Set<Marker>.of(markers.values),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
            Positioned(
              top: 50.0,
              left: 25.0,
              right: 25.0,
              child: Visibility(
                visible: !isFromHotel,
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
            ),
            Positioned(
              bottom: 0.0,
              left: 20.0,
              right: 20.0,
              child: Visibility(
                visible: !isFromHotel,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(address);
                  },
                  color: ThemeColors.primaryBlue,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
