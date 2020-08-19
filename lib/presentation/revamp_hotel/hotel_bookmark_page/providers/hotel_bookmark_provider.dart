import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';

class HotelBookmarkProvider with ChangeNotifier {
  HotelBookmarkProvider(RevampHotelListRequest request) {
    _hotelListRequest = request;
    getHotelBookmarkList(isRefresh: true);
  }

  RevampHotelListRequest _hotelListRequest = RevampHotelListRequest();

  final _repository = Repository();

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  List<HotelDetailEntity> _hotelList = List();
  List<HotelDetailEntity> get hotelList => _hotelList;

  final _streamController = StreamController<RoomState>.broadcast();
  Stream<RoomState> get stream => _streamController.stream;

  Future<Null> getHotelBookmarkList({bool isRefresh = true}) async {
    if (isRefresh) {
      _canLoadMore = true;
      _hotelList.clear();
      _pageRequest = 1;
    }
    final result = await _repository.getHotelBookmarkList(_hotelListRequest);
    if (result != null && result.total > 0) {
      _hotelList.addAll(result.hotelDetailEntity);
      _canLoadMore = _hotelList.length < result.total;
      _pageRequest += 1;
      _streamController.add(RoomState.success);
    } else {
      _streamController.add(RoomState.empty);
      _canLoadMore = false;
    }
    notifyListeners();
  }

  changeBookmarkLocally(int index) {
    _hotelList[index].isBookmark = !_hotelList[index].isBookmark;
    notifyListeners();
  }

  Future<String> unBookmark(HotelDetailEntity detail) async {
    final result =
        await _repository.changeBookmarkStatus('unbookmark', detail.hotelId);
    if (!result.error) {
      _hotelList.remove(detail);
      notifyListeners();
    }
    return result?.message;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
