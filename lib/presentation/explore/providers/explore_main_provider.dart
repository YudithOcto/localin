import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/explore/explore_filter_model_request.dart';
import 'package:localin/presentation/explore/utils/filter.dart';

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

  ExploreFilterModelRequest _filterRequest = ExploreFilterModelRequest();
  ExploreFilterModelRequest get filterRequest => _filterRequest;
  set changeFilterRequest(ExploreFilterModelRequest request) {
    _filterRequest = request;
    getEventList(isRefresh: true);
  }

  Future<Null> getEventList({bool isRefresh = true, String search}) async {
    if (isRefresh) {
      _eventList.clear();
      _canLoadMore = true;
      _pageOffset = 1;
    }
    setState(exploreState.loading);
    final result = await _repository.getEventList(
        pageRequest: _pageOffset,
        search: search,
        categoryId: _filterRequest.category != null &&
                _filterRequest.category.isNotEmpty
            ? _filterRequest.category.map((e) => e.categoryId).toList()
            : null,
        sort:
            _filterRequest.sort != null ? sortList[_filterRequest.sort] : null,
        date:
            _filterRequest.month != null ? '${_filterRequest.month + 1}' : null,
        mode: 'default');
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
