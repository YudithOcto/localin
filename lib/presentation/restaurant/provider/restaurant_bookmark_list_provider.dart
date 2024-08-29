import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';

class RestaurantBookmarkListProvider with ChangeNotifier {
  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  RestaurantBookmarkListProvider() {
    _scrollController..addListener(_scrollListener);
  }

  final _repository = Repository();
  int _pageRequest = 1;

  int get pageRequest => _pageRequest;

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  final _streamController = StreamController<searchState>.broadcast();

  Stream<searchState> get stream => _streamController.stream;

  List<RestaurantDetail> _restaurantList = [];

  List<RestaurantDetail> get restaurantList => _restaurantList;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        _canLoadMore) {
      getBookmarkRestaurantList(isRefresh: false);
    }
    notifyListeners();
  }

  getBookmarkRestaurantList({bool isRefresh = true}) async {
    if (isRefresh) {
      _restaurantList.clear();
      _canLoadMore = true;
      _pageRequest = 1;
    }
    _streamController.add(searchState.loading);
    final response = await _repository.getBookmarkedRestaurants(_pageRequest);
    if (response != null && response.total > 0) {
      _restaurantList.addAll(response.detail);
      _restaurantList.map((e) => e.isBookMark = true).toList();
      _pageRequest += 1;
      _canLoadMore = response.total > _restaurantList.length;
      _streamController.add(searchState.success);
    } else {
      _canLoadMore = false;
      _streamController.add(searchState.empty);
    }
    notifyListeners();
  }

  Future<String> unBookMarkRestaurant(int index) async {
    final response = await _repository.bookmarkRestaurant(
        _restaurantList[index].id,
        isDelete: _restaurantList[index].isBookMark);
    if (response == 'Restaurant has un-bookmarks') {
      _trackChangedVariable = true;
      _restaurantList.removeAt(index);
      if (_restaurantList.isEmpty) {
        _streamController.add(searchState.empty);
      }
      notifyListeners();
    }
    return response;
  }

  bool _trackChangedVariable = false;

  bool get trackChangedVariable => _trackChangedVariable;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
