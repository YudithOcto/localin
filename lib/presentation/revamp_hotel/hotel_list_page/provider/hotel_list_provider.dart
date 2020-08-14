import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';

import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
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

  Future<Null> getRestaurantList({bool isRefresh = true, String search}) async {
    if (isRefresh) {
      _canLoadMore = true;
      _hotelList.clear();
      _pageRequest = 1;
    }
    if (!_canLoadMore) return;
    _streamController.add(searchState.loading);
    final response = await _repository.getHotelList(
        '${_userCoordinates.latitude}',
        '${_userCoordinates.longitude}',
        search,
        _pageRequest,
        10,
        _revampHotelListRequest.checkIn,
        _revampHotelListRequest.checkout,
        _revampHotelListRequest.totalRooms);
    if (response != null && response.error == null && response.total > 0) {
      if (_hotelList.isEmpty) {
        _hotelList.add(HotelDetailEntity());
      }
      _totalHotel = response.total;
      _hotelList.addAll(response.hotelDetailEntity);
      _trackOriginalListLength += response.hotelDetailEntity.length;
      _pageRequest += 1;
      _canLoadMore = _trackOriginalListLength < _totalHotel;
      _streamController.add(searchState.success);
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
        totalRooms:
            data.totalRooms != null ? data.totalRooms : temp.totalRooms);
    notifyListeners();
  }

  filterHotelList() {
    List<HotelDetailEntity> _detailEntity = List();
    _hotelList.forEach((hotel) {
      if (hotel.roomAvailability != null && hotel.roomAvailability.isNotEmpty) {
        if (hotel.roomAvailability.first.sellingAmount.toDouble() >=
                _revampHotelListRequest.minPrice &&
            hotel.roomAvailability.first.sellingAmount.toDouble() <=
                _revampHotelListRequest.maxPrice) {
          _detailEntity.add(hotel);
        }
      }
    });
    _hotelList.clear();
    _hotelList.addAll(_detailEntity);
    notifyListeners();
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
