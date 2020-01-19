class BookingDetailResponse {
  String error;
  String message;
  BookingDetailModel data;

  BookingDetailResponse({this.error, this.message, this.data});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> body) {
    return BookingDetailResponse(
      error: null,
      message: body['message'],
      data: BookingDetailModel.fromJson(body['data']),
    );
  }

  BookingDetailResponse.withError(String value)
      : error = value,
        data = null,
        message = null;
}

class BookingDetailModel {
  int hotelId;
  String name;
  String street;
  String state;
  String country;
  String bookingId;
  String invoiceCode;
  int responseId;
  String currencyCode;
  int userPrice;
  int checkIn;
  int checkOut;
  String status;
  String updatedAt;

  BookingDetailModel(
      {this.hotelId,
      this.name,
      this.street,
      this.state,
      this.country,
      this.bookingId,
      this.invoiceCode,
      this.responseId,
      this.currencyCode,
      this.userPrice,
      this.checkIn,
      this.checkOut,
      this.status,
      this.updatedAt});

  factory BookingDetailModel.fromJson(Map<String, dynamic> body) {
    return BookingDetailModel(
      hotelId: body['hotel_id'],
      name: body['name'],
      street: body['street'],
      state: body['state'],
      country: body['country'],
      bookingId: body['booking_id'],
      invoiceCode: body['invoice_kode'],
      responseId: body['response_id'],
      currencyCode: body['currencyCode'],
      userPrice: body['hargaUser'],
      checkOut: body['checkout'],
      checkIn: body['checkin'],
      status: body['status'],
      updatedAt: body['updated_at'],
    );
  }
}
