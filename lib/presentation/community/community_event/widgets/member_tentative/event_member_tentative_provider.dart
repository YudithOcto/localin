import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_member_response.dart';

import '../../enums.dart';

class EventMemberTentativeProvider with ChangeNotifier {
  final _repository = Repository();
  final _streamController = StreamController<eventMemberState>.broadcast();
  Stream<eventMemberState> get eventMemberStream => _streamController.stream;
  bool _isMounted = true;

  bool _isEventTentativeCanLoadMore = true;
  bool get isEventTentativeCanLoadMore => _isEventTentativeCanLoadMore;

  List<EventMemberDetail> _memberTentativeList = List();
  List<EventMemberDetail> get memberTentativeList => _memberTentativeList;

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  Future<Null> getTentativeMember(String eventId,
      {bool isRefresh = true}) async {
    if (isRefresh) {
      _isEventTentativeCanLoadMore = true;
      _memberTentativeList.clear();
      _pageRequest = 1;
    }
    final response = await _repository.getMemberEventByType(
        'tentative', eventId, _pageRequest, 10);
    if (!response.error && response.total > 0) {
      _memberTentativeList.addAll(response.memberList);
      _pageRequest += 1;
      _isEventTentativeCanLoadMore =
          response.total > _memberTentativeList.length;
      setState(eventMemberState.success);
    } else {
      _isEventTentativeCanLoadMore = false;
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
