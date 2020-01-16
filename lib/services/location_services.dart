import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:localin/model/service/user_location.dart';

class LocationServices {
  UserLocation _userLocation;
  final Geolocator location = Geolocator()..forceAndroidLocationManager;

  LocationServices() {
    checkLocationPermission();
  }

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      final userLocation = await location.getCurrentPosition();
      _userLocation = UserLocation(
          latitude: userLocation.latitude, longitude: userLocation.longitude);
    } catch (error) {
      print(error);
    }
    return _userLocation;
  }

  checkLocationPermission() async {
    final permissionStatus = await location.checkGeolocationPermissionStatus();
    final isGpsOn = await location.isLocationServiceEnabled();

    if (permissionStatus == GeolocationStatus.granted) {
      if (isGpsOn) {
        location.getCurrentPosition().then((position) {
          _locationController.add(UserLocation(
              latitude: position?.latitude, longitude: position?.longitude));
        });
      } else {
        final lastKnownPosition = await location.getLastKnownPosition();
        if (lastKnownPosition != null) {
          _locationController.add(UserLocation(
              latitude: lastKnownPosition?.latitude,
              longitude: lastKnownPosition?.longitude));
        }
      }
    }
  }
}
