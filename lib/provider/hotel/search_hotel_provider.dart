import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/date_helper.dart';

class SearchHotelProvider extends BaseModelProvider {
  Repository _repository;
  TextEditingController _searchFormController;
  Timer _debounce;
  int _userRoomTotal = 1;
  int _pageRequestOffset = 1, _pageRequestLimit = 10, _totalPage = 0;
  bool _canLoadMore = true;
  Coordinates _userCoordinates = Coordinates(0.0, 0.0);
  DateTime _selectedCheckIn = DateTime.now();
  DateTime _selectedCheckOut = DateTime.now().add(Duration(days: 1));
  AnalyticsService _analyticsService;

  final StreamController<SearchViewState> _searchHotelController =
      StreamController<SearchViewState>.broadcast();
  List<HotelDetailEntity> _hotelDetailList = [];

  TextEditingController get searchController => _searchFormController;
  DateTime get selectedCheckIn => _selectedCheckIn;
  DateTime get selectedCheckOut => _selectedCheckOut;
  int get userTotalPickedRoom => _userRoomTotal;
  List<HotelDetailEntity> get hotelDetailList => _hotelDetailList;
  bool get canLoadMore => _canLoadMore;
  Stream<SearchViewState> get searchStream => _searchHotelController.stream;

  SearchHotelProvider({@required AnalyticsService analyticsService}) {
    _repository = Repository();
    _searchFormController = TextEditingController();
    _searchFormController.addListener(_onSearchChanged);
    this._analyticsService = analyticsService;
  }

  void setUserLocation(Coordinates _location) {
    this._userCoordinates = _location;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    if (_searchFormController.text.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 400), () {
        getHotel(isRefresh: true);
      });
    }
  }

  @override
  void dispose() {
    _searchFormController.dispose();
    if (_debounce != null && _debounce.isActive) {
      _debounce.cancel();
    }
    _searchHotelController.close();
    super.dispose();
  }

  _logSearchEvent() {
    _analyticsService.setCustomSearchEvent(
        keyword: _searchFormController.text,
        startDate: DateHelper.formatDateRangeForOYO(_selectedCheckIn),
        endDate: DateHelper.formatDateRangeForOYO(_selectedCheckOut),
        numberOfRooms: _userRoomTotal);
  }

  Future<void> getHotel({bool isRefresh = false}) async {
    _searchHotelController.add(SearchViewState.Busy);
    if (isRefresh) {
      _canLoadMore = true;
      _hotelDetailList.clear();
      _pageRequestOffset = 1;
    }
    if (!_canLoadMore) {
      return null;
    }
    _logSearchEvent();
    HotelListBaseResponse result = await _repository.getHotelList(
        '${_userCoordinates?.latitude}',
        '${_userCoordinates?.longitude}',
        '${_searchFormController.text}',
        _pageRequestOffset,
        _pageRequestLimit,
        RevampHotelListRequest());
    if (result != null && result.hotelDetailEntity.isNotEmptyNorNull) {
      _pageRequestOffset += 1;
      _totalPage = result?.total ?? 0;
      _canLoadMore = _totalPage > _hotelDetailList.length;
      _hotelDetailList.addAll(result.hotelDetailEntity);
      _searchHotelController.add(SearchViewState.DataRetrieved);
    } else {
      _searchHotelController.add(SearchViewState.NoData);
      _canLoadMore = false;
    }
    notifyListeners();
  }

  void setSelectedDate(DateTime checkIn, DateTime checkOut) {
    this._selectedCheckIn = checkIn;
    this._selectedCheckOut = checkOut;
    notifyListeners();
    getHotel(isRefresh: true);
  }

  void increaseRoomTotal() {
    this._userRoomTotal += 1;
    notifyListeners();
    getHotel(isRefresh: true);
  }

  void decreaseRoomTotal() async {
    if (_userRoomTotal > 1) {
      this._userRoomTotal -= 1;
      notifyListeners();
    }
    getHotel(isRefresh: true);
  }
}

enum SearchViewState { Busy, DataRetrieved, NoData }

extension on List {
  bool get isNotEmptyNorNull {
    return this != null && this.isNotEmpty;
  }
}
