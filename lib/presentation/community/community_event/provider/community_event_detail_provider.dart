import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_response_model.dart';

class CommunityEventDetailProvider with ChangeNotifier {
  String _eventId = '';
  final _repository = Repository();

  CommunityEventDetailProvider({String eventId}) {
    _eventId = eventId;
    getEventDetail();
  }

  EventResponseData _eventResponse = EventResponseData();

  EventResponseData get eventResponse => _eventResponse;

  final _streamController = StreamController<eventDetailState>.broadcast();

  Stream<eventDetailState> get streamEvent => _streamController.stream;

  Future<void> getEventDetail() async {
    _streamController.add(eventDetailState.loading);
    final response = await _repository.getEventDetail(_eventId);
    if (!response.error) {
      _eventResponse = response.data;
      getDefaultSortFromApi(response.data?.userAttendStatus);
      _streamController.add(eventDetailState.success);
    } else {
      _streamController.add(eventDetailState.empty);
    }
    notifyListeners();
  }

  Future<CommunityEventResponseModel> updateJoinEvent({String status}) async {
    final response = await _repository.updateJoinEvent(
        selectedSortToSendToApi(status), _eventId);
    return response;
  }

  List<String> _sortingList = [
    'Going',
    'Tentative',
    'Not Going',
  ];

  List<String> get sortingList => _sortingList;

  String _selectedSort = 'Going';

  String get selectedSort => _selectedSort;

  set selectSort(String value) {
    _selectedSort = value;
    notifyListeners();
  }

  void getDefaultSortFromApi(String value) {
    if (value.toLowerCase().contains('going')) {
      _selectedSort = _sortingList[0];
    } else if (value.toLowerCase().contains('tentative')) {
      _selectedSort = _sortingList[1];
    } else {
      _selectedSort = _sortingList[2];
    }
  }

  String selectedSortToSendToApi(String value) {
    //hadir / tentative / batal
    if (value == null || value.isEmpty) return 'batal';
    if (value.toLowerCase() == sortingList[0].toLowerCase()) {
      return 'hadir';
    } else if (value.toLowerCase() == sortingList[1].toLowerCase()) {
      return 'tentative';
    } else {
      return 'batal';
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum eventDetailState { loading, success, empty }
