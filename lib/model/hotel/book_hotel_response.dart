import 'package:localin/model/hotel/booking_detail_response.dart';

class BookHotelResponse {
  String error;
  String message;
  BookHotelDetailResponse detail;

  BookHotelResponse({this.error, this.message, this.detail});

  factory BookHotelResponse.fromJson(Map<String, dynamic> body) {
    return BookHotelResponse(
      error: null,
      message: body['message'],
      detail: BookHotelDetailResponse.fromJson(body['data']),
    );
  }

  BookHotelResponse.withError(String value)
      : error = value,
        message = null,
        detail = null;
}

class BookHotelDetailResponse {
  String bookingId;
  String memberId;
  int hotelId;
  int roomId;
  int roomCount;
  int adultCount;
  int checkIn;
  int checkOut;
  String status;
  String responseId;
  String invoiceCode;
  String currencyCode;
  String entityId;
  int finalAmount;
  int userPrice;
  String cancellationPolicy;
  String expiredAt;
  String hotelImage;
  HotelDetailModel hotelDetail;
  String roomName;

  BookHotelDetailResponse({
    this.bookingId,
    this.memberId,
    this.hotelId,
    this.roomId,
    this.roomCount,
    this.adultCount,
    this.checkIn,
    this.checkOut,
    this.status,
    this.responseId,
    this.invoiceCode,
    this.currencyCode,
    this.entityId,
    this.finalAmount,
    this.userPrice,
    this.cancellationPolicy,
    this.expiredAt,
    this.hotelImage,
    this.hotelDetail,
    this.roomName,
  });

  factory BookHotelDetailResponse.fromJson(Map<String, dynamic> body) {
    return BookHotelDetailResponse(
      bookingId: body['booking_id'],
      memberId: body['member_id'],
      hotelId: body['hotel_id'],
      roomId: body['room_id'],
      roomCount: body['room_count'],
      adultCount: body['adult_count'],
      checkIn: body['checkin'],
      checkOut: body['checkout'],
      status: body['status'],
      responseId: body['response_id'],
      invoiceCode: body['invoice_kode'],
      currencyCode: body['currencyCode'],
      entityId: body['entityId'],
      finalAmount: body['finalAmount'],
      userPrice: body['hargaUser'],
      cancellationPolicy: body['cancellationPolicy'],
      roomName: body['room_name'],
      expiredAt: body['expired_at'] ?? null,
      hotelImage: body['hotel_image'] ?? null,
      hotelDetail: body['hotel_detail'] != null
          ? HotelDetailModel.fromJson(body['hotel_detail'])
          : null,
    );
  }
}
