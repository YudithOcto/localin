import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_member_response.dart';

import '../../enums.dart';

class CommunityEventGoingMemberProvider with ChangeNotifier {
  final _repository = Repository();
  final _streamController = StreamController<eventMemberState>.broadcast();

  Stream<eventMemberState> get eventMemberStream => _streamController.stream;
  bool _isMounted = true;

  bool _isOngoingMemberCanLoadMore = true;

  bool get isOngoingMemberCanLoadMore => _isOngoingMemberCanLoadMore;

  List<EventMemberDetail> _memberListDetail = List();

  List<EventMemberDetail> get memberListDetail => _memberListDetail;

  int _pageRequest = 1;

  int get pageRequest => _pageRequest;

  Future<Null> getMemberOnGoing(String eventId, {bool isRefresh = true}) async {
    if (isRefresh) {
      _isOngoingMemberCanLoadMore = true;
      _memberListDetail.clear();
      _pageRequest = 1;
    }
    final response = await _repository.getMemberEventByType(
        'hadir', eventId, _pageRequest, 10);
    if (!response.error && response.total > 0) {
      _memberListDetail.addAll(response.memberList);
      _pageRequest += 1;
      _isOngoingMemberCanLoadMore = response.total > _memberListDetail.length;
      setState(eventMemberState.success);
    } else {
      _isOngoingMemberCanLoadMore = false;
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
