import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/date_helper.dart';

class HotelDetailProvider extends BaseModelProvider {
  Repository _repository;

  HotelDetailProvider() {
    _repository = Repository();
  }

  Future<HotelListBaseResponse> getHotelDetail(int hotelID) async {
    // TODO CHANGE TO LIVE CHECK IN AND CHECKOUT DONT BE 6 MONTH
    final checkInDev = DateTime.now().add(Duration(days: 200));
    final checkOutDev = DateTime.now().add(Duration(days: 201));
    print('${DateHelper.formatDateRangeToString(checkInDev)}');

    final response =
        await _repository.getHotelDetail(hotelID, checkInDev, checkOutDev);
    return response;
  }
}
