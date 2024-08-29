import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';

class LocationProvider with ChangeNotifier {
  Coordinates _coordinates = Coordinates(0.0, 0.0);
  String _address = '';
  final Repository _apiRepository = Repository();

  /// only once update location
  bool _isAlreadyUpdateUserLocation = false;

  Future<UserBaseModel> updateUserLocation(bool isRefresh) async {
    if (!isRefresh && _isAlreadyUpdateUserLocation) {
      return null;
    }
    try {
      final position = await Geolocator.getCurrentPosition();
      if (position != null) {
        _coordinates = Coordinates(position.latitude, position.longitude);
        final getAddress =
            await Geocoder.local.findAddressesFromCoordinates(_coordinates);
        _address =
            '${getAddress.first.locality ?? ''}, ${getAddress.first.subAdminArea}';
        final result = await _apiRepository.updateUserLocation(
            position.latitude.toString(),
            position.longitude.toString(),
            _address);
        _isAlreadyUpdateUserLocation = true;
        return result;
      }
      return null;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<bool> checkUserPermission() async {
    /// Check permission first
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return true;
        break;
      case LocationPermission.deniedForever:
      case LocationPermission.denied:
      default:
        return false;
        break;
    }
  }

  /// this method to show current address to some pages.
  String get address => _address;

  Coordinates get userCoordinates => _coordinates;
}
