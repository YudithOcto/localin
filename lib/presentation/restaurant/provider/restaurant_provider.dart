import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/utils/constants.dart';

class RestaurantProvider with ChangeNotifier {
  final _scrollController = ScrollController(keepScrollOffset: false);

  ScrollController get scrollController => _scrollController;

  final searchController = TextEditingController(text: kNearby);

  bool _isShowSearchAppBar = true;

  bool get isShowSearchAppBar => _isShowSearchAppBar;

  RestaurantProvider() {
    _scrollController..addListener(_scrollListener);
    getRestaurantList(sort: 'jarak');
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.03 &&
        _isShowSearchAppBar) {
      _isShowSearchAppBar = false;
      notifyListeners();
    } else if (_scrollController.offset <
            _scrollController.position.maxScrollExtent * 0.03 &&
        !_isShowSearchAppBar) {
      _isShowSearchAppBar = true;
      notifyListeners();
    } else if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        _canLoadMore) {
      getRestaurantList(isRefresh: false);
    }
  }

  set showSearchAppBar(bool value) {
    _isShowSearchAppBar = value;
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

  int _restaurantTotal = 0;

  get restaurantTotal => _restaurantTotal;

  getRestaurantList(
      {bool isRefresh = true,
      String search = '',
      String sort,
      String order,
      int isLocation}) async {
    if (isRefresh) {
      _restaurantList.clear();
      _restaurantTotal = 0;
      _canLoadMore = true;
      _pageRequest = 1;
    }
    _streamController.add(searchState.loading);
    final response = await _repository.getRestaurantList(
        _pageRequest, search.isEmpty || search == kNearby ? '' : search,
        sort: sort, order: order, isLocation: isLocation);
    if (response != null && response.total > 0) {
      _restaurantList.addAll(response.detail);
      _restaurantTotal = response.total;
      _pageRequest += 1;
      _canLoadMore = response.total > _restaurantList.length;
      _streamController.add(searchState.success);
    } else {
      _canLoadMore = false;
      _streamController.add(searchState.empty);
    }
    notifyListeners();
  }

  int currentSelectedIndex = 1;

  getRestaurantListWithSorting(int index) {
    currentSelectedIndex = index;
    if (index == 0) {
      // highest rating
      getRestaurantList(
          isRefresh: true, search: searchController.text, sort: 'rating');
    } else if (index == 1) {
      // Nearby
      getRestaurantList(
          isRefresh: true, search: searchController.text, sort: 'jarak');
    } else if (index == 2) {
      // Most Far
      getRestaurantList(
          isRefresh: true,
          search: searchController.text,
          sort: 'jarak',
          order: 'desc');
    } else if (index == 3) {
      // Lowest Price
      getRestaurantList(
          isRefresh: true, search: searchController.text, sort: 'harga');
    } else {
      // Highest Price
      getRestaurantList(
          isRefresh: true,
          search: searchController.text,
          sort: 'harga',
          order: 'desc');
    }
  }

  Future<String> updateBookmarkRestaurant(int index) async {
    final response = await _repository.bookmarkRestaurant(
        _restaurantList[index].id,
        isDelete: _restaurantList[index].isBookMark);
    if (response == 'Restaurant has bookmarks' ||
        response == 'Restaurant has un-bookmarks') {
      bool temp = _restaurantList[index].isBookMark;
      _restaurantList[index].isBookMark = !temp;
      notifyListeners();
    }
    return response;
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
