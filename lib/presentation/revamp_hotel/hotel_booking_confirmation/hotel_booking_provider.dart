import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';

class HotelBookingProvider with ChangeNotifier {
  final _repository = Repository();

  Future<Null> bookHotel(RevampHotelListRequest revampHotelListRequest) async {
    //final result = await _repository.bookHotel(hotelId, roomCategoryId, totalAdult, totalRoom, checkIn, checkOut, roomName);
  }
}
