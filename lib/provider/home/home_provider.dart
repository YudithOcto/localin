import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/utils/permission_helper.dart';

class HomeProvider with ChangeNotifier {
  Position position;
  bool isLocationEnabled = false;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  var currentAddress = '';
  var listLatitude = [];
  var listLongitude = [];
  PermissionHelper _permissionHelper = PermissionHelper();
  GoogleMapController mapController;
  double latitude = 3.130236, longitude = 101.687618;
  Completer<GoogleMapController> controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();

  HomeProvider() {
    checkLocation();
    locationPermission();
  }

  checkLocation() async {
    isLocationEnabled = await geolocator.isLocationServiceEnabled();
  }

  updateMarkerPosition(CameraPosition _position) {
    if (markers.length > 0) {
      final String markerIdVal = 'userMarker';
      final MarkerId markerId = MarkerId(markerIdVal);
      Marker marker = markers[markerId];
      Marker updatedMarker = marker.copyWith(
        positionParam: _position.target,
      );
      latitude = _position.target.latitude;
      longitude = _position.target.longitude;
      markers[markerId] = updatedMarker;
      notifyListeners();
    }
  }

  Future<String> locationPermission() async {
    //request runtime permission first
    var isCameraPermissionGranted =
        await _permissionHelper.getLocationPermission();
    if (isCameraPermissionGranted) {
      return '';
    } else {
      return 'You need to grant permission for camera';
    }
  }

  Future<CommunityDetailBaseResponse> getArticles() async {
    var response = await _repository.getCommunityList();
    if (response != null) {
      communityDetail.clear();
      communityDetail.addAll(response.communityDetail);
    }
    return response;
  }
}
