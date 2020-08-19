import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';

import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HotelListProvider with ChangeNotifier {
  final _userCoordinates;

  HotelListProvider({Coordinates coordinates})
      : assert(coordinates != null),
        _userCoordinates = coordinates {
    _revampHotelListRequest = RevampHotelListRequest(
      checkIn: DateTime.now(),
      checkout: DateTime.now().add(Duration(days: 1)),
      totalRooms: 1,
    );
    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        getRestaurantList(isRefresh: false);
      } else if (_scrollController.offset >
          _scrollController.position.maxScrollExtent * 0.03) {
        _appbarStreamController.add(true);
      } else if (_scrollController.offset <=
          _scrollController.position.maxScrollExtent * 0.03) {
        _appbarStreamController.add(false);
      }
    });
  }

  final _appbarStreamController = StreamController<bool>.broadcast();
  Stream get appbarStream => _appbarStreamController.stream;

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final panelController = PanelController();

  final _repository = Repository();
  final _streamController = StreamController<searchState>.broadcast();
  Stream<searchState> get stream => _streamController.stream;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get pageRequested => _pageRequest;

  List<HotelDetailEntity> _hotelList = List();
  List<HotelDetailEntity> get hotelList => _hotelList;

  int _totalHotel = 0;
  int _trackOriginalListLength = 0;

  Future<Null> getRestaurantList({bool isRefresh = true}) async {
    if (isRefresh) {
      _canLoadMore = true;
      _hotelList.clear();
      _pageRequest = 1;
    }
    if (!_canLoadMore) return;
    if (_pageRequest == 1) {
      _streamController.add(searchState.loading);
    }
    final response = await _repository.getHotelList(
        '${_userCoordinates.latitude}',
        '${_userCoordinates.longitude}',
        _revampHotelListRequest.search,
        _pageRequest,
        10,
        _revampHotelListRequest);
    if (_hotelList.isEmpty) {
      _hotelList.add(HotelDetailEntity());
    }
    if (response != null && response.error == null && response.total > 0) {
      _totalHotel = response.total;
      response.hotelDetailEntity.forEach((e) {
        if (e.roomAvailability != null && e.roomAvailability.isNotEmpty) {
          if (isVisible(e.roomAvailability.first.pricePerNight.oneNight)) {
            _hotelList.add(e);
          }
        }
      });
      if (_hotelList.length == 1) {
        _canLoadMore = false;
        _streamController.add(searchState.empty);
      } else {
        _trackOriginalListLength += response.hotelDetailEntity.length;
        _pageRequest += 1;
        _canLoadMore = _trackOriginalListLength < _totalHotel;
        _streamController.add(searchState.success);
      }
    } else {
      _streamController.add(searchState.empty);
      _canLoadMore = false;
    }
    notifyListeners();
  }

  RevampHotelListRequest _revampHotelListRequest;
  RevampHotelListRequest get revampHotelListRequest => _revampHotelListRequest;
  set revampHotelDataRequest(RevampHotelListRequest data) {
    final temp = _revampHotelListRequest;
    _revampHotelListRequest = RevampHotelListRequest(
      search: data.search != null && data.search.isNotEmpty
          ? data.search
          : temp.search,
      checkIn: data.checkIn != null ? data.checkIn : temp.checkIn,
      checkout: data.checkout != null ? data.checkout : temp.checkout,
      sort: data.sort != null ? data.sort : temp.sort,
      minPrice: data.minPrice != null ? data.minPrice : temp.minPrice ?? 0.0,
      maxPrice:
          data.maxPrice != null ? data.maxPrice : temp.maxPrice ?? 2000000,
      totalRooms: data.totalRooms != null ? data.totalRooms : temp.totalRooms,
      facilities: data.facilities != null && data.facilities.isNotEmpty
          ? data.facilities
          : temp.facilities,
      totalChild: data.totalChild != null && data.totalChild != temp.totalChild
          ? data.totalChild
          : temp.totalChild,
      totalAdults:
          data.totalAdults != null && data.totalAdults != temp.totalAdults
              ? data.totalAdults
              : temp.totalAdults,
    );
    notifyListeners();
  }

  int get currentSort {
    if (_revampHotelListRequest.sort == 'asc') {
      return 0;
    } else {
      return 1;
    }
  }

  set sorting(String sort) {
    _revampHotelListRequest.sort = sort == kNearby ? 'asc' : 'desc';
    getRestaurantList();
  }

  changeBookmarkLocally(int index) {
    _hotelList[index].isBookmark = !_hotelList[index].isBookmark;
    notifyListeners();
  }

  Future<String> changeBookmark(int index) async {
    String queryType = _hotelList[index].isBookmark
        ? kUnbookmarkQueryType
        : kBookmarkQueryType;
    final result = await _repository.changeBookmarkStatus(
        queryType, _hotelList[index].hotelId);
    if (!result.error) {
      _hotelList[index].isBookmark = !_hotelList[index].isBookmark;
      notifyListeners();
    }
    return result?.message;
  }

  bool isVisible(int roomPrice) {
    if (roomPrice == null) return true;
    double price = roomPrice.toDouble();
    return price >= _revampHotelListRequest.minPrice &&
        price <= _revampHotelListRequest.maxPrice;
  }

  @override
  void dispose() {
    _streamController.close();
    _appbarStreamController.close();
    super.dispose();
  }
}
