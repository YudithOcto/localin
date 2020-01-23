import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/provider/base_model_provider.dart';

class SearchHotelProvider extends BaseModelProvider {
  Repository _repository;
  TextEditingController _searchController;
  Timer _debounce;
  int _userRoomTotal = 1;
  UserLocation _userLocation = UserLocation();
  DateTime _selectedCheckIn = DateTime.now();
  DateTime _selectedCheckOut = DateTime.now().add(Duration(days: 1));
  final StreamController<SearchViewState> stateController =
      StreamController<SearchViewState>();

  TextEditingController get searchController => _searchController;
  DateTime get selectedCheckIn => _selectedCheckIn;
  DateTime get selectedCheckOut => _selectedCheckOut;
  int get userTotalPickedRoom => _userRoomTotal;

  SearchHotelProvider() {
    _repository = Repository();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  void setUserLocation(UserLocation _location) {
    this._userLocation = _location;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    if (_searchController.text.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 400), () {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_debounce != null && _debounce.isActive) {
      _debounce.cancel();
    }
    stateController.close();
    super.dispose();
  }

  Future<List<HotelDetailEntity>> getHotel(int page, int limit) async {
    HotelListBaseResponse result = await _repository.getHotelList(
        '${_userLocation?.latitude}',
        '${_userLocation?.longitude}',
        '${_searchController.text}',
        page,
        limit);
    return result.hotelDetailEntity;
  }

  void setSelectedDate(DateTime checkIn, DateTime checkOut) {
    this._selectedCheckIn = checkIn;
    this._selectedCheckOut = checkOut;
    notifyListeners();
  }

  void increaseRoomTotal() {
    this._userRoomTotal += 1;
    notifyListeners();
  }

  void decreaseRoomTotal() {
    if (_userRoomTotal > 1) {
      this._userRoomTotal -= 1;
      notifyListeners();
    }
  }
}

enum SearchViewState { Busy, DataRetrieved, NoData }
