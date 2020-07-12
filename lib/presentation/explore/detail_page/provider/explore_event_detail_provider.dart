import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_detail_model.dart';
import 'package:localin/utils/date_helper.dart';

class ExploreEventDetailProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController = StreamController<eventDetailState>.broadcast();
  Stream<eventDetailState> get stream => _streamController.stream;

  ExploreEventDetail _eventDetail = ExploreEventDetail();
  ExploreEventDetail get eventDetail => _eventDetail;

  Future<Null> getEventDetail(int eventID) async {
    final result = await _repository.getExploreEventDetail(eventID);
    if (result != null && result.error == false) {
      _streamController.add(eventDetailState.success);
      _eventDetail = result.detail;
    } else {
      _streamController.add(eventDetailState.empty);
    }
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
    if (eventDetail != null && eventDetail.schedules != null) {
      return eventDetail?.schedules[0]?.location?.latitude;
    }
    return 0.0;
  }

  get locationLongitude {
    if (eventDetail != null && eventDetail.schedules != null) {
      return eventDetail?.schedules[0]?.location?.longitude;
    }
    return 0.0;
  }

  get eventLocation {
    if (eventDetail != null && eventDetail.schedules != null) {
      return eventDetail?.schedules[0]?.location?.address;
    }
    return '';
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum eventDetailState { loading, success, empty }
