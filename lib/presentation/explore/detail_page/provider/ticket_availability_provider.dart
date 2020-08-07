import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_schedule_model.dart';
import 'package:localin/presentation/explore/enum.dart';

class TicketAvailabilityProvider with ChangeNotifier {
  final _repository = Repository();

  int _eventId;

  TicketAvailabilityProvider(int eventId) {
    _eventId = eventId;
    getAvailableSchedules(true);
  }

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  List<ExploreScheduleModel> _eventTicketList = [];
  List<ExploreScheduleModel> get eventTicketList => _eventTicketList;

  int maxQuantity = 0;

  final _streamController = StreamController<shareExploreState>.broadcast();
  Stream<shareExploreState> get calendarStream => _streamController.stream;

  Future<List<ExploreScheduleModel>> getAvailableSchedules(
      bool isRefresh) async {
    if (isRefresh) {
      _pageRequest = 1;
    }
    _streamController.add(shareExploreState.loading);
    final response =
        await _repository.getAvailableDates(_eventId, _pageRequest);
    if (response != null) {
      _eventTicketList.addAll(response.detail);
      maxQuantity = response.maxBuyQty;
      _streamController.add(shareExploreState.success);
    } else {
      _streamController.add(shareExploreState.empty);
    }
    notifyListeners();
    return _eventTicketList;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
