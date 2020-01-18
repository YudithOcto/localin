import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';

class BookingHistoryProvider extends ChangeNotifier {
  Repository _repository;
  bool _showSearchHotel = false;

  BookingHistoryProvider() {
    _repository = Repository();
  }

  Future<List<BookingHistoryDetail>> getBookingHistory(
      int offset, int limit) async {
    final result = await _repository.getBookingHistory(offset, limit);
    if (result != null && result.error == null) {
      return result.detail;
    } else {
      throw Exception();
    }
  }

  void setRoomPage(bool value) {
    this._showSearchHotel = value;
    notifyListeners();
  }

  bool get showSearchHotel => _showSearchHotel;
}
