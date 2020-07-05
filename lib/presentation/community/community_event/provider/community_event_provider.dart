import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_request_model.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

const EVENT_EDIT = 'Edit';
const EVENT_REMOVE = 'Remove';
const EVENT_CANCEL = 'Cancel';

class CommunityEventProvider with ChangeNotifier {
  CommunityEventProvider(String communityId) {
    this._communityId = communityId;
  }
  final _repository = Repository();
  String _communityId;

  final _streamEvent = StreamController<eventState>.broadcast();
  final _pastStreamEvent = StreamController<eventState>.broadcast();
  Stream<eventState> get eventStream => _streamEvent.stream;
  Stream<eventState> get pastStream => _pastStreamEvent.stream;

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

  bool _isPastEventCanLoadMore = true;
  bool get isPastEventCanLoadMore => _isPastEventCanLoadMore;

  int _pastPageRequest = 1;
  int get pastPageRequest => _pastPageRequest;

  List<EventResponseData> _pastEventList = List();
  List<EventResponseData> get pastEventList => _pastEventList;

  Future<Null> getPastEvent({bool isRefresh = true}) async {
    if (isRefresh) {
      _isPastEventCanLoadMore = true;
      _pastPageRequest = 1;
      _pastEventList.clear();
    }
    setPastState(eventState.loading);
    final response = await _repository.getPastCommunityEvent(
        _communityId, _pastPageRequest, 10);
    if (!response.error && response.total > 0) {
      _pastEventList.addAll(response.dataList);
      _isPastEventCanLoadMore = response.total > _pastEventList.length;
      _pastPageRequest += 1;
      setPastState(eventState.success);
    } else {
      setPastState(eventState.empty);
      _isPastEventCanLoadMore = false;
    }
    notifyListeners();
  }

  setState(eventState state) {
    if (_isMounted) {
      _streamEvent.add(state);
    }
  }

  setPastState(eventState state) {
    if (_isMounted) {
      _pastStreamEvent.add(state);
    }
  }

  UnmodifiableListView<String> get popupItem =>
      UnmodifiableListView(_popupItem);
  List<String> _popupItem = [
    EVENT_EDIT,
    EVENT_CANCEL,
    EVENT_REMOVE,
  ];

  Future<CommunityEventResponseModel> adminUpdateData(
      {String status, String eventId}) async {
    final response = await _repository.adminUpdateEventData(eventId, status);
    return response;
  }

  Future<CommunityEventRequestModel> getEventRequestModel(int index) async {
    CommunityEventRequestModel model = CommunityEventRequestModel();
    model.eventSlug = _upcomingList[index].id;
    model.eventName = _upcomingList[index].title;
    model.eventDesc = _upcomingList[index].description;
    model.eventAudience = _upcomingList[index].audience.toString();
    model.startDate = _upcomingList[index].startDate;
    model.endDate = _upcomingList[index].endDate;
    model.startTime = _upcomingList[index].startTime;
    model.endTime = _upcomingList[index].endTime;
    model.location = _upcomingList[index].address;
    if (_upcomingList[index].attachment.isNotEmpty) {
      Future<List<Uint8List>> imageListFuture = Future.wait(_upcomingList[index]
          .attachment
          .map((e) async => await networkImageToByte(e.attachment)));
      List<Uint8List> decodedImage = await imageListFuture;
      model.selectedImage = decodedImage;
    }
    model.isOnlineEvent = _upcomingList[index].isOnline;
    return model;
  }

  @override
  void dispose() {
    _isMounted = false;
    _streamEvent.close();
    _pastStreamEvent.close();
    super.dispose();
  }
}

enum eventState { loading, success, empty }
