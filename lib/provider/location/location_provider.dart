import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';

class LocationProvider with ChangeNotifier {
  Coordinates _coordinates = Coordinates(0.0, 0.0);
  String _address = '';
  bool _isLocationEnabled = false;
  final Geolocator _locationManager = Geolocator()..forceAndroidLocationManager;
  final Repository _apiRepository = Repository();

  Future<bool> getUserLocation() async {
    try {
      final isEnabled = await _locationManager.isLocationServiceEnabled();
      if (isEnabled != null && isEnabled) {
        _isLocationEnabled = true;
        final position = await _locationManager.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        if (position != null) {
          _coordinates = Coordinates(position.latitude, position.longitude);
        }
        final findAddress =
            await Geocoder.local.findAddressesFromCoordinates(_coordinates);
        _address =
            '${findAddress.first.locality ?? ''}, ${findAddress.first.subAdminArea}';
        updateUserLocation(position.latitude.toString(),
            position.longitude.toString(), _address);
      } else {
        _isLocationEnabled = false;
      }
      notifyListeners();
      return true;
    } catch (error) {
      _isLocationEnabled = false;
      print(error);
      return false;
    }
  }

  Future<UserBaseModel> updateUserLocation(
      String latitude, String longitude, String address) async {
    return await _apiRepository.updateUserLoction(latitude, longitude, address);
  }

  String get address => _address;
  bool get isLocationEnabled => _isLocationEnabled;
  Coordinates get userCoordinates => _coordinates;
}
