import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/presentation/explore/enum.dart';
import 'package:localin/utils/date_helper.dart';

class CalendarProvider with ChangeNotifier {
  final _repository = Repository();

  String _eventId = '';

  CalendarProvider(String eventId) {
    _eventId = eventId;
  }

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  List<ExploreAvailableEventDatesDetail> _eventTicketList = [];
  List<ExploreAvailableEventDatesDetail> get eventTicketList =>
      _eventTicketList;

  final _streamController = StreamController<shareExploreState>.broadcast();
  Stream<shareExploreState> get calendarStream => _streamController.stream;

  Future<Null> getAvailableSchedules(
      DateTime dateSelected, bool isRefresh) async {
    if (isRefresh) {
      _pageRequest = 1;
    }
    _streamController.add(shareExploreState.loading);
    String date =
        DateHelper.formatDate(date: dateSelected, format: 'yyyy-mm-dd');
    final response =
        await _repository.getAvailableDates(_eventId, _pageRequest, date);
    if (response != null && response.total > 0) {
      _eventTicketList.addAll(response.detail);
      _streamController.add(shareExploreState.success);
    } else {
      _streamController.add(shareExploreState.empty);
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
