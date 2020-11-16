import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/restaurant/restaurant_local_model.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';

class RestaurantDetailProvider with ChangeNotifier {
  RestaurantDetailProvider(RestaurantLocalModal restaurantLocalModal)
      : assert(restaurantLocalModal != null) {
    addToSearchLocal(restaurantLocalModal);
  }

  final _streamController = StreamController<eventState>.broadcast();

  get stream => _streamController.stream;

  final _repository = Repository();

  RestaurantDetail _restaurantDetail = RestaurantDetail();

  get restaurantDetail => _restaurantDetail;

  Future<Null> getRestaurantDetail(String restaurantId) async {
    _streamController.add(eventState.loading);
    final response = await _repository.getRestaurantDetail(restaurantId);
    if (response != null && !response.error) {
      _restaurantDetail = response.detail;
      _streamController.add(eventState.success);
    } else {
      _streamController.add(eventState.empty);
    }
    notifyListeners();
  }

  bool _trackChangedBookmark = false;

  bool get trackChangedBookmark => _trackChangedBookmark;

  Future<String> updateBookmarkRestaurant() async {
    final response = await _repository.bookmarkRestaurant(_restaurantDetail.id,
        isDelete: _restaurantDetail.isBookMark);
    if (response == 'Restaurant has bookmarks' ||
        response == 'Restaurant has un-bookmarks') {
      _trackChangedBookmark = true;
      bool temp = _restaurantDetail.isBookMark;
      _restaurantDetail.isBookMark = !temp;
      notifyListeners();
    }
    return response;
  }

  final LastSearchDao _lastSearchRestaurantDao = LastSearchDao();

  Future<int> addToSearchLocal(
      RestaurantLocalModal restaurantLocalModel) async {
    final result = await _lastSearchRestaurantDao.insert(restaurantLocalModel);
    return result;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
