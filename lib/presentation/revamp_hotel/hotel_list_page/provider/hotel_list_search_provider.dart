import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';

class HotelListSearchProvider with ChangeNotifier {
  HotelListSearchProvider(
      {RevampHotelListRequest request, HotelDetailEntity detail}) {
    _requestModel = request;
    trackBookmark = detail.isBookmark;
    _hotelDetailEntity = detail;
    getRoomAvailability();
  }

  set checkInDate(DateTime now) {
    _requestModel.checkIn = now;
    _requestModel.checkout = now.add(Duration(days: 1));
    notifyListeners();
  }

  List<String> getListCheckOutDate() {
    List<String> result = [];
    for (int i = 0; i <= 20; i++) {
      result.add(
          'Check-out ${_requestModel.checkIn.add(Duration(days: i + 1)).parseDate}');
    }
    return result;
  }

  set checkOutDate(int index) {
    _requestModel.checkout = _requestModel.checkIn.add(Duration(days: index));
    notifyListeners();
  }

  String get search {
    if (_requestModel.search != null && _requestModel.search.isNotEmpty) {
      return _requestModel.search;
    }
    return 'Nearby';
  }

  set searchKeyword(String search) {
    _requestModel.search = search;
    notifyListeners();
  }

  bool trackBookmark = false;

  HotelDetailEntity _hotelDetailEntity;
  HotelDetailEntity get hotelDetail => _hotelDetailEntity;

  RevampHotelListRequest _requestModel = RevampHotelListRequest();
  RevampHotelListRequest get requestModel => _requestModel;

  DateTime get checkIn => _requestModel.checkIn;
  DateTime get checkOut => _requestModel.checkout;
  int get totalRoomSelected => _requestModel.totalRooms;
  int get totalGuestSelected =>
      _requestModel.totalAdults + _requestModel.totalChild;

  int get totalNightSelected {
    return _requestModel.checkout.difference(_requestModel.checkIn).inDays;
  }

  set changeRoomAndGuest(Map<String, int> map) {
    _requestModel.totalRooms = map[kRoom];
    _requestModel.totalChild = map[kChild];
    _requestModel.totalAdults = map[kAdult];
    notifyListeners();
  }

  String get currentCheckoutDate {
    return _requestModel.checkout.parseDate;
  }

  String get currentCheckInDate {
    return _requestModel.checkIn.parseDate;
  }

  final _roomState = StreamController<RoomState>.broadcast();
  Stream<RoomState> get stream => _roomState.stream;

  final _repository = Repository();
  List<RoomAvailability> _roomAvailability = List();
  List<RoomAvailability> get roomAvailability => _roomAvailability;

  int discount = 0;

  Future<Null> getRoomAvailability() async {
    _roomState.add(RoomState.loading);
    _roomAvailability.clear();
    final result = await _repository.getRoomAvailability(
        _hotelDetailEntity.hotelId,
        _requestModel.checkIn,
        _requestModel.checkout,
        _requestModel.totalRooms);
    if (result != null && result.error == null) {
      _roomState.add(RoomState.success);
      discount = result.discount;
      _roomAvailability.addAll(result.roomAvailability);
    } else {
      _roomState.add(RoomState.empty);
    }
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

  @override
  void dispose() {
    _roomState.close();
    super.dispose();
  }
}

extension on DateTime {
  String get parseDate {
    return DateHelper.formatDate(
        date: this == null ? DateTime.now() : this, format: 'EEE, dd MMM yyyy');
  }
}
