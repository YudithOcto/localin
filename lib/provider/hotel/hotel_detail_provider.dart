import 'dart:async';

import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_base_response.dart';
import 'package:localin/provider/base_model_provider.dart';

class HotelDetailProvider extends BaseModelProvider {
  Repository _repository;
  bool _bookingLoading = false;
  HotelDetailEntity hotelDetailEntity;
  int _checkInTime = 0, _checkOutTime = 0, _roomTotal = 1, _hotelID = 0;
  String _errorMessage = '';
  StreamController<RoomBaseResponse> _roomController;

  HotelDetailProvider() {
    _repository = Repository();
    _roomController = StreamController<RoomBaseResponse>.broadcast();
  }

  Future<HotelListBaseResponse> getHotelDetail(int hotelID) async {
    _hotelID = hotelID;
    final checkInDev = DateTime.now();
    final checkOutDev = DateTime.now().add(Duration(days: 1));
    _checkInTime = checkInDev.toUtc().millisecondsSinceEpoch;
    _checkOutTime = checkOutDev.toUtc().millisecondsSinceEpoch;
    getRoomAvailability();

    final response = await _repository.getHotelDetail(
        hotelID, checkInDev, checkOutDev, _roomTotal);
    if (response.error == null) {
      hotelDetailEntity = response.singleHotelEntity;
    }
    return response;
  }

  Future<BookHotelResponse> bookHotel(int roomCategoryId) async {
    setBookingLoading(true);
    final result = await _repository.bookHotel(hotelDetailEntity.hotelId,
        roomCategoryId, roomTotal * 2, roomTotal, _checkInTime, _checkOutTime);
    setBookingLoading(false);
    return result;
  }

  Future<RoomBaseResponse> getRoomAvailability() async {
    final result = await _repository.getRoomAvailability(
        _hotelID, _checkInTime, _checkOutTime, _roomTotal);
    if (result != null && result.error == null) {
      _roomController.add(result);
      return result;
    } else {
      _roomController.add(null);
      _errorMessage = result.error;
      return null;
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

  int get checkInTime => _checkInTime;
  int get checkOutTime => _checkOutTime;
  int get roomTotal => _roomTotal;
  bool get loading => _bookingLoading;
  String get errorMessage => _errorMessage;
  Stream<RoomBaseResponse> get roomStream => _roomController.stream;

  @override
  void dispose() {
    _roomController.close();
    super.dispose();
  }
}
