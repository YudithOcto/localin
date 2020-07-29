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

  getRestaurantList() async {
    searchResult.clear();
    _streamController.add(searchRestaurantEvent.loading);
    searchResult.add(RestaurantDetail());
    final response = await _repository.getRestaurantList(1, '', limit: 5);
    final localData = await getLastSearchFromLocal();
    if (localData != null && localData.isNotEmpty) {
      searchResult.add(RestaurantSearchTitle(title: 'My Last Search'));
      searchResult.addAll(localData);
    }
    if (response != null && response.total > 0) {
      searchResult.add(RestaurantSearchTitle(title: 'Popular Restaurant'));
      searchResult.addAll(response.detail);
      _streamController.add(searchRestaurantEvent.success);
    } else {
      _streamController.add(searchRestaurantEvent.empty);
    }
    notifyListeners();
  }

  Future<List<RestaurantLocalModal>> getLastSearchFromLocal() async {
    final result = await _lastSearchRestaurantDao.getAllDraft();
    return result;
  }

  Future<int> addToSearchLocal(
      RestaurantLocalModal restaurantLocalModel) async {
    final result = await _lastSearchRestaurantDao.insert(restaurantLocalModel);
    return result;
  }

  @override
  void dispose() {
    _streamController.close();
    searchController.dispose();
    super.dispose();
  }
}

enum searchRestaurantEvent { success, empty, loading }
