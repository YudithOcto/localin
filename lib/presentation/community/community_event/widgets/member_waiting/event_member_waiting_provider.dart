import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_member_response.dart';

import '../../enums.dart';

class EventMemberWaitingProvider with ChangeNotifier {
  final _repository = Repository();
  final _streamController = StreamController<eventMemberState>.broadcast();

  Stream<eventMemberState> get eventMemberStream => _streamController.stream;
  bool _isMounted = true;

  bool _isEventWaitingCanLoadMore = true;

  bool get isEventWaitingCanLoadMore => _isEventWaitingCanLoadMore;

  List<EventMemberDetail> _memberWaitingList = List();

  List<EventMemberDetail> get memberWaitingList => _memberWaitingList;

  int _pageRequest = 1;

  int get pageRequest => _pageRequest;

  Future<Null> getMemberWaitingList(String eventId,
      {bool isRefresh = true}) async {
    if (isRefresh) {
      _isEventWaitingCanLoadMore = true;
      _memberWaitingList.clear();
      _pageRequest = 1;
    }
    final response = await _repository.getMemberEventByType(
        'waiting', eventId, _pageRequest, 10);
    if (!response.error && response.total > 0) {
      _memberWaitingList.addAll(response.memberList);
      _pageRequest += 1;
      _isEventWaitingCanLoadMore = response.total > _memberWaitingList.length;
      setState(eventMemberState.success);
    } else {
      _isEventWaitingCanLoadMore = false;
      setState(eventMemberState.empty);
    }
    notifyListeners();
  }

  void setState(eventMemberState state) {
    if (_isMounted) {
      _streamController.add(state);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _streamController.close();
    super.dispose();
  }
}
