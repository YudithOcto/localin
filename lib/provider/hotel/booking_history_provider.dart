import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_detail.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';

class BookingHistoryProvider extends ChangeNotifier {
  Repository _repository;
  bool _showSearchHotel = false;
  int _offset = 1, _total = 10;
  int totalPage = 0;
  List<BookingDetail> historyList = [];

  BookingHistoryProvider() {
    _repository = Repository();
  }

  void resetParams() {
    _offset = 1;
    historyList = [];
  }

  Future<BookingHistoryBaseResponse> getBookingHistoryList() async {
    final result = await _repository.getBookingHistoryList(_offset, _total);
    if (result != null && result?.detail != null && result.detail.isNotEmpty) {
      _offset += 1;
      totalPage = result.total;
      historyList.addAll(result.detail);
      notifyListeners();
      return result;
    } else {
      return null;
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
