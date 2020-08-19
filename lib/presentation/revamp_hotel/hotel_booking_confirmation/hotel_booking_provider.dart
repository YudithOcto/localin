import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';

class HotelBookingProvider with ChangeNotifier {
  final _repository = Repository();

  Future<BookHotelResponse> bookHotel(RevampHotelListRequest request,
      int hotelId, RoomAvailability selectedRoom) async {
    final result = await _repository.bookHotel(
        hotelId, selectedRoom.categoryId, request, selectedRoom.categoryName);
    return result;
  }

  Future<BookingPaymentResponse> getMiniDanaUrl(String bookingId) async {
    return await _repository.bookingPayment(bookingId);
  }
}
