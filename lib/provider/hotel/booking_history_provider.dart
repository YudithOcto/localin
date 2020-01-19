import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_detail.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';

class BookingHistoryProvider extends ChangeNotifier {
  Repository _repository;
  bool _showSearchHotel = false;

  BookingHistoryProvider() {
    _repository = Repository();
  }

  Future<List<BookingDetail>> getBookingHistoryList(
      int offset, int limit) async {
    final result = await _repository.getBookingHistoryList(offset, limit);
    if (result != null && result.error == null) {
      return result.detail;
    } else {
      throw Exception();
    }
  }

  Future<BookingDetailResponse> getBookingHistoryDetail(
      String bookingDetailId) async {
    final result = await _repository.getBookingDetail(bookingDetailId);
    return result;
  }

  void setRoomPage(bool value) {
    this._showSearchHotel = value;
    notifyListeners();
  }

  bool get showSearchHotel => _showSearchHotel;
}
