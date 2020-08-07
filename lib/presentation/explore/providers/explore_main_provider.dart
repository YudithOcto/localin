import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';

class ExploreMainProvider with ChangeNotifier {
  final _repository = Repository();

  int _pageOffset = 1;
  int get pageOffset => _pageOffset;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  List<ExploreEventDetail> _eventList = [];
  List<ExploreEventDetail> get eventList => _eventList;

  final _streamController = StreamController<exploreState>.broadcast();
  Stream<exploreState> get stream => _streamController.stream;

  bool isMount = true;

  Future<Null> getEventList(
      {bool isRefresh = true,
      String search,
      List<int> categoryId,
      String sort,
      String date}) async {
    if (isRefresh) {
      _eventList.clear();
      _canLoadMore = true;
      _pageOffset = 1;
    }
    setState(exploreState.loading);
    final result = await _repository.getEventList(
        pageRequest: _pageOffset,
        search: search,
        categoryId: categoryId,
        sort: sort,
        date: date);
    if (result != null && result.total > 0) {
      _eventList.addAll(result.detail);
      _canLoadMore = result.total > _eventList.length;
      _pageOffset += 1;
      setState(exploreState.success);
    } else {
      setState(exploreState.empty);
      _canLoadMore = false;
    }
    if (isMount) {
      notifyListeners();
    }
  }

  setState(exploreState state) {
    if (isMount) {
      _streamController.add(state);
    } else {
      return;
    }
  }

  @override
  void dispose() {
    isMount = false;
    _streamController.close();
    super.dispose();
  }
}

enum exploreState { loading, empty, success }
