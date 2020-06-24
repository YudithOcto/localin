import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_response_model.dart';

class CommunityEventProvider with ChangeNotifier {
  CommunityEventProvider(String communityId) {
    this._communityId = communityId;
  }
  final _repository = Repository();
  String _communityId;

  final _streamEvent = StreamController<eventState>.broadcast();
  Stream<eventState> get eventStream => _streamEvent.stream;

  bool _isMounted = true;

  bool _isUpcomingEventCanLoadMore = true;
  bool get isUpcomingEventCanLoadMore => _isUpcomingEventCanLoadMore;

  int _upcomingPageRequest = 1;
  int get upcomingPageRequest => _upcomingPageRequest;

  List<EventResponseData> _upcomingList = List();
  List<EventResponseData> get upcomingList => _upcomingList;

  Future<Null> getUpcomingEvent({bool isRefresh = true}) async {
    if (isRefresh) {
      _isUpcomingEventCanLoadMore = true;
      _upcomingPageRequest = 1;
      _upcomingList.clear();
    }
    setState(eventState.loading);
    final response = await _repository.getUpcomingEvent(
        _communityId, _upcomingPageRequest, 10);
    if (!response.error && response.total > 0) {
      _upcomingList.addAll(response.dataList);
      _isUpcomingEventCanLoadMore = response.total > _upcomingList.length;
      _upcomingPageRequest += 1;
      setState(eventState.success);
    } else {
      setState(_upcomingList.isEmpty ? eventState.empty : eventState.success);
      _isUpcomingEventCanLoadMore = false;
    }
    notifyListeners();
  }

  setState(eventState state) {
    if (_isMounted) {
      _streamEvent.add(state);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _streamEvent.close();
    super.dispose();
  }
}

enum eventState { loading, success, empty }
