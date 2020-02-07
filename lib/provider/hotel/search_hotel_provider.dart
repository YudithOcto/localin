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
  int _offset = 1, limit = 10, totalPage = 0;
  UserLocation _userLocation = UserLocation();
  DateTime _selectedCheckIn = DateTime.now();
  DateTime _selectedCheckOut = DateTime.now().add(Duration(days: 1));
  final StreamController<SearchViewState> stateController =
      StreamController<SearchViewState>();
  List<HotelDetailEntity> hotelDetailList = [];

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

  Future<List<HotelDetailEntity>> getHotel() async {
    if (hotelDetailList.length > totalPage) {
      return null;
    }
    HotelListBaseResponse result = await _repository.getHotelList(
        '${_userLocation?.latitude}',
        '${_userLocation?.longitude}',
        '${_searchController.text}',
        _offset,
        limit,
        _selectedCheckIn,
        _selectedCheckOut,
        _userRoomTotal);
    if (result != null &&
        result.hotelDetailEntity != null &&
        result.hotelDetailEntity.isNotEmpty) {
      _offset += 1;
      totalPage = result?.total ?? 0;
      hotelDetailList.addAll(result.hotelDetailEntity);
//      hotelDetailList.sort((a, b) {
//        int comparing = 0;
//        final price =
//            a.roomAvailability != null && a.roomAvailability.isNotEmpty
//                ? a.roomAvailability.first.sellingAmount
//                : 0;
//        final price2 =
//            b.roomAvailability != null && b.roomAvailability.isNotEmpty
//                ? b.roomAvailability.first.sellingAmount
//                : 0;
//        comparing = a.distance.compareTo(b.distance);
//        Iterable
//        if (comparing > 0) {
//          comparing = price.toString().compareTo(price2.toString());
//        }
//        return comparing;
//      });
      notifyListeners();
    }
    return result.hotelDetailEntity;
  }

  void resetParams() {
    _offset = 1;
    notifyListeners();
  }

  Future<List<HotelDetailEntity>> resetAndCallApi() async {
    _offset = 1;
    hotelDetailList.clear();
    return getHotel();
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
