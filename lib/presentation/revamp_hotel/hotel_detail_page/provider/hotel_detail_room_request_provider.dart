import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';

class HotelDetailRoomRequestProvider with ChangeNotifier {
  final _repository = Repository();

  RoomAvailability _selectedRoom;

  RoomAvailability get selectedRoom => _selectedRoom;

  int _hotelId = 0;

  HotelDetailRoomRequestProvider(
      {int hotelId, RevampHotelListRequest request}) {
    _hotelId = hotelId;
    getRoomRequest(request);
  }

  final _streamController = StreamController<RoomState>.broadcast();

  Stream<RoomState> get roomStream => _streamController.stream;

  Future<Null> getRoomRequest(RevampHotelListRequest request) async {
    _streamController.add(RoomState.loading);
    final _roomRequest =
        await _repository.getRoomAvailability(_hotelId, request);
    if (!_roomRequest.roomAvailability.isNullOrEmpty) {
      _streamController.add(RoomState.success);
      _selectedRoom = _roomRequest.roomAvailability.first;
    } else {
      _streamController.add(RoomState.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

extension on List {
  bool get isNullOrEmpty {
    return this == null || this.isEmpty;
  }
}
