import 'dart:async';

import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/provider/base_model_provider.dart';

class HotelDetailProvider extends BaseModelProvider {
  Repository _repository;
  HotelDetailEntity hotelDetailEntity;
  int _roomTotal = 1, _hotelID = 0, discount = 0;
  String _errorMessage = '';
  DateTime _selectedCheckIn, _selectedCheckOut;
  StreamController<RoomState> _roomState;
  List<RoomAvailability> roomAvailability = [];

  HotelDetailProvider(DateTime checkIn, DateTime checkOut) {
    _repository = Repository();
    _roomState = StreamController<RoomState>.broadcast();
    _selectedCheckIn = checkIn;
    _selectedCheckOut = checkOut;
  }

  Future<HotelListBaseResponse> getHotelDetail(int hotelID) async {
    _hotelID = hotelID;

    getRoomAvailability();

    final response = await _repository.getHotelDetail(
        hotelID, _selectedCheckIn, _selectedCheckOut, _roomTotal);
    if (response.error == null) {
      hotelDetailEntity = response.singleHotelEntity;
    }
    return response;
  }

  Future<BookHotelResponse> bookHotel(
      int roomCategoryId, String roomName) async {
    _roomState.add(RoomState.loading);
    final result = await _repository.bookHotel(
        hotelDetailEntity.hotelId,
        roomCategoryId,
        roomTotal * 2,
        roomTotal,
        _selectedCheckIn,
        _selectedCheckOut,
        roomName);
    _roomState.add(RoomState.success);
    return result;
  }

  Future<void> getRoomAvailability() async {
    _roomState.add(RoomState.loading);
    roomAvailability.clear();
    final result = await _repository.getRoomAvailability(
        _hotelID, _selectedCheckIn, _selectedCheckOut, _roomTotal);
    if (result != null && result.error == null) {
      _roomState.add(RoomState.success);
      discount = result.discount ?? 0;
      roomAvailability.addAll(result.roomAvailability);
    } else {
      _roomState.add(RoomState.empty);
      _errorMessage = result.error;
    }
  }

  void setRoomDateSearch(DateTime checkIn, DateTime checkOut) {
    this._selectedCheckIn = checkIn;
    this._selectedCheckOut = checkOut;
    getRoomAvailability();
  }

  void increaseRoomTotal() {
    this._roomTotal += 1;
    notifyListeners();
    getRoomAvailability();
  }

  void decreaseRoomTotal() {
    if (_roomTotal > 1) {
      this._roomTotal -= 1;
      notifyListeners();
      getRoomAvailability();
    }
  }

  void setCheckInDate(DateTime value) {
    _selectedCheckIn = value;
    notifyListeners();
  }

  void setCheckOutDate(DateTime value) {
    _selectedCheckOut = value;
    notifyListeners();
  }

  int get roomTotal => _roomTotal;
  DateTime get checkInDate => _selectedCheckIn;
  DateTime get checkOutDate => _selectedCheckOut;
  String get errorMessage => _errorMessage;
  Stream<RoomState> get roomState => _roomState.stream;

  @override
  void dispose() {
    _roomState.close();
    super.dispose();
  }
}

enum RoomState { loading, success, empty }
