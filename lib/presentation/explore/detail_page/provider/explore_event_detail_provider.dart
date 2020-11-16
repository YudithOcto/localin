import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/api/explore_last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_detail.dart';
import 'package:localin/model/explore/explore_event_local_model.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/image_helper.dart';

class ExploreEventDetailProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController = StreamController<eventDetailState>.broadcast();

  Stream<eventDetailState> get stream => _streamController.stream;

  ExploreEventDetail _eventDetail = ExploreEventDetail();

  ExploreEventDetail get eventDetail => _eventDetail;

  Future<Null> getEventDetail(int eventID) async {
    final result = await _repository.getExploreEventDetail(eventID);
    if (result != null && result.error == false) {
      _eventDetail = result.detail;
      addToSearchLocal(ExploreEventLocalModel(
          title: _eventDetail.eventName,
          subtitle: eventDetail.category.isNotNullNorEmpty
              ? eventDetail.category.first.categoryName
              : '',
          category: '',
          timeStamp: DateTime.now().toIso8601String()));
      _streamController.add(eventDetailState.success);
    } else {
      _streamController.add(eventDetailState.empty);
    }
    getMarker();
    notifyListeners();
  }

  getFormattedStartDateTime() {
    if (_eventDetail.startDate == null) return '';
    String date = DateHelper.formatDate(
        date: _eventDetail.startDate, format: "EEEE, dd MMMM yyyy 'at' hh:mm");
    return date;
  }

  getFormattedEndDateTime() {
    if (_eventDetail.endDate == null) return '';
    String date = DateHelper.formatDate(
        date: _eventDetail.endDate, format: "EEEE, dd MMMM yyyy 'at' HH:mm");
    return date;
  }

  get locationLatitude {
    if (eventDetail != null && eventDetail.schedules.isNotNullNorEmpty) {
      return eventDetail?.schedules[0]?.location?.latitude;
    }
    return 0.0;
  }

  get locationLongitude {
    if (eventDetail != null && eventDetail.schedules.isNotNullNorEmpty) {
      return eventDetail?.schedules[0]?.location?.longitude;
    }
    return 0.0;
  }

  String get eventLocation {
    if (eventDetail != null && eventDetail.schedules.isNotNullNorEmpty) {
      return eventDetail?.schedules[0]?.location?.address;
    }
    return '';
  }

  List<Marker> markers = [];
  Uint8List markerIcon;

  getMarker() async {
    markerIcon =
        await ImageHelper.getBytesFromAsset('images/location_marker.png', 150);
    final marker = Marker(
      position: LatLng(locationLatitude, locationLongitude),
      markerId: MarkerId(_eventDetail?.eventName),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    markers.add(marker);
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  final ExploreLastSearchDao _exploreLastSearchDao = ExploreLastSearchDao();

  Future<int> addToSearchLocal(ExploreEventLocalModel exploreLocalModel) async {
    final result = await _exploreLastSearchDao.insert(exploreLocalModel);
    return result;
  }
}

enum eventDetailState { loading, success, empty }

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
