import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/hotel_last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/hotel_suggest_local_model.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/utils/constants.dart';

class HotelDetailApiProvider with ChangeNotifier {
  HotelDetailApiProvider({int hotelId, RevampHotelListRequest request}) {
    _request = request;
    _hotelId = hotelId;
    getHotelDetail();
  }

  RevampHotelListRequest _request = RevampHotelListRequest();
  RevampHotelListRequest get request => _request;
  int _hotelId = 0;

  final _repository = Repository();
  final _streamController = StreamController<searchState>.broadcast();
  Stream<searchState> get stream => _streamController.stream;

  HotelDetailEntity _hotelDetailEntity = HotelDetailEntity();
  HotelDetailEntity get hotelDetailEntity => _hotelDetailEntity;

  Future<Null> getHotelDetail() async {
    _streamController.add(searchState.loading);
    final response = await _repository.getHotelDetail(
        _hotelId, _request.checkIn, _request.checkout, _request.totalRooms);
    if (response != null && response.error == null) {
      _hotelDetailEntity = response.singleHotelEntity;
      addToSearchLocal(HotelSuggestLocalModel(
          hotelId: _hotelDetailEntity.hotelId,
          title: _hotelDetailEntity.hotelName,
          subtitle: _hotelDetailEntity.shortAddress,
          category: 'City'));
      _streamController.add(searchState.success);
    } else {
      _streamController.add(searchState.empty);
    }
    notifyListeners();
  }

  changeBookmarkLocally() {
    _hotelDetailEntity.isBookmark = !_hotelDetailEntity.isBookmark;
    notifyListeners();
  }

  Future<String> changeBookmark() async {
    String queryType = _hotelDetailEntity.isBookmark
        ? kUnbookmarkQueryType
        : kBookmarkQueryType;
    final result = await _repository.changeBookmarkStatus(
        queryType, _hotelDetailEntity.hotelId);
    if (!result.error) {
      _hotelDetailEntity.isBookmark = !_hotelDetailEntity.isBookmark;
      notifyListeners();
    }
    return result?.message;
  }

  final HotelLastSearchDao _lastSearchHotelDao = HotelLastSearchDao();

  Future<int> addToSearchLocal(
      HotelSuggestLocalModel hotelSuggestLocalModel) async {
    final result = await _lastSearchHotelDao.insert(hotelSuggestLocalModel);
    return result;
  }

  changeCheckInTime(DateTime checkInTime) {
    _request.checkIn = checkInTime;
    _request.checkout = checkInTime.add(Duration(days: 1));
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

extension on List {
  bool get isNullorEmpty {
    return this == null || this.isEmpty;
  }
}
