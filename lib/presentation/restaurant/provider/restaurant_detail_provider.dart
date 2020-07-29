import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';

class RestaurantDetailProvider with ChangeNotifier {
  final _streamController = StreamController<eventState>.broadcast();
  get stream => _streamController.stream;

  final _repository = Repository();

  RestaurantDetail _restaurantDetail = RestaurantDetail();
  get restaurantDetail => _restaurantDetail;

  Future<Null> getRestaurantDetail(String restaurantId) async {
    _streamController.add(eventState.loading);
    final response = await _repository.getRestaurantDetail(restaurantId);
    _restaurantDetail = response.detail;
    _streamController
        .add(response.error ? eventState.empty : eventState.success);
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
