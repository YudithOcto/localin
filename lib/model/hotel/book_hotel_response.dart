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
  String hotelId;
  String roomId;
  String roomCount;
  String adultCount;
  String checkIn;
  String checkOut;
  String status;
  String responseId;
  String invoiceCode;
  String currencyCode;
  String entityId;
  int finalAmount;
  int userPrice;
  String cancellationPolicy;

  BookHotelDetailResponse(
      {this.bookingId,
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
      this.cancellationPolicy});

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
    );
  }
}
