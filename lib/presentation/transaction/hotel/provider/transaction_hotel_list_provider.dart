import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_detail.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';

class TransactionHotelListProvider with ChangeNotifier {
  final _repository = Repository();

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  List<BookingDetail> _hotelList = List();
  List<BookingDetail> get hotelList => _hotelList;

  final _streamController = StreamController<eventState>.broadcast();
  Stream<eventState> get hotelListStream => _streamController.stream;

  Future<Null> getHotelList({bool isRefresh = true}) async {
    final result = await _repository.getBookingHistoryList(_pageRequest, 10);
    _streamController.add(eventState.loading);
    if (result != null && result.total > 0) {
      _hotelList.addAll(result.detail);
      _pageRequest += 1;
      _canLoadMore = result.total > _hotelList.length;
      _streamController.add(eventState.success);
    } else {
      _streamController.add(eventState.empty);
      _canLoadMore = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
