import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_facilitity_response_model.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';

const DEFAULT_PRICE_HIGHEST = 2000000.0;
const DEFAULT_PRICE_LOWEST = 0.0;

class HotelListFilterProvider with ChangeNotifier {
  HotelListFilterProvider() {
    _selectedFacilities.add('All');
  }

  double _currentHighest = DEFAULT_PRICE_HIGHEST;

  double get currentHighest => _currentHighest;

  set changeHighest(double value) {
    _currentHighest = value;
    notifyListeners();
  }

  double _currentLowest = DEFAULT_PRICE_LOWEST;

  double get currentLowest => _currentLowest;

  set changeLowest(double value) {
    _currentLowest = value;
    notifyListeners();
  }

  List<String> _selectedFacilities = [];

  bool isFacilitySelected(String id) {
    if (_selectedFacilities.contains(id)) {
      return true;
    }
    return false;
  }

  set selectFacility(String id) {
    if (_selectedFacilities.contains(id)) {
      _selectedFacilities.remove(id);
    } else {
      _selectedFacilities.add(id);
    }
    notifyListeners();
  }

  void resetFilter() {
    _selectedFacilities.clear();
    _selectedFacilities.add('All');
    _currentHighest = DEFAULT_PRICE_HIGHEST;
    _currentLowest = DEFAULT_PRICE_LOWEST;
    notifyListeners();
  }

  RevampHotelListRequest get request {
    return RevampHotelListRequest(
      minPrice: _currentLowest,
      maxPrice: _currentHighest,
      facilities: _selectedFacilities,
    );
  }

  final _repository = Repository();

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;

  int get pageRequest => _pageRequest;

  List<HotelFacilityDetailModel> _facilityList = List();

  List<HotelFacilityDetailModel> get facilityList => _facilityList;

  final _streamController = StreamController<searchState>.broadcast();

  Stream<searchState> get stream => _streamController.stream;

  Future<Null> getFacility({bool isRefresh = true}) async {
    if (isRefresh) {
      _pageRequest = 1;
      _facilityList.clear();
      _canLoadMore = true;
    }

    if (!_canLoadMore) return;
    _streamController.add(searchState.loading);
    final response = await _repository.getHotelFacilityList(_pageRequest);
    if (response != null && response.total > 0) {
      _streamController.add(searchState.success);
      _pageRequest += 1;
      _facilityList.addAll(response.model);
      _canLoadMore = _facilityList.length < response.total;
    } else {
      _streamController.add(searchState.empty);
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
