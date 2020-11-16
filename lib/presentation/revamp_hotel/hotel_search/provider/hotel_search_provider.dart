import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localin/api/hotel_last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_search_suggest_model.dart';
import 'package:localin/model/hotel/hotel_suggest_base.dart';
import 'package:localin/model/hotel/hotel_suggest_local_model.dart';
import 'package:localin/model/hotel/hotel_suggest_nearby.dart';
import 'package:localin/model/hotel/hotel_suggest_title.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';

class HotelSearchProvider with ChangeNotifier {
  final searchController = TextEditingController();

  final _repository = Repository();

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;

  int get pageRequest => _pageRequest;

  List<HotelSuggestBase> _hotelList = List();

  List<HotelSuggestBase> get hotelList => _hotelList;

  final _streamController = StreamController<searchState>.broadcast();

  Stream<searchState> get stream => _streamController.stream;

  Future<Null> searchHotel({bool isRefresh = true, String search = ''}) async {
    if (isRefresh) {
      _canLoadMore = true;
      _pageRequest = 1;
      _hotelList.clear();
    }
    if (!_canLoadMore) return;
    _streamController.add(searchState.loading);
    final _result =
        await _repository.searchHotelAndLocation(searchController.text);
    if (_result.message != null) {
      if (searchController.text.isEmpty) {
        addDefaultResult(_result);
      } else {
        addAdvanceResult(_result);
      }
    } else {
      _streamController.add(searchState.empty);
      _canLoadMore = false;
      notifyListeners();
    }
  }

  addDefaultResult(HotelSearchSuggestModel model) async {
    _hotelList.add(HotelSuggestNearby(title: 'Hotel Near me'));
    List<HotelSuggestLocalModel> data = await getLastSearchFromLocal();
    if (data != null && data.isNotEmpty) {
      _hotelList.add(HotelSuggestTitle(title: 'Your Last Search'));
      _hotelList.addAll(data);
    }
    _hotelList.add(HotelSuggestTitle(title: 'Popular Destination'));
    _hotelList.addAll(model.location);
    _streamController.add(searchState.success);
    notifyListeners();
  }

  addAdvanceResult(HotelSearchSuggestModel model) {
    if (model.location.isNotEmpty) {
      _hotelList.add(HotelSuggestTitle(title: 'Location'));
      _hotelList.addAll(model.location);
    }
    if (model.hotel.isNotEmpty) {
      _hotelList.add(HotelSuggestTitle(title: 'Hotels'));
      _hotelList.addAll(model.hotel);
    }
    _streamController.add(searchState.success);
    notifyListeners();
  }

  final HotelLastSearchDao _lastSearchHotelDao = HotelLastSearchDao();

  Future<List<HotelSuggestLocalModel>> getLastSearchFromLocal() async {
    final result = await _lastSearchHotelDao.getAllHotelListView();
    return result;
  }

  Future<int> addToSearchLocal(
      HotelSuggestLocalModel hotelSuggestLocalModel) async {
    final result = await _lastSearchHotelDao.insert(hotelSuggestLocalModel);
    return result;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
