import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/utils/helper_permission.dart';
import 'package:localin/utils/location_helper.dart';

class HomeProvider with ChangeNotifier {
  Position position;
  bool isLocationEnabled = false;
  var currentAddress = '';
  var listLatitude = [];
  var listLongitude = [];
  HelperPermission _permissionHelper = HelperPermission();
  GoogleMapController mapController;
  double latitude = 3.130236, longitude = 101.687618;
  Completer<GoogleMapController> controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();
  List<ArticleDetail> articleDetail = List();
  bool isRoomPage = false;
  String previewUrl = '';

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

//  Future<String> locationPermission() async {
//    //request runtime permission first
//    var isLocationPermissionGranted =
//        await _permissionHelper.getLocationPermission();
//    if (isLocationPermissionGranted) {
//      var checkGps = await geolocator.isLocationServiceEnabled();
//      return '';
//    } else {
//      return 'You need to grant permission for camera';
//    }
//  }

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    var response = await _repository.getCommunityList(search);
    if (response != null) {
      communityDetail.clear();
      communityDetail.addAll(response.communityDetail);
    }
    return response;
  }

  Future<List<ArticleDetail>> getArticleList(int offset, int limit) async {
    var response = await _repository.getArticleList(limit, offset);
    return response.data;
  }

  void setRoomPage(bool value) {
    this.isRoomPage = value;
    notifyListeners();
  }
}
