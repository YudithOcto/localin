import 'dart:async';

import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/provider/base_model_provider.dart';

class HotelDetailProvider extends BaseModelProvider {
  Repository _repository;
  bool _bookingLoading = false;
  HotelDetailEntity hotelDetailEntity;
  int _checkInTime = 0,
      _checkOutTime = 0,
      _roomTotal = 1,
      _hotelID = 0,
      discount = 0;
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
    _checkInTime = _selectedCheckIn.millisecondsSinceEpoch;
    _checkOutTime = _selectedCheckOut.millisecondsSinceEpoch;

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
    setBookingLoading(true);
    final result = await _repository.bookHotel(
        hotelDetailEntity.hotelId,
        roomCategoryId,
        roomTotal * 2,
        roomTotal,
        _checkInTime,
        _checkOutTime,
        roomName);
    setBookingLoading(false);
    return result;
  }

  Future<void> getRoomAvailability() async {
    _roomState.add(RoomState.Busy);
    roomAvailability.clear();
    final result = await _repository.getRoomAvailability(
        _hotelID, _checkInTime, _checkOutTime, _roomTotal);
    if (result != null && result.error == null) {
      _roomState.add(RoomState.DataRetrieved);
      discount = result.discount ?? 0;
      roomAvailability.addAll(result.roomAvailability);
    } else {
      _roomState.add(RoomState.DataError);
      _errorMessage = result.error;
    }
  }

  void setRoomDateSearch(DateTime checkIn, DateTime checkOut) {
    this._checkInTime = checkIn.millisecondsSinceEpoch;
    this._checkOutTime = checkOut.millisecondsSinceEpoch;
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

  void setBookingLoading(bool value) {
    this._bookingLoading = value;
    notifyListeners();
  }

  void setCheckInDate(DateTime value) {
    _selectedCheckIn = value;
    notifyListeners();
  }

  void setCheckOutDate(DateTime value) {
    _selectedCheckOut = value;
    notifyListeners();
  }

  int get checkInTime => _checkInTime;
  int get checkOutTime => _checkOutTime;
  int get roomTotal => _roomTotal;
  DateTime get checkInDate => _selectedCheckIn;
  DateTime get checkOutDate => _selectedCheckOut;
  bool get loading => _bookingLoading;
  String get errorMessage => _errorMessage;
  Stream<RoomState> get roomState => _roomState.stream;

  @override
  void dispose() {
    _roomState.close();
    super.dispose();
  }
}

enum RoomState { Busy, DataRetrieved, DataError }
