import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/restaurant/restaurant_local_model.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/model/restaurant/restaurant_search_title.dart';

class SearchRestaurantProvider with ChangeNotifier {
  final searchController = TextEditingController();
  final LastSearchDao _lastSearchRestaurantDao = LastSearchDao();

  final _streamController = StreamController<searchRestaurantEvent>.broadcast();
  get stream => _streamController.stream;

  final _repository = Repository();
  List<dynamic> searchResult = List();

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  int _trackDataTotal = 0;

  getRestaurantList({bool isRefresh = true, String search = ''}) async {
    if (isRefresh) {
      isRefresh = true;
      searchResult.clear();
      _pageRequest = 1;
      _canLoadMore = true;
      _trackDataTotal = 0;
    }
    if (!_canLoadMore) {
      return;
    }
    _streamController.add(searchRestaurantEvent.loading);
    final response = await _repository.getRestaurantList(1, search,
        limit: search.isNotEmpty ? 10 : 5,
        sort: search.isNotEmpty ? '' : 'rating',
        isLocation: 0);
    if (searchController.text.isEmpty) {
      addDefaultSearch(response);
    } else {
      addAdvanceSearch(response);
    }
    notifyListeners();
  }

  addAdvanceSearch(RestaurantResponseModel response) {
    if (response != null &&
        (response.restaurantLocation.isNotEmpty ||
            response.detail.isNotEmpty)) {
      List<RestaurantDetail> data = [];
      if (_pageRequest > 1) {
        data.addAll(response.detail);
        _trackDataTotal += data.length;
        _canLoadMore = response.total > _trackDataTotal;
        _pageRequest += 1;
        searchResult.addAll(data);
        _streamController.add(searchRestaurantEvent.success);
      } else {
        if (response.restaurantLocation.isNotEmpty) {
          searchResult.add(RestaurantSearchTitle(title: 'Location'));
          searchResult.addAll(response.restaurantLocation);
        }
        if (response.detail != null && response.detail.isNotEmpty) {
          searchResult.add(RestaurantSearchTitle(title: 'Restaurants'));
          data.addAll(response.detail);
          searchResult.addAll(data);
        }
        _pageRequest += 1;
        _trackDataTotal = data.length;
        _canLoadMore = response.total > data.length;
        _streamController.add(searchRestaurantEvent.success);
      }
    } else {
      _streamController.add(searchRestaurantEvent.empty);
    }
  }

  addDefaultSearch(RestaurantResponseModel response) async {
    _pageRequest += 1;
    _canLoadMore = false;
    searchResult.add(RestaurantDetail());
    final localData = await getLastSearchFromLocal();
    if (localData != null && localData.isNotEmpty) {
      searchResult.add(RestaurantSearchTitle(title: 'My Last Search'));
      searchResult.addAll(localData);
    }
    if (response != null && response.total > 0) {
      searchResult.add(RestaurantSearchTitle(title: 'Popular Restaurant'));
      final data = response.detail as List<RestaurantDetail>;
      searchResult.addAll(data);
    }
    _streamController.add(searchRestaurantEvent.success);
  }

  Future<List<RestaurantLocalModal>> getLastSearchFromLocal() async {
    final result = await _lastSearchRestaurantDao.getAllDraft();
    return result;
  }

  Future<Null> addToSearchLocal() async {
    final data = await _lastSearchRestaurantDao.getAllDraft();
    List<int> filledIndex = [];
    searchResult.asMap().forEach((index, value) {
      if (value is RestaurantLocalModal) {
        filledIndex.add(index);
      }
    });
    if (filledIndex != null && filledIndex.length > 1) {
      searchResult.removeAt(filledIndex.last);
      searchResult.replaceRange(filledIndex?.first, filledIndex?.last, data);
    } else if (filledIndex == null || filledIndex.isEmpty) {
      searchResult.insert(1, RestaurantSearchTitle(title: 'My Last Search'));
      searchResult.insert(2, data.first);
    } else if (filledIndex.length == 1) {
      searchResult.insert(2, data.first);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    searchController.dispose();
    super.dispose();
  }
}

enum searchRestaurantEvent { success, empty, loading }
