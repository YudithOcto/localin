import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';

class HotelDetailApiProvider with ChangeNotifier {
  HotelDetailApiProvider(
      {int hotelId, RevampHotelListRequest request, RoomAvailability room}) {
    _request = request;
    _hotelId = hotelId;
    _selectedRoom = room;
    getHotelDetail();
  }

  RoomAvailability _selectedRoom;
  RoomAvailability get selectedRoom => _selectedRoom;

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
      _streamController.add(searchState.success);
    } else {
      _streamController.add(searchState.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
