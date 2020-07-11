import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_detail_model.dart';

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

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum eventDetailState { loading, success, empty }
