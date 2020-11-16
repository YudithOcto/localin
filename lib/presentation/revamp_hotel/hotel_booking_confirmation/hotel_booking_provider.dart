import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/model/transaction/discount_status.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';

class HotelBookingProvider with ChangeNotifier {
  final _repository = Repository();

  HotelBookingProvider(int price) {
    initPriceList(price);
  }

  Future<BookHotelResponse> bookHotel(RevampHotelListRequest request,
      int hotelId, RoomAvailability selectedRoom) async {
    final result = await _repository.bookHotel(
        hotelId,
        selectedRoom.categoryId,
        request,
        selectedRoom.categoryName,
        _status?.couponValue ?? '',
        _status?.isUsingLocalPoint ?? 0);
    return result;
  }

  Future<BookingPaymentResponse> getMiniDanaUrl(String bookingId) async {
    return await _repository.bookingPayment(bookingId);
  }

  Future<Null> initPriceList(int price) async {
    final form = FormData.fromMap({
      'kupon': '',
      'use_poin': 0,
      'harga': price,
    });
    final response = await _repository.getTransactionDiscount(form);
    _priceData = response.priceData;
    notifyListeners();
  }

  DiscountStatus _status;
  setDiscountStatus(DiscountStatus stat) {
    _status = stat;
    notifyListeners();
  }

  PriceData _priceData;
  PriceData get priceData => _priceData;
  int get baseTax => _priceData != null ? _priceData.baseTax : 0;
  int get baseService => _priceData != null ? _priceData.baseService : 0;
  set inputPriceData(PriceData value) {
    _priceData = value;
    notifyListeners();
  }
}
