import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_response_model.dart';

class CommunityDetailEventProvider with ChangeNotifier {
  final _repository = Repository();
  CommunityDetailEventProvider({@required String comId})
      : assert(comId != null),
        _communityId = comId;
  String _communityId = '';

  bool _isUpcomingEventCanLoadMore = true;
  bool get isUpcomingEventCanLoadMore => _isUpcomingEventCanLoadMore;

  int _upcomingPageRequest = 1;
  int get upcomingPageRequest => _upcomingPageRequest;

  List<EventResponseData> _upcomingList = List();
  List<EventResponseData> get upcomingList => _upcomingList;

  final _streamEvent = StreamController<listEventState>.broadcast();
  Stream<listEventState> get eventStream => _streamEvent.stream;

  Future<Null> getUpcomingEvent({bool isRefresh = true}) async {
    if (isRefresh) {
      _isUpcomingEventCanLoadMore = true;
      _upcomingPageRequest = 1;
      _upcomingList.clear();
    }
    setState(listEventState.loading);
    final response = await _repository.getUpcomingEvent(
        _communityId, _upcomingPageRequest, 10);
    if (!response.error && response.total > 0) {
      _upcomingList.addAll(response.dataList.take(5));
      _isUpcomingEventCanLoadMore = response.total > _upcomingList.length;
      _upcomingPageRequest += 1;
      setState(listEventState.success);
    } else {
      setState(_upcomingList.isEmpty
          ? listEventState.empty
          : listEventState.success);
      _isUpcomingEventCanLoadMore = false;
    }
    notifyListeners();
  }

  bool _isMounted = true;

  setState(listEventState state) {
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

enum listEventState { loading, success, empty }
