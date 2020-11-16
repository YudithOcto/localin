import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/location/search_location_response.dart';

class SearchLocationProvider with ChangeNotifier {
  final Repository _repository = Repository();
  final TextEditingController locationController = TextEditingController();
  Timer t;
  AnalyticsService _analyticsService;
  bool _isDispose = false;

  SearchLocationProvider({AnalyticsService analyticsService}) {
    _analyticsService = analyticsService;
    locationController..addListener(_onSearchChanged);
  }

  _onSearchChanged() async {
    if (t != null && t.isActive) {
      t.cancel();
    }
    t = Timer(Duration(milliseconds: 400), () {
      if (!_isDispose) {
        _analyticsService.setCustomSearchEvent(
            keyword: locationController.text);
        loadLocationData(isRefresh: true);
      }
    });
  }

  int _offset = 1;

  int get offset => _offset;

  int _limit = 20;
  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  final StreamController<locationState> _streamController =
      StreamController<locationState>.broadcast();

  Stream<locationState> get locationStream => _streamController.stream;

  List<LocationResponseDetail> _searchList = [];

  List<LocationResponseDetail> get searchList => _searchList;

  Future<Null> loadLocationData({bool isRefresh = true}) async {
    _streamController.add(locationState.loading);
    if (isRefresh) {
      _offset = 1;
      _searchList.clear();
      _canLoadMore = true;
    }
    if (!_canLoadMore) {
      _streamController.add(locationState.empty);
      return;
    }

    final result = await _repository.searchLocation(
        offset: _offset, limit: _limit, search: locationController.text);
    if (result != null &&
        result.detail != null &&
        (result.detail.isNotEmpty || result.detail.isNotEmpty)) {
      _searchList.addAll(result.detail);
      _offset += 1;
      _canLoadMore = result.total > _searchList.length;
      _streamController.add(locationState.success);
    } else {
      _canLoadMore = false;
      _streamController.add(locationState.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    locationController.dispose();
    _streamController.close();
    _isDispose = true;
    super.dispose();
  }
}

enum locationState { loading, success, empty }
